from datetime import time as datetime_time  
from datetime import datetime, timedelta
import re
from string import punctuation
import time
from django.http import JsonResponse
from .utils import get_tiqets_products  # Import the function from utils.py
from .utils import get_places  # Import the function from utils.py
from .utils import generate_itinerary  # Import the function from utils.py
from .utils import get_tags
from .utils import fetch_city_image
from rapidfuzz import fuzz
import json
from geopy.distance import geodesic
from core.utils import fetch_unsplash_image
from core.utils import fetch_google_place_image, fetch_opening_hours
import threading


# Define the mapping dictionary
category_mapping = {
    "Art Gallery": ["art_gallery"],
    "Museum": ["museum"],
    "Monument": ["monument", "cultural_landmark", "historical_place"],
    "Theater": ["performing_arts_theater", "auditorium"],
    "Cinema": ["movie_theater"],
    "Water Park": ["water_park"],
    "Amusement Park": ["amusement_park", "roller_coaster"],
    "Park": ["park", "state_park", "national_park", "garden"],
    "Zoo": ["zoo"],
    "Aquarium": ["aquarium"],
    "Wildlife Park": ["wildlife_park", "wildlife_refuge"],
    "Beach": ["beach"],
    "Botanical Garden": ["botanical_garden"],
    "Stadium": ["stadium", "arena", "sports_complex", "athletic_field"],
    "Playground": ["playground"],
    "Hiking Area": ["hiking_area"],
    "Karaoke": ["karaoke"],
    "Comedy Club": ["comedy_club"],
    "Night Club": ["night_club", "dance_hall"],
    "Casino": ["casino"],
    "Restaurant": ["restaurant", "cafe", "fast_food_restaurant"],
    "Steak House": ["steak_house", "bar_and_grill"],
    "Local Cuisine": ["fine_dining_restaurant"]
}

tiqets_category_mapping = {
  "Monument": ["440", "444", "436", "443"],
  "Museum": ["442"],
  "Art Gallery": ["442"],
  "Amusement Park": ["434"],
  "Zoo": ["449"],
  "Aquarium": ["449"],
  "Botanical Garden": ["439"],
  "Wildlife Park": ["439"],
  "Park": ["439"],
  "Restaurant": ["601"],
  "Local Cuisine": ["601"],
  "Stadium": ["447"],
  "Playground": ["599"],
  "Theater": ["438"],
  "Cinema": ["438"]
}

tiqets_remove_categories = ["500", "468", "437", "599", "601"]

def city_image(request):
    """
    Fetch an image of a city based on the name provided in the request.
    Example: /city-image/?city_name=Paris
    """
    city_name = request.GET.get("city_name", None)
    
    if not city_name:
        return JsonResponse({"error": "city_name parameter is required."}, status=400)
    # Fetch city image
    result = fetch_city_image(city_name)
    return JsonResponse(result)

def get_associated_categories(categories, mapping):
    return [subcategory for category in categories if category in mapping for subcategory in mapping[category]]

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

def tags(request):
    return JsonResponse(get_tags(), safe=False)

def fetch_places(lat, lng, radius, categories):
    return get_places(lat, lng, radius, categories).get('places', [])

def fetch_tiqets(lat, lng, radius, num_days):
    return get_tiqets_products(lat, lng, radius, num_days).get('products', [])

