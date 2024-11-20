from django.http import JsonResponse
from .utils import get_tiqets_products  # Import the function from utils.py
from .utils import get_places  # Import the function from utils.py
from rapidfuzz import fuzz
from geopy.distance import geodesic

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

    # Merge data from both sources
    merged_data = []

    for place in places_data:
        for venue_name, venue_info in grouped_products.items():
            score = match_score(venue_info, place)
            if score > 0.7:
                merged_data.append({
                    'place': place['displayName']['text'],
                    'venue': venue_info.get('name'),
                    'score': score
                })
    
    for place in places_data:
        if not any(place['displayName']['text'] in item['place'] for item in merged_data):
            merged_data.append({
                'place': place['displayName']['text'],
                'venue': "No matching Venue",
                'score': 0
            })

    for venue_name, venue_info in grouped_products.items():
        if not any(venue_info.get('name') in item['venue'] for item in merged_data):
            merged_data.append({
                'place': "No matching Place",
                'venue': venue_info.get('name'),
                'score': 0
            })
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
