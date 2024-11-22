from collections import Counter
import re
from string import punctuation
from django.http import JsonResponse
from .utils import get_tiqets_products  # Import the function from utils.py
from .utils import get_places  # Import the function from utils.py
from rapidfuzz import fuzz
from geopy.distance import geodesic

# Define the mapping dictionary
category_mapping = {
    "Museums and Galleries": ["museum", "art_gallery"],
    "Historical Sites": ["historical_place", "monument", "cultural_landmark"],
    "Performing Arts": ["performing_arts_theater", "concert_hall", "opera_house"],
    "Parks and Gardens": ["park", "botanical_garden", "state_park", "national_park", "garden"],
    "Amusement Parks": ["amusement_park", "water_park", "roller_coaster"],
    "Zoos and Aquariums": ["zoo", "aquarium", "wildlife_park"],
    "Adventure Activities": ["hiking_area", "off_roading_area", "adventure_sports_center"],
    "Beaches": ["beach"],
    "Hiking and Outdoors": ["national_park", "hiking_area"],
    "Playgrounds": ["playground"],
    "Nightlife": ["night_club", "bar", "comedy_club", "karaoke"],
    "Kids Entertainment": ["amusement_center", "childrens_camp"],
    "Local Cuisine": ["restaurant", "fine_dining_restaurant"]
}

def get_types_for_category(category):
    """
    Given a category, return the corresponding types.
    """
    return category_mapping.get(category, [])


def places(request):
    """
    Fetch places from Google Places API and return them as JSON.
    Example URL: /places/?lat=45.4642&lng=9.1900&radius=5
    """
    # Extract query parameters from the request
    lat = request.GET.get('lat')
    lng = request.GET.get('lng')
    radius = request.GET.get('radius')  # Default to 5000 meters if not provided
    
    # Convert lat, lng, and radius to the correct types
    try:
        lat = float(lat)
        lng = float(lng)
        radius = int(radius)
    except ValueError:
        return JsonResponse({'error': 'Invalid latitude, longitude, or radius values.'}, status=400)
    
    # Fetch data from Google Places API using the utility function
    places_data = get_places(lat, lng, radius)

    return JsonResponse(places_data, safe=False)

def group_products_by_venue(products):
    """
    Group products by venue and return a dictionary with the grouped products.
    Each venue will have a list of products associated with it.
    """
    grouped_products = {}

    for product in products:
        # Extract venue info
        venue = product.get('venue', {})
        venue_name = venue.get('name', "Unknown Venue")
        address = venue.get('address', "Unknown Address")
        city_name = product.get('city_name', "Unknown City")
        lat, lng = product['geolocation'].get('lat'), product['geolocation'].get('lng')

        # Group by venue name, initializing the venue entry if necessary
        venue_info = grouped_products.setdefault(venue_name, {
            'name': venue_name,
            'address': address,
            'products': [],
            'city': city_name,
            'lat': lat,
            'lng': lng
        })
        
        venue_info['products'].append(product)

    return grouped_products

def match_score(venue, place):
    """
    Calculate a match score between a product and a place based on their names.
    The score is calculated as the number of common words between the two names.
    """
    
    name_score = fuzz.token_sort_ratio(place['displayName']['text'].lower(), venue['name'].lower()) / 100

    # Compare addresses (you could use a more sophisticated method for address normalization)
    venue_address1 = f"{venue['address']}, {venue['city']}"
    venue_address2 = f"{venue['name']}, {venue['address']}, {venue['city']}"

    address_score1 = fuzz.token_sort_ratio(venue_address1, place['shortFormattedAddress'])
    address_score2 = fuzz.token_sort_ratio(venue_address2, place['shortFormattedAddress'])

    address_score = max(address_score1, address_score2) / 100

    # Compare coordinates (geodesic distance)
    venue_coords = (venue['lat'], venue['lng'])
    place_coords = (place['location']['latitude'], place['location']['longitude'])

    distance = geodesic(venue_coords, place_coords).meters

    coord_score = max(0, 1 - (distance / 1000))  # Normalize to a max distance of 1 km

    # Calculate total score (weight based on importance)
    total_score = (name_score * 0.4) + (address_score * 0.4) + (coord_score * 0.2)

    return total_score

