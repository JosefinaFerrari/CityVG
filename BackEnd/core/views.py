from datetime import time as datetime_time  
from datetime import datetime, timedelta
import re
from string import punctuation
import time
from django.http import JsonResponse
from .utils import get_tiqets_products  # Import the function from utils.py
from .utils import get_places  # Import the function from utils.py
from .utils import generate_itinerary  # Import the function from utils.py
from rapidfuzz import fuzz
import json
from geopy.distance import geodesic
from core.utils import fetch_unsplash_image


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


def get_itinerary(request):
    """
    Fetch places from Google Places API and return them as JSON.
    Example URL: http://127.0.0.1:8000/generate/?lat=48.864716&lng=2.349014&radius=10&start_date=2024-11-23&end_date=2024-11-30&start_time=9&end_time=15&num_seniors=0&num_adults=2&num_youth=0&num_children=1&budget=Cheap
                 http://127.0.0.1:8000/generate/?lat=45.4642&lng=9.1900&radius=5&start_date=2024-11-23&end_date=2024-11-30&start_time=9&end_time=15&num_seniors=0&num_adults=2&num_youth=0&num_children=1&budget=Cheap
                 http://127.0.0.1:8000/generate/?lat=45.4642&lng=9.1900&radius=5&start_date=2024-11-23&end_date=2024-11-30&start_time=9:00&end_time=15:00&num_seniors=0&num_adults=2&num_youth=0&num_children=1&budget=Cheap&required_places=Duomo%20di%Milano&required_places=Pinacoteca%20di%20Brera&removed_places=Sforzesco%20Castle
                 http://127.0.0.1:8000/generate/?lat=45.4642&lng=9.1900&radius=5&start_date=2024-11-23&end_date=2024-11-30&start_time=9:00&end_time=15:00&num_seniors=0&num_adults=2&num_youth=0&num_children=1&budget=Cheap&required_places=Sforzesco%20Castle&required_places=Pinaoteca%20di%20Brera&removed_places=Duomo%20di%20Milano
    """
    try:
        # Extract and validate query parameters
        lat = float(request.GET.get('lat', 0))
        lng = float(request.GET.get('lng', 0))
        radius = int(request.GET.get('radius', 5000))  # Default radius = 5000 meters
        categories = request.GET.getlist('categories', [])  # Fetch as list if provided
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
        if start_date >= end_date:
            return JsonResponse({'error': 'start_date must be before end_date.'}, status=400)
        if radius <= 0:
            return JsonResponse({'error': 'radius must be a positive integer.'}, status=400)
    except (ValueError, TypeError) as e:
        return JsonResponse({'error': f'Invalid input: {str(e)}'}, status=400)
    
    
    try:
        # Fetch data from external sources
        
        start_time = time.time()
        places_data = get_places(lat, lng, radius).get('places', [])
        end_time = time.time()

        print(f"Execution time for places: {end_time - start_time} seconds")

        start_time = time.time()
        tiqets_data = get_tiqets_products(lat, lng, radius).get('products', [])
        end_time = time.time()

        print(f"Execution time for tiqets: {end_time - start_time} seconds")

        start_time = time.time()
        merged_data = merge_places_tiqets(places_data, tiqets_data)
        end_time = time.time()

        print(f"Execution time for merging: {end_time - start_time} seconds")

        # Generate recommendations and itinerary
        start_day = start_date.date()
        start_hour = start_date.time()
        end_day = end_date.date()
        end_hour = end_date.time()

        places_info = get_places_info(merged_data)

        print(places_info)

        start_time = time.time()
        itinerary = generate_itinerary(
            lat, lng, start_day, end_day, start_hour, end_hour,
            num_seniors, num_adults, num_youth, num_children, budget, places_info, required_places, removed_places
        )
        end_time = time.time()

        print(f"Execution time for gemini: {end_time - start_time} seconds")

        start_time = time.time()
        final_output = merge_gemini_places(merged_data, itinerary)
        end_time = time.time()

        print(f"Execution time for merging gemini and places: {end_time - start_time} seconds")

        return JsonResponse(final_output, safe=False)
    except Exception as e:
        return JsonResponse({'error': f'An unexpected error occurred: {str(e)}'}, status=500)