def get_itinerary(request):
    """
    Fetch places from Google Places API and return them as JSON.
    Example URL: http://127.0.0.1:8000/generate/?lat=48.864716&lng=2.349014&radius=10&start_date=2024-11-23&end_date=2024-11-30&start_time=9&end_time=15&num_seniors=0&num_adults=2&num_youth=0&num_children=1&budget=Cheap
                 http://127.0.0.1:8000/generate/?lat=45.4642&lng=9.1900&radius=5&start_date=2024-11-23&end_date=2024-11-30&start_time=9&end_time=15&num_seniors=0&num_adults=2&num_youth=0&num_children=1&budget=Cheap
                 http://127.0.0.1:8000/generate/?lat=45.4642&lng=9.1900&radius=5&start_date=2024-11-23&end_date=2024-11-30&start_time=9:00&end_time=15:00&num_seniors=0&num_adults=2&num_youth=0&num_children=1&budget=Cheap&required_places=Duomo%20di%20Milano,Pinacoteca%20di%20Brera&removed_places=Sforzesco%20Castle
                 http://127.0.0.1:8000/generate/?lat=45.4642&lng=9.1900&radius=5&start_date=2024-11-23&end_date=2024-11-30&start_time=9:00&end_time=15:00&num_seniors=0&num_adults=2&num_youth=0&num_children=1&budget=Cheap&required_places=Sforzesco%20Castle&required_places=Pinaoteca%20di%20Brera&removed_places=Duomo%20di%20Milano
    """
    try:
        # Extract and validate query parameters
        lat = float(request.GET.get('lat', 0))
        lng = float(request.GET.get('lng', 0))
        radius = int(request.GET.get('radius', 5000))  # Default radius = 5000 meters
        categories = request.GET.get('categories', '')  # Retrieve the value as a string
        categories_list = [category.strip() for category in categories.split(',')] if categories else []


        mapped_categories = get_associated_categories(categories_list, category_mapping)
        tiqets_categories = get_associated_categories(categories_list, tiqets_category_mapping)

        start_date = datetime.strptime(request.GET.get('start_date'), "%Y-%m-%d")
        end_date = datetime.strptime(request.GET.get('end_date'), "%Y-%m-%d")
        start_time = datetime.strptime(request.GET.get('start_time'), "%H:%M")
        end_time = datetime.strptime(request.GET.get('end_time'), "%H:%M")
        num_seniors = int(request.GET.get('num_seniors', 0))
        num_adults = int(request.GET.get('num_adults', 0))
        num_youth = int(request.GET.get('num_youth', 0))
        num_children = int(request.GET.get('num_children', 0))
        budget = request.GET.get('budget', '').lower()  # Normalize budget string
        required_places = request.GET.getlist('required_places', [])  # Fetch as list if provided
        removed_places = request.GET.getlist('removed_places', [])  # Fetch as list if provided
        # Validate logical constraints

        num_days = (end_date - start_date).days + 1

        if start_date > end_date:
            return JsonResponse({'error': 'start_date must be before end_date.'}, status=400)
        if start_date.date() == end_date.date() and start_time.time() >= end_time.time():
            return JsonResponse({'error': 'start_time must be before end_time on the same day.'}, status=400)
        if radius <= 0:
            return JsonResponse({'error': 'radius must be a positive integer.'}, status=400)
    except (ValueError, TypeError) as e:
        return JsonResponse({'error': f'Invalid input: {str(e)}'}, status=400)
    
    
    try:
        # Fetch data from external sources
        places_data = []
        tiqets_data = []

        places_thread = threading.Thread(target=lambda: places_data.extend(fetch_places(lat, lng, radius, mapped_categories) or []))
        tiqets_thread = threading.Thread(target=lambda: tiqets_data.extend(fetch_tiqets(lat, lng, radius, num_days) or []))

        places_thread.start()
        tiqets_thread.start()

        places_thread.join()
        tiqets_thread.join()

        merged_data = merge_places_tiqets(places_data, tiqets_data)

        places_info = get_places_info(merged_data, budget)

        start_day = start_date.date()
        end_day = end_date.date()
        start_hour = start_time.time()
        end_hour = end_time.time()

        itinerary = generate_itinerary(
            lat, lng, start_day, end_day, start_hour, end_hour,
            num_seniors, num_adults, num_youth, num_children, budget, places_info, required_places, removed_places, categories
        )

        # Debugging information
        final_output = merge_gemini_places(merged_data, itinerary, budget, lat, lng)

        return JsonResponse(final_output, safe=False)
    except Exception as e:
        return JsonResponse({'error': f'An unexpected error occurred: {str(e)}'}, status=500)

def get_places_info(merged_data, budget):
    places = []

    for place_name, place_data in merged_data.items():
        if place_data['products'] == {}:  
            places.append({
                'name': place_name,
                'product_title': 'N/A',
                'price': 'N/A',
                'summary': 'N/A',
            })
        else:
            product = get_product(list(place_data['products'].values()), budget)

            if product:
                places.append({
                    'name': place_name,
                    'product_title': product['title'],
                    'price': product['price'],
                    'summary': product['description'],
                })
                
    return places