def merge_tiqets_and_places(request):
    """
    Fetch places from Google Places API and Tiqets API and return them as JSON.
    Example URL: /merge-tiqets-places/?lat=45.4642&lng=9.1900&radius=5
    """
    # Extract query parameters from the request
    lat = request.GET.get('lat')
    lng = request.GET.get('lng')
    radius = request.GET.get('radius')  # Default to 5000 meters if not provided
    
    # Convert lat, lng, and radius to the correct types
    try:
        lat = float(lat)
        lng = float(lng)
        radius = int(radius)
    except ValueError:
        return JsonResponse({'error': 'Invalid latitude, longitude, or radius values.'}, status=400)
    
    # Fetch data from Google Places API using the utility function
    places_data = get_places(lat, lng, radius).get('places', [])
    
    # Fetch data from Tiqets API using the utility function
    tiqets_data = get_tiqets_products(lat, lng, radius).get('products', [])
    
    # Group products by venue
    grouped_products = group_products_by_venue(tiqets_data)

    # Initialize categories
    tiqetsXplaces = []  # Matches between Tiqets and Places
    places_only = []    # Places without a matching Tiqets venue
    tiqets_only = []    # Tiqets venues without a matching Plac

    for place in places_data:
        for venue_name, venue_info in grouped_products.items():
            average_price = get_average_price_from_tiqets(venue_info.get('products'))
            tiqets_by_price_asc = order_tiqets_by_price(venue_info.get('products'))
            average_rating = get_average_rating_from_tiqets(venue_info.get('products'))

            score = match_score(venue_info, place)
            if score > 0.7:
                tiqetsXplaces.append({
                    'place': place['displayName']['text'],                    
                    'venue': venue_info.get('name'),                  
                    'average_price': average_price, 
                    'tiqets_by_price': tiqets_by_price_asc,                  
                    'rating': place.get('rating'),
                    'tiqets_average_rating': average_rating,
                    'categories': place.get('types'),
                    'score': score
                })
    
    for place in places_data:
        if not any(place['displayName']['text'] in item['place'] for item in tiqetsXplaces):
            places_only.append({
                'place': place['displayName']['text'],
                'rating': place.get('rating'),
                'categories': place.get('types'),
                'venue': "No matching Venue",
                'average_price': None,
                'score': 0
            })

    for venue_name, venue_info in grouped_products.items():
        if not any(venue_info.get('name') in item['venue'] for item in tiqetsXplaces):
            
            descriptions = get_descriptions(venue_info.get('products'))
            average_price = get_average_price_from_tiqets(venue_info.get('products'))
            tiqets_by_price_asc = order_tiqets_by_price(venue_info.get('products'))
            average_rating = get_average_rating_from_tiqets(venue_info.get('products'))

            tiqets_only.append({
                'venue': venue_info.get('name'),
                'average_price': average_price, 
                'tiqets_by_price': tiqets_by_price_asc, 
                'tiqets_average_rating': average_rating,
                'place': "No matching Place", 
                'description':  descriptions,
                'score': 0
            })

    merged_data= {"tiqetsXplaces": tiqetsXplaces, "places_only":places_only, "tiqets_only":tiqets_only}
    return JsonResponse(merged_data, safe=False)

def tiqets_products(request):
    """
    Fetch products from Tiqets API and return them as JSON.
    Example URL: /tiqets-products/?lat=52.3676&lng=4.9041&radius=5000
    """
    # Extract query parameters from the request
    lat = request.GET.get('lat')
    lng = request.GET.get('lng')
    radius = request.GET.get('radius', 5000)  # Default to 5000 meters if not provided
    
    if lat is None or lng is None:
        return JsonResponse({'error': 'Latitude and Longitude are required.'}, status=400)
    
    # Convert lat, lng, and radius to the correct types
    try:
        lat = float(lat)
        lng = float(lng)
        radius = int(radius)
    except ValueError:
        return JsonResponse({'error': 'Invalid latitude, longitude, or radius values.'}, status=400)

    # Fetch data from Tiqets API using the utility function
    products_data = get_tiqets_products(lat, lng, radius)

    return JsonResponse(products_data)

def get_average_price_from_tiqets(venue_products):
    total = 0
    count = 0 
    for product in venue_products:
        if product.get('price'):
            count += 1
            total += product.get('price')

    if count> 0:
        return total/count
    