def get_places_info(merged_data):
    places = []

    for place_name, place_data in merged_data.items():
        places.append(place_name)

    return places

def merge_gemini_places(merged_places_x_tiqets, gemini_response_str):
    gemini_response = json.loads(gemini_response_str)
    gemini_response = gemini_response["response"]

    for itinerary in gemini_response["itineraries"]:
        for attraction in itinerary["attractions"]:
            name = attraction["name"]
            date = attraction["day"]
            time = attraction["startingHour"]

            if name in merged_places_x_tiqets:
                url = merged_places_x_tiqets[name]['products'][list(merged_places_x_tiqets[name]['products'].keys())[0]]['product_checkout_url']
                url += f"?selected_date={date}&selected_timeslot_id={time}"

                # *** Added Unsplash Integration ***
                unsplash_image = fetch_unsplash_image(name)

                attraction.update({
                    "lat": merged_places_x_tiqets[name]["lat"],
                    "lng": merged_places_x_tiqets[name]["lng"],
                    "city": merged_places_x_tiqets[name]['products'][list(merged_places_x_tiqets[name]['products'].keys())[0]]['city'],
                    "country": merged_places_x_tiqets[name]['products'][list(merged_places_x_tiqets[name]['products'].keys())[0]]['country'],
                    "products": [{
                        "name": product["title"],
                        "price": product["price"],
                        "product_checkout_url": url,
                        "images": merged_places_x_tiqets[name]['products'][product["title"]]["images"],
                        "whats_included": merged_places_x_tiqets[name]['products'][product["title"]]["whats_included"],
                        "sale_status": merged_places_x_tiqets[name]['products'][product["title"]]["sale_status"],
                    } for product in merged_places_x_tiqets[name]["products"].values()],
                    # Adding Unsplash image
                    "unsplash_image": unsplash_image
                })

    return gemini_response