# Get the product that fits the user's budget
def get_product(products, budget):
    """
    Selects a product from a list of products based on the given budget.
    """

    if budget == 'cheap':
        return min(products, key=lambda x: x['price'])
    elif budget == 'balanced':
        return sorted(products, key=lambda x: x['price'])[len(products) // 2]
    else:
        return max(products, key=lambda x: x['rating'])

def merge_gemini_places(merged_places_x_tiqets, gemini_response_str, budget, lat, lng):
    """
    Merge the places from Gemini with the places retrieved from Tiqets and Places API.
    """

    gemini_response = json.loads(gemini_response_str)

    gemini_response = gemini_response["response"]

    for itinerary in gemini_response["itineraries"]:
        for attraction in itinerary["attractions"]:
            name = attraction["name"]
            date = attraction["day"]
            time = attraction["startingHour"]

            if name in merged_places_x_tiqets:
                products = merged_places_x_tiqets[name].get('products', {})

                if products:
                    if len(products) > 1:
                        product = get_product(list(products.values()), budget)
                    else:
                        product = list(products.values())[0]

                    url = merged_places_x_tiqets[name]['products'][list(merged_places_x_tiqets[name]['products'].keys())[0]]['product_checkout_url']
                    url += f"?selected_date={date}"
                    product["product_checkout_url"] = url

                    attraction.update({
                        "lat": merged_places_x_tiqets[name]["lat"],
                        "lng": merged_places_x_tiqets[name]["lng"],
                        "city": merged_places_x_tiqets[name]['products'][list(merged_places_x_tiqets[name]['products'].keys())[0]]['city'],
                        "country": merged_places_x_tiqets[name]['products'][list(merged_places_x_tiqets[name]['products'].keys())[0]]['country'],
                        "product": product,
                    })
                else:
                    city = merged_places_x_tiqets[name].get('city', 'N/A')
                    country = merged_places_x_tiqets[name].get('country', 'N/A')
    
                    attraction.update({
                        "lat": merged_places_x_tiqets[name]["lat"],
                        "lng": merged_places_x_tiqets[name]["lng"],
                        "photos": fetch_google_place_image(name),
                        "city": city,
                        "country": country,
                        "accessibilityOptions": merged_places_x_tiqets[name].get('accessibilityOptions', 'N/A'),
                        "editorialSummary": merged_places_x_tiqets[name].get('editorialSummary', 'N/A'),
                    })

            else:
                attraction.update({
                    "lat": lat,
                    "lng": lng,
                })

    return gemini_response

def merge_places_tiqets(places_data, tiqets_data): 
    """
    Merges place data with Tiqets data based on matching scores.
    This function takes two datasets: places_data and tiqets_data, and merges them into a single dictionary.
    The merging is based on a matching score between places and venues. If the score is above a certain threshold,
    the place and venue are considered a match and their data is combined. The function also handles cases where
    places or venues do not have a match.
    Parameters:
    places_data (list): A list of dictionaries containing place information.
    tiqets_data (list): A list of dictionaries containing Tiqets venue information.
    Returns:
    dict: A dictionary where the keys are place names or venue names and the values are dictionaries containing
          merged information from both datasets.
    """

    # Group products by venue
    grouped_products = group_products_by_venue(tiqets_data)

    merged = {}

    venue_to_remove = set()


    venue_to_remove = set()
    # Create a dictionary for quick lookup of places by name
    places_dict = {place['displayName']['text']: place for place in places_data}

    for place_name, place in places_dict.items():
        for venue_name, venue_info in grouped_products.items():
            score = match_score(venue_info, place)

            if score > 0.7:
                merged[place_name] = {
                    'place': place_name,
                    'lat': place['location']['latitude'],
                    'lng': place['location']['longitude'],
                    'photos': place.get('photos', []),
                    'currentOpeningHours': place.get('currentOpeningHours', 'N/A'),
                    'venue': venue_info.get('name'),
                    'categories': place.get('types', []),
                    'rating': place.get('rating', 'N/A'),
                    'num_reviews': place.get('userRatingCount', 'N/A'),
                    'accessibilityOptions': place.get('accessibilityOptions', 'N/A'),
                    'editorialSummary': place.get('editorialSummary', 'N/A'),
                    'products': {product['title']: {
                            'title': product.get('title', 'N/A'),
                            'price': product.get('price', 'N/A'),
                            'summary': product.get('summary', 'N/A'),
                            'city': product.get('city_name', 'N/A'),
                            'country': product.get('country_name', 'N/A'),
                            'product_checkout_url': product.get('product_checkout_url', 'N/A'),
                            'rating': product['ratings'].get('average', 'N/A'),
                            'description': product.get('tagline', ''),
                            'images': product.get('images', []),
                            'whats_included': product.get('whats_included', 'N/A'),
                            'sale_status': product.get('sale_status', 'N/A'),
                            'tag_ids': product.get('tag_ids', []),
                            'wheelchair_access': product.get('wheelchair_access', 'N/A'),
                            } for product in grouped_products[venue_info.get('name')].get('products')}
                }

                venue_to_remove.add(venue_name)
                break

                
                # Delete marked venues after iteration
        for venue_name in venue_to_remove:
            grouped_products.pop(venue_name, None)
    #places.accessibilityOptions,places.allowsDogs,places.editorialSummary,places.reviews
    # Add remaining Places that did not match any venue
    for place_name, place in places_dict.items():    
        if place_name not in merged:
            addressComponents = place.get('addressComponents', [])

            city = 'N/A'
            
            for component in addressComponents:
                if 'country' in component['types']:
                    country = component['longText']
                if 'locality' in component['types'] or 'postal_town' in component['types']:
                    city = component['longText']

            merged[place_name] = {
                'place': place_name,
                'lat': place['location']['latitude'],
                'lng': place['location']['longitude'],
                'city': city,
                'country': country,
                'photos': place.get('photos', []),
                'currentOpeningHours': place.get('currentOpeningHours', 'N/A'),
                'venue': 'N/A',
                'categories': place.get('types', []),
                'rating': place.get('rating', 'N/A'),
                'num_reviews': place.get('userRatingCount', 'N/A'),
                'accessibilityOptions': place.get('accessibilityOptions', 'N/A'),
                'editorialSummary': place.get('editorialSummary', 'N/A'),
                'products': {}
            }

    # Add remaining Tiqets venues that did not match any place
    for venue_name, venue_info in grouped_products.items():
        average_rating = get_average_rating_from_tiqets(venue_info.get('products'))
        total_ratings = get_amount_of_rating_from_tiqets(venue_info.get('products'))
        
        merged[venue_name] = {
            'place': venue_name,
            'lat': venue_info['lat'],
            'lng': venue_info['lng'],
            'photos': [],
            'currentOpeningHours': 'N/A',
            'venue': venue_info.get('name'),
            'categories': [],
            'rating': average_rating,
            'num_reviews': total_ratings,
            'products': {product['title']: {
                    'title': product.get('title', 'N/A'),
                    'price': product.get('price', 'N/A'),
                    'summary': product.get('summary', 'N/A'),
                    'city': product.get('city_name', 'N/A'),
                    'country': product.get('country_name', 'N/A'),
                    'product_checkout_url': product.get('product_checkout_url', 'N/A'),
                    'rating': product['ratings'].get('average', 'N/A'),
                    'description': product.get('tagline', ''),
                    'images': product.get('images', []),
                    'whats_included': product.get('whats_included', 'N/A'),
                    'sale_status': product.get('sale_status', 'N/A'),
                    'tag_ids': product.get('tag_ids', []),
                    'wheelchair_access': product.get('wheelchair_access', 'N/A'),
                    } for product in venue_info.get('products')}
        }

    return merged



def group_products_by_venue(products):
    """
    Group products by venue and return a dictionary with the grouped products.
    Each venue will have a list of products associated with it.
    """

    grouped_products = {}

    for product in products:
        # Extract venue info
        isValid = True

        venue = product.get('venue', {})
        venue_name = venue.get('name', "Unknown Venue")
        address = venue.get('address', "Unknown Address")
        city_name = product.get('city_name', "Unknown City")
        lat, lng = product['geolocation'].get('lat'), product['geolocation'].get('lng')
        tag_ids = product.get('tag_ids', [])

        for tag_id in tag_ids:
            if tag_id in tiqets_remove_categories:
                isValid = False
        
        if not isValid:
            continue

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

    print("Number of places from tiqets: ", len(grouped_products))

    return grouped_products


def match_score(venue, place):
    """
    Calculate a match score between a venue and a place based on their names, addresses, and geographical coordinates.

    Args:
        venue (dict): Information about the venue, including 'name', 'address', 'city', 'lat', and 'lng'.
        place (dict): Information about the place, including 'displayName', 'shortFormattedAddress', 
                      'formattedAddress', and 'location' (containing 'latitude' and 'longitude').

    Returns:
        float: A match score between 0 and 1, where higher values indicate a stronger match.
    """
    
    name_score = fuzz.token_set_ratio(place['displayName']['text'].lower(), venue['name'].lower()) / 100

    # Compare addresses (you could use a more sophisticated method for address normalization)
    venue_address1 = f"{venue['address']}, {venue['city']}"
    venue_address2 = f"{venue['name']}, {venue['address']}, {venue['city']}"

    if place.get('shortFormattedAddress'):
        address_score1 = fuzz.token_sort_ratio(venue_address1.lower(), place['shortFormattedAddress'].lower())
        address_score2 = fuzz.token_sort_ratio(venue_address2.lower(), place['shortFormattedAddress'].lower())
    else:
        address_score1 = fuzz.token_sort_ratio(venue_address1.lower(), place['formattedAddress'].lower())
        address_score2 = fuzz.token_sort_ratio(venue_address1.lower(), place['formattedAddress'].lower())

    address_score = max(address_score1, address_score2) / 100

    # Compare coordinates (geodesic distance)
    venue_coords = (venue['lat'], venue['lng'])
    place_coords = (place['location']['latitude'], place['location']['longitude'])

    distance = geodesic(venue_coords, place_coords).meters

    coord_score = max(0, 1 - (distance / 1000))  # Normalize to a max distance of 1 km

    # Calculate total score (weight based on importance)
    total_score = (name_score * 0.5) + (address_score * 0.3) + (coord_score * 0.2)
        
    return total_score


def get_average_price_from_tiqets(venue_products):
    prices = [product.get('price') for product in venue_products if isinstance(product.get('price'), (int, float))]
    
    if prices:
        return sum(prices) / len(prices)
    return 0  # Return 0 if there are no products with prices


def order_tiqets_by_price(venue_products):
    sorted_products = sorted(
        venue_products,
        key=lambda product: product.get('price', float('inf'))  # Use 'inf' if price is missing
    )

    sorted_id_price_pairs = [(product.get('id'), product.get('price')) for product in sorted_products]

    return sorted_id_price_pairs


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


def extract_keywords(text):
    text = text.lower()
    text = re.sub(f"[{re.escape(punctuation)}]", "", text)
    words = text.split()
    stopwords = {"the", "a", "an", "and", "or", "to", "as", "you", "your", "of", "its", "it", "in", "is", "for", "on"}
    filtered_words = [word for word in words if word not in stopwords]

    return list(filtered_words)


def get_descriptions(products):
    all_keywords = []

    for prod in products:
        if prod.get('tagline'):
            desc = prod.get('tagline')
            keywords = extract_keywords(desc)
            all_keywords.extend(keywords)
            
    return list(all_keywords)


def get_amount_of_rating_from_tiqets(venue_products):
    total = 0

    for product in venue_products:
        if product.get('ratings'):
            total += product.get('ratings').get('total')

    return total


def get_place_opening_hours(place):
  """
  Returns the opening hours of a place.
  If the place is open 24/7, it creates the data structure to represent that. By Google conventions, a place open 24/7 will
    have only the opening time of the first day of the week at midnight, with no closing time.
  Returns None if the opening hours are not avaiable.
  """

  opening_hours = None

  if place:
    if place.get('regularOpeningHours'):
      if place.get('regularOpeningHours').get('periods'):
        opening_hours = place.get('regularOpeningHours').get('periods')

        # if open 24/7
        if opening_hours[0].get('close') is None:
          opening_hours[0]['close'] = {
              'day': 0,
              'hour': 23,
              'minute': 59
            }
          for i in range(1, 7):
            opening_hours.append({
                'open': {
                  'day': i,
                  'hour': 0,
                  'minute': 0
                },
                'close': {
                  'day': i,
                  'hour': 23,
                  'minute': 59
                }
              }
            )

  return opening_hours


def tiqets(request):
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


# !!! This function is NOT used in the current implementation, for the merge use merge_places_tiqets function !!!
def merge_tiqets_and_places(lat, lng, radius):
    """
    Fetch places from Google Places API and Tiqets API and return them as JSON.
    Example URL: /merge/?lat=45.4642&lng=9.1900&radius=5
    """
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

    # placesXtiqets
    for place in places_data:
        for venue_name, venue_info in grouped_products.items():
            score = match_score(venue_info, place)
            average_price = get_average_price_from_tiqets(venue_info.get('products'))
            tiqets_by_price_asc = order_tiqets_by_price(venue_info.get('products'))
            average_rating = get_average_rating_from_tiqets(venue_info.get('products'))
            opening_hours = get_place_opening_hours(place)
            if score > 0.7:

                tiqetsXplaces.append({
                    'place': place['displayName']['text'],
                    'lat': place['location']['latitude'],
                    'lng': place['location']['longitude'],
                    'venue': venue_info.get('name'),
                    'id': place.get('id'),
                    'average_price': average_price,
                    'tiqets_by_price': tiqets_by_price_asc,
                    'rating': place.get('rating'),
                    'tiqets_average_rating': average_rating,
                    'categories': place.get('types'),
                    'score': score,
                    'opening_hours': opening_hours
                })

    # places
    for place in places_data:
        if not any(place['displayName']['text'] in item['place'] for item in tiqetsXplaces):
            opening_hours = get_place_opening_hours(place)
            places_only.append({
                'place': place['displayName']['text'],
                'rating': place.get('rating'),
                'categories': place.get('types'),
                'venue': "No matching Venue",
                'average_price': None,
                'opening_hours': opening_hours,
                'score': 0
            })

    # tiqets
    for venue_name, venue_info in grouped_products.items():
        if not any(venue_info.get('name') in item['venue'] for item in tiqetsXplaces):

            descriptions = get_descriptions(venue_info.get('products'))
            average_price = get_average_price_from_tiqets(venue_info.get('products'))
            total_ratings = get_amount_of_rating_from_tiqets(venue_info.get('products'))
            tiqets_by_price_asc = order_tiqets_by_price(venue_info.get('products'))
            average_rating = get_average_rating_from_tiqets(venue_info.get('products'))

            tiqets_only.append({
                'venue': venue_info.get('name'),
                'average_price': average_price,
                'tiqets_by_price': tiqets_by_price_asc,
                'tiqets_average_rating': average_rating,
                'total_ratings': total_ratings,
                'place': "No matching Place",
                'description':  descriptions,
                'score': 0
            })

    merged_data = {"tiqetsXplaces": tiqetsXplaces, "places_only":places_only, "tiqets_only":tiqets_only}
    return merged_data


def is_open(date, hours):
    """
    Given the date and the opening hours, check if the place is open at some time of the day
    """
    # Check if hours is valid
    if not hours:
        return False

    # Adjust to match 0=Sunday, ..., 6=Saturday
    day_of_week = (date.weekday() + 1) % 7

    for period in hours:
        day = period['open']['day']
        if day == day_of_week:
            #open_hour = int(period['open']['hour'])
            #open_minute = int(period['open']['minute'])
            #open_time = datetime_time(open_hour,open_minute)

            #close_hour = int(period['close']['hour'])
           # close_minute = int(period['close']['minute'])
            #close_time = datetime_time(close_hour, close_minute)

            # Check if the current time falls within the open and close times
            #if open_time <= date.time() <= close_time:
                return True
    return False


def amount_of_open_days(opening_hours, arrival_date, departure_date):
    """
    Return the amount of open days a place has given the arrival and departure dates
    """
    if not opening_hours:
        return 0  # If no opening hours are provided, assume closed

    count = 0
    current_date = arrival_date
    while current_date <= departure_date:
        if (
            (current_date == arrival_date and is_open(current_date, opening_hours)) or
            (current_date == departure_date and is_open(current_date, opening_hours))
        ):
            count += 1
        else:
            if any(is_open(
                        datetime.combine(current_date.date(), time(hour=h['open']['hour'], minute=h['open']['minute'])), 
                        opening_hours) 
                    for h in opening_hours):
                count += 1

        current_date += timedelta(days=1)

    return count


def remove_unavailable_places(merged_data, start_date, end_date):
    """
    Remove places that do not match with the user's dates
    """
    for tiqetXplace in merged_data.get("tiqetsXplaces"):
        opening_hours = tiqetXplace.get('opening_hours')
        if amount_of_open_days(opening_hours, start_date, end_date) == 0:
            merged_data.get("tiqetsXplaces").remove(tiqetXplace)

    for place in merged_data.get("places_only"):
        opening_hours = place.get('opening_hours')
        if amount_of_open_days(opening_hours, start_date, end_date) == 0:
            merged_data.get("places_only").remove(place)

    return merged_data

  
def calculate_place_common_categories(place_categories, user_preferred_categories):
    if (len(user_preferred_categories)>0):
        user_preferred_categories_set = set(user_preferred_categories)

        common = user_preferred_categories_set.intersection(place_categories)
        return len(common) / len(user_preferred_categories)
    return 0

'''
def calculate_tiqets_common_categories(products, user_preferred_categories):
    categories = set()

    for product, product_info in products.items():
        for tag_id in product_info.get('tag_ids', []):
            if tag_id not in categories:
                categories.add(tag_id)

    print("Categories: ", categories)

    if (len(user_preferred_categories)>0):
        user_preferred_categories_set = set(user_preferred_categories)

        common = user_preferred_categories_set.intersection(categories)

        print("Common: ", common)
        
        return len(common) / len(user_preferred_categories)
    
    return 0
'''

def calculate_weighted_rating(rating, num_reviews, global_average_rating, min_reviews=10):

    if num_reviews == 0:
        return 0

    weighted_rating = (rating * num_reviews + global_average_rating * min_reviews) / (num_reviews + min_reviews)
    return weighted_rating


def recommend(lat, lng, radius, start_date, end_date, categories, budget):
    merged_data = merge_tiqets_and_places(lat, lng, radius)

    # Remove places that are never open during the user's visit
    # merged_data = remove_unavailable_places(merged_data, start_date, end_date)

    recommendations = []

    for tiqetXplace in merged_data.get("tiqetsXplaces"):
        rating = tiqetXplace.get('rating', 0)  # rating value between 0 and 5
        normalized_rating = rating / 5  # rating value between 0 and 1

        category_score = calculate_place_common_categories(tiqetXplace.get('categories', []), categories)  # category accuracy value between 0 and 1

        recommendation_score = 0
        recommendation_score = (normalized_rating * 0.35) + (category_score * 0.65)

        # *** Added Unsplash Integration ***
        #unsplash_image = fetch_unsplash_image(tiqetXplace.get('place'))

        recommendations.append({
            'type': 'tiqetsXplaces',
            'place': tiqetXplace.get('place'),
            'venue': tiqetXplace.get('venue'),
            'average_price': tiqetXplace.get('average_price'),
            'recommended_score': recommendation_score,
            'saved': True,
            #'image': unsplash_image  # Add Unsplash image to the response
        })

    for place in merged_data.get("places_only"):
        rating = place.get('rating', 0)  # rating value between 0 and 5
        normalized_rating = rating / 5  # rating value between 0 and 1

        category_score = calculate_place_common_categories(place.get('categories', []), categories)  # category accuracy value between 0 and 1

        recommendation_score = 0
        recommendation_score = (normalized_rating * 0.35) + (category_score * 0.65)

        # *** Added Unsplash Integration ***
        unsplash_image = fetch_unsplash_image(place.get('place'))

        recommendations.append({
            'type': 'places_only',
            'place': place.get('place'),
            'venue': place.get('venue'),
            'average_price': place.get('average_price'),
            'recommended_score': recommendation_score,
            'saved': True,
            'image': unsplash_image  # Add Unsplash image to the response
        })

    global_average_rating = sum(item['tiqets_average_rating']
                                for item in merged_data.get("tiqets_only")
                                if item['tiqets_average_rating']) / len(merged_data.get("tiqets_only"))

    for tiqet in merged_data.get("tiqets_only"):
        rating = tiqet.get('tiqets_average_rating', 0)  # rating value between 0 and 10
        total_ratings = tiqet.get('total_ratings')
        weighted_rating = calculate_weighted_rating(rating, total_ratings, global_average_rating)
        normalized_rating = weighted_rating / 5  # rating value between 0 and 1

        category_score = calculate_place_common_categories(tiqet.get('categories', []), categories)

        recommendation_score = 0
        recommendation_score = (normalized_rating * 0.35) + (category_score * 0.65)

        # *** Added Unsplash Integration ***
        unsplash_image = fetch_unsplash_image(tiqet.get('place'))

        recommendations.append({
            'type': 'tiqets_only',
            'place': tiqet.get('place'),
            'venue': tiqet.get('venue'),
            'average_price': tiqet.get('average_price'),
            'recommended_score': recommendation_score,
            'saved': True,
            'image': unsplash_image  # Add Unsplash image to the response
        })

    if budget == 'Cheap':
        recommendations = sorted(
            (rec for rec in recommendations if rec.get('average_price') is not None),
            key=lambda rec: rec['average_price']
        )

    top_recommendations = sorted(recommendations, key=lambda rec: rec['recommended_score'], reverse=True)[:10]

    return top_recommendations



def get_recommendations(request):
    """
    Fetch places from Google Places API and return them as JSON.
    Example URL: http://127.0.0.1:8000/recommendations/?lat=45.4642&lng=9.1900&radius=5&start_date=2024-11-29T10:00:00&end_date=2024-11-30T18:00:00&categories=Museums%20and%20Galleries,Historical%20Sites&budget=Cheap
    """
    # Extract query parameters from the request
    lat = request.GET.get('lat')
    lng = request.GET.get('lng')
    radius = request.GET.get('radius')
    start_date = request.GET.get('start_date')
    end_date = request.GET.get('end_date')
    categories = request.GET.get('categories', [])
    budget = request.GET.get('budget')

    try:
        lat = float(lat)
        lng = float(lng)
        radius = int(radius)
        start_date = datetime.strptime(start_date, "%Y-%m-%dT%H:%M:%S")
        end_date = datetime.strptime(end_date, "%Y-%m-%dT%H:%M:%S")
    except ValueError:
        return JsonResponse({'error': 'Invalid latitude, longitude, or radius values.'}, status=400)

    recomendations = recommend(lat, lng, radius, start_date, end_date, categories, budget)

    return JsonResponse(recomendations, safe=False)


# http://127.0.0.1:8000/get_top10/?lat=45.4642&lng=9.1900&radius=5&start_date=2024-11-29&end_date=2024-11-30&categories=Museums%20and%20Galleries,Historical%20Sites&budget=Cheap
def get_top10(request):
    """
    Get the top 10 recommendations based on the user's preferences.
    """
    try:
        # Extract and validate query parameters
        lat = float(request.GET.get('lat', 0))
        lng = float(request.GET.get('lng', 0))
        radius = int(request.GET.get('radius', 5000))  # Default radius = 5000 meters
        categories = request.GET.get('categories', '')  # Retrieve the value as a string
        categories_list = [category.strip() for category in categories.split(',')] if categories else []
        start_time = datetime.strptime(request.GET.get('start_time'), "%H:%M")
        end_time = datetime.strptime(request.GET.get('end_time'), "%H:%M")
        mapped_categories = get_associated_categories(categories_list, category_mapping)
        tiqets_categories = get_associated_categories(categories_list, tiqets_category_mapping)
        start_date = datetime.strptime(request.GET.get('start_date'), "%Y-%m-%d")
        end_date = datetime.strptime(request.GET.get('end_date'), "%Y-%m-%d")

        budget = request.GET.get('budget', '').lower()  # Normalize budget string

        num_days = (end_date - start_date).days + 1
        # Validate logical constraints
        if start_date > end_date:
            return JsonResponse({'error': 'start_date must be before end_date.'}, status=400)
        if start_date.date() == end_date.date() and start_time.time() >= end_time.time():
            return JsonResponse({'error': 'start_time must be before end_time on the same day.'}, status=400)
        if radius <= 0:
            return JsonResponse({'error': 'radius must be a positive integer.'}, status=400)
    except (ValueError, TypeError) as e:
        return JsonResponse({'error': f'Invalid input: {str(e)}'}, status=400)
    
    places_data = get_places(lat, lng, radius, mapped_categories).get("places", [])
    tiqets_categories = list(set(tiqets_categories))
    
    tiqets_data = get_tiqets_products(lat, lng, radius, num_days).get("products", [])

    filtered_tiqets_data = filter_tiqets_data(tiqets_data, tiqets_categories)

    if len(filtered_tiqets_data) == 0:
        merged_data = merge_places_tiqets(places_data, tiqets_data)
    else:
        merged_data = merge_places_tiqets(places_data, filtered_tiqets_data)

    recommendations = []

    for place_name, place_data in merged_data.items():
        rating = place_data.get('rating', 0) # rating value between 0 and 5
        num_reviews = place_data.get('num_reviews', 0)
        
        if num_reviews == 'N/A':
            num_reviews = 0

        global_average_rating = sum(float(item['rating']) for item in merged_data.values() if 'rating' in item and isinstance(item['rating'], (int, float)) and item['rating']) / len(merged_data)
        
        weighted_rating = calculate_weighted_rating(rating, num_reviews, global_average_rating)
        
        normalized_rating = weighted_rating / 5 # rating value between 0 and 1

        category_score = calculate_place_common_categories(place_data.get('categories', []), mapped_categories) # category accuracy value between 0 and 1

        recommendation_score = 0
        recommendation_score = (normalized_rating * 0.35) + (category_score * 0.65)

        place_data_with_score = {
            'place': place_name,
            'photos': [],
            'products': place_data.get('products', {}),
            'product_photos': {},
        }

        place_data_with_score['recommended_score'] = recommendation_score

        recommendations.append(place_data_with_score)

    top_recommendations = sorted(
        recommendations, key=lambda rec: rec["recommended_score"], reverse=True
    )[:10]

    for rec in top_recommendations:
        products = rec.get('products', {})

        if rec.get('products') != {}:
            if len(products) > 1:
                product = get_product(list(rec['products'].values()), budget)
            else:
                product = list(products.values())[0]

            rec['product_photos'] = product.get('images', [])
            rec.pop('products', None)
        else:
            rec['photos'] = fetch_google_place_image(rec['place'])
            rec.pop('products', None)


    return JsonResponse(top_recommendations, safe=False)

def filter_tiqets_data(tiqets_data, categories):
    """
    Filter Tiqets data based on the provided categories.
    Args:
        tiqets_data (list): A list of dictionaries containing Tiqets venue information.
        categories (list): A list of categories to filter by.
    Returns:
        list: A filtered list of Tiqets venues that match the categories.
    """
    filtered_data = []

    for product in tiqets_data:
        if any(category in product.get('tag_ids', []) for category in categories):
            filtered_data.append(product)
    
    return filtered_data