def get_average_rating_from_tiqets(venue_products):
    total = 0
    count = 0 
    for product in venue_products:
        if product.get('ratings'):
            count += 1
            total += product.get('ratings').get('average')

    if count> 0:
        return total/count
    
    return 0

def order_tiqets_by_price(venue_products):
    sorted_products = sorted(
        venue_products, 
        key=lambda product: product.get('price', float('inf'))  # Use 'inf' if price is missing
    )
    
    sorted_id_price_pairs = [(product.get('id'), product.get('price')) for product in sorted_products]
    
    return sorted_id_price_pairs

def extract_keywords(text):
    text = text.lower()
    
    text = re.sub(f"[{re.escape(punctuation)}]", "", text)
    
    words = text.split()
    
    stopwords = {"the", "a", "an", "and", "or", "to", "as", "you", "your", "of", "its", "it", "in", "is", "for", "on"}
    filtered_words = [word for word in words if word not in stopwords]
    word_counts = Counter(filtered_words)

    return list(word_counts.keys())

def get_descriptions(products):
    all_keywords = []

    for prod in products:
        if prod.get('tagline'):
            desc = prod.get('tagline')
            
            # Extract keywords from the tagline
            keywords = extract_keywords(desc)
            all_keywords.extend(keywords)

    keyword_counts = Counter(all_keywords)
    
    return list(all_keywords)


def recommend(user_preferences):
        lat = user_preferences.get('lat')
        lng = user_preferences.get('lng')
        radius = user_preferences.get('radius')
        dates = user_preferences.get('dates')
        participants = user_preferences.get('participants')
        categories = user_preferences.get('categories')
        budget = user_preferences.get('budget')

        merged_data = merge_tiqets_and_places(lat, lng, radius)

        recommendations = []

        for tiqetXplace in merged_data.get("tiqetsXplaces"):
                recommendation_score = 0
                
                rating = tiqetXplace.get('rating', 0) # rating value between 0 and 5
                normalized_rating = rating / 5 # rating value between 0 and 1
                
                category_score = calculate_place_common_categories(tiqetXplace.get('categories', []), categories) # category accuracy value between 0 and 1
                
                recommendation_score = (normalized_rating * 0.4) + (category_score * 0.6)

                recommendations.append({
                        'type': 'tiqetsXplaces',
                        'place': tiqetXplace.get('place'),
                        'venue': tiqetXplace.get('venue'),                        
                        'average_price': tiqetXplace.get('average_price'),
                        'recommended_score': recommendation_score
                })   

        for place in merged_data.get("places_only"):
                recommendation_score = 0
                
                rating = place.get('rating', 0)  # rating value between 0 and 5
                normalized_rating = rating / 5 # rating value between 0 and 1

                category_score = calculate_place_common_categories(place.get('categories', []), categories) # category accuracy value between 0 and 1
                
                recommendation_score = (normalized_rating * 0.4) + (category_score * 0.6)
                
                recommendations.append({
                        'type': 'places_only',
                        'place': place.get('place'),                   
                        'venue': place.get('venue'),                             
                        'average_price': place.get('average_price'),
                        'recommended_score': recommendation_score
                })

        for tiqet in merged_data.get("tiqets_only"):       

                recommendation_score = 0
                
                rating = tiqet.get('tiqets_average_rating', 0) # rating value between 0 and 10
                normalized_rating = rating / 5 # rating value between 0 and 1

                category_score = calculate_place_common_categories(tiqet.get('categories', []), categories)
                                
                recommendation_score = (normalized_rating * 0.4) + (category_score * 0.6)

                recommendations.append({
                        'type': 'tiqets_only',
                        'place': tiqet.get('place'),                  
                        'venue': tiqet.get('venue'),                            
                        'average_price': tiqet.get('average_price'),
                        'recommended_score': recommendation_score
                })

        if budget == 'Cheap':
                recommendations = sorted(
                        (rec for rec in recommendations if rec.get('average_price') is not None),
                        key=lambda rec: rec['average_price']
                )

        top_recommendations = sorted(
                recommendations, 
                key=lambda rec: rec['recommended_score'], 
                reverse=True)[:10]


        return top_recommendations
    
def calculate_place_common_categories(place_categories, user_preferred_categories):
    if (len(user_preferred_categories)>0):
        user_preferred_categories_set = set(user_preferred_categories)

        common = user_preferred_categories_set.intersection(place_categories)
        return len(common) / len(user_preferred_categories)
    return 0