def merge_places_tiqets(places_data, tiqets_data):    
    # Group products by venue
    grouped_products = group_products_by_venue(tiqets_data)

    merged = {}
    to_remove = set()

    # Create a dictionary for quick lookup of places by name
    places_dict = {place['displayName']['text']: place for place in places_data}

    for place_name, place in places_dict.items():
        for venue_name, venue_info in grouped_products.items():
            score = match_score(venue_info, place)
            if score > 0.7:
                # Fetch Unsplash image for the matched place
                unsplash_image = fetch_unsplash_image(place['displayName']['text'])

                merged[place['displayName']['text']] = {
                    'place': place_name,
                    'lat': place['location']['latitude'],
                    'lng': place['location']['longitude'],
                    'photos': place.get('photos', []),
                    'unsplash_image': unsplash_image,  # Add Unsplash image
                    'currentOpeningHours': place.get('currentOpeningHours', 'N/A'),
                    'venue': venue_info.get('name'),
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
                            } for product in grouped_products[venue_info.get('name')].get('products')}
                }

                to_remove.add(venue_name)
                break

        # Delete marked venues after iteration
        for venue_name in to_remove:
            grouped_products.pop(venue_name, None)

    # Process places that don't have matching venues
    for place_name, place in places_dict.items():
        if place_name not in merged:
            # Fetch Unsplash image for unmatched place
            unsplash_image = fetch_unsplash_image(place['displayName']['text'])

            merged[place['displayName']['text']] = {
                'place': place_name,
                'lat': place['location']['latitude'],
                'lng': place['location']['longitude'],
                'photos': place.get('photos', []),
                'unsplash_image': unsplash_image,  # Add Unsplash image
                'currentOpeningHours': place.get('currentOpeningHours', 'N/A'),
                'venue': None,
                'products': {}
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
    
    name_score = fuzz.token_set_ratio(place['displayName']['text'].lower(), venue['name'].lower()) / 100

    # Compare addresses (you could use a more sophisticated method for address normalization)
    venue_address1 = f"{venue['address']}, {venue['city']}"
    venue_address2 = f"{venue['name']}, {venue['address']}, {venue['city']}"

    address_score1 = fuzz.token_sort_ratio(venue_address1.lower(), place['shortFormattedAddress'].lower())
    address_score2 = fuzz.token_sort_ratio(venue_address2.lower(), place['shortFormattedAddress'].lower())

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
    total = 0
    count = 0
    for product in venue_products:
        if product.get('price'):
            count += 1
            total += product.get('price')

    if count> 0:
        return total/count


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
        unsplash_image = fetch_unsplash_image(tiqetXplace.get('place'))

        recommendations.append({
            'type': 'tiqetsXplaces',
            'place': tiqetXplace.get('place'),
            'venue': tiqetXplace.get('venue'),
            'average_price': tiqetXplace.get('average_price'),
            'recommended_score': recommendation_score,
            'saved': True,
            'image': unsplash_image  # Add Unsplash image to the response
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

def merge_places_tiqets_top_10(places_data, tiqets_data):
    # Group products by venue
    grouped_products = group_products_by_venue(tiqets_data)

    # Merge data from both sources
    merged = {}

    for place in places_data:
        matched = False
        for venue_name, venue_info in grouped_products.items():
            score = match_score(venue_info, place)
            if score > 0.7:
                # Calculate average price and rating
                average_price = get_average_price_from_tiqets(
                    venue_info.get("products")
                )
                average_rating = get_average_rating_from_tiqets(
                    venue_info.get("products")
                )

                # Construct products dictionary
                products_dict = {
                    product["title"]: {
                        
                        "images": product.get("images", []),
                       
                    }
                    for product in venue_info.get("products", [])
                }

                merged[place["displayName"]["text"]] = {
                   
                    "photos": place.get("photos", []),
                 
                    "products": products_dict,
                 
                }
                matched = True
                break  # Stop after the first match

        if not matched:
            # Include places without matching venues
            merged[place["displayName"]["text"]] = {
              
                "photos": place.get("photos", []),
               
            }

    return merged

def recommend_top_10(user_preferences):
    lat = user_preferences.get("lat")
    lng = user_preferences.get("lng")
    radius = user_preferences.get("radius")
    dates = user_preferences.get("dates")
    participants = user_preferences.get("participants")
    categories = user_preferences.get("categories")
    budget = user_preferences.get("budget")

    merged_data = merge_tiqets_and_places(lat, lng, radius)

    latt = float(lat)
    lngg = float(lng)
    radiuss = int(radius)
    # Fetch data from external sources
    places_data = get_places(latt, lngg, radiuss, categories).get("places", [])
    tiqets_data = get_tiqets_products(latt, lngg, radiuss).get("products", [])
    merged_dataa = merge_places_tiqets_top_10(places_data, tiqets_data)


    recommendations = []

    for tiqetXplace in merged_data.get("tiqetsXplaces"):
        rating = tiqetXplace.get('rating', 0) # rating value between 0 and 5
        normalized_rating = rating / 5 # rating value between 0 and 1

        category_score = calculate_place_common_categories(tiqetXplace.get('categories', []), categories) # category accuracy value between 0 and 1
        
        recommendation_score = 0
        recommendation_score = (normalized_rating * 0.35) + (category_score * 0.65)

        recommendations.append({
            'type': 'tiqetsXplaces',
            'lat': lat,
            'lng': lng,
            'place': tiqetXplace.get('place'),
            'venue': tiqetXplace.get('venue'),
            'average_price': tiqetXplace.get('average_price'),
            'recommended_score': round((recommendation_score * 4) + 1, 1),
            'saved':True
        })

    for place in merged_data.get("places_only"):
        recommendation_score = 0

        rating = place.get("rating", 0)  # rating value between 0 and 5
        normalized_rating = rating / 5  # rating value between 0 and 1

        category_score = calculate_place_common_categories(
            place.get("categories", []), categories
        )  # category accuracy value between 0 and 1

        recommendation_score = (normalized_rating * 0.35) + (category_score * 0.65)


        # Restructure the products inline
        flattened_products = {}
        for place_name, place_info in merged_dataa.items():
            inner_products = place_info.get("products", {})
            for product_name, product in inner_products.items():
                # Get the 'images' list and fetch the first image's 'extra_large' URL
                images = product.get("images", [])
                extra_large_image = images[0].get("extra_large") if images else None
                
                # Add the required fields to the flattened_products structure
                flattened_products[product_name] = {
                   
                    "images": {
                        "extra_large": extra_large_image
                    }
                }

        recommendations.append(
            {
                'lat': lat,
                'lng': lng,
                "place": tiqet.get("venue"),
                "average_price": tiqet.get("average_price"),
                "recommended_score": round((recommendation_score * 4) + 1, 1),
                "products": flattened_products,
            }
        )

    global_average_rating = sum(
        item["tiqets_average_rating"]
        for item in merged_data.get("tiqets_only", [])
        if len(merged_data.get("tiqets_only", [])) > 0 and item["tiqets_average_rating"]
    ) / len(merged_data.get("tiqets_only", []))

    for tiqet in merged_data.get("tiqets_only"):

        recommendation_score = 0

        rating = tiqet.get("tiqets_average_rating", 0)  # rating value between 0 and 10
        total_ratings = tiqet.get("total_ratings")

        weighted_rating = calculate_weighted_rating(
            rating, total_ratings, global_average_rating
        )

        normalized_rating = weighted_rating / 5  # rating value between 0 and 1

        category_score = calculate_place_common_categories(
            tiqet.get("categories", []), categories
        )

        recommendation_score = (normalized_rating * 0.35) + (category_score * 0.65)

        # Restructure the products inline
        flattened_products = {}
        for place_name, place_info in merged_dataa.items():
            inner_products = place_info.get("products", {})
            for product_name, product in inner_products.items():
                # Get the 'images' list and fetch the first image's 'extra_large' URL
                images = product.get("images", [])
                extra_large_image = images[0].get("extra_large") if images else None
                
                # Add the required fields to the flattened_products structure
                flattened_products[product_name] = {
                   
                    "images": {
                        "extra_large": extra_large_image
                    }
                }

        recommendations.append(
            {
                'lat': lat,
                'lng': lng,
                "place": tiqet.get("venue"),
                "average_price": tiqet.get("average_price"),
                "recommended_score": round((recommendation_score * 4) + 1, 1),
                "products": flattened_products,
            }
        )

    if budget == "Cheap":
        recommendations = sorted(
            (rec for rec in recommendations if rec.get("average_price") is not None),
            key=lambda rec: rec["average_price"],
        )

    top_recommendations = sorted(
        recommendations, key=lambda rec: rec["recommended_score"], reverse=True
    )[:10]

    return top_recommendations

def get_recommendations_top_10(request):
    """
    Fetch places from Google Places API and return them as JSON.
    Example URL: http://127.0.0.1:8000/recommendations/?lat=45.4642&lng=9.1900&radius=5&start_date=2024-11-29T10:00:00&end_date=2024-11-30T18:00:00&categories=Museums%20and%20Galleries,Historical%20Sites&budget=Cheap
    """
    # Extract query parameters from the request
    lat = request.GET.get("lat")
    lng = request.GET.get("lng")
    radius = request.GET.get("radius")
    start_date = request.GET.get("start_date")
    end_date = request.GET.get("end_date")
    categories = request.GET.get("categories", [])
    budget = request.GET.get("budget")

    recommendations = recommend_top_10(
        {
            "lat": lat,
            "lng": lng,
            "radius": radius,
            "categories": [],  # Add categories as an empty list
            "budget": budget,
            "dates": {"start_date": start_date, "end_date": end_date},
        }
    )

    return JsonResponse(recommendations, safe=False)
