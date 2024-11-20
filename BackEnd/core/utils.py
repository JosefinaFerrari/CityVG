import requests
from django.conf import settings

# Documentation for google places nearby search https://developers.google.com/maps/documentation/places/web-service/nearby-search?hl=it

def get_places_in_city_foursquare(city):
    api_url = "https://api.foursquare.com/v3/places/search"

    headers = {
        "Accept": "application/json",
        "Authorization": settings.FOURSQUARE_API_KEY
    }

    params = {
        "near": city,
        "query": "all places to visit or to see",
        "limit": 50
    }

    try:
        # Make the GET request to the Tiqets API
        response = requests.get(api_url, headers=headers, params=params)
        
        # Check if the response status is OK
        if response.status_code == 200:
            return response.json()  # Return the JSON response with the data
        else:
            return {'error': 'Failed to fetch data from Tiqets API', 'status_code': response.status_code}
    except Exception as e:
        return {'error': str(e)}
    
def get_places(lat, lng, radius, categories=None):
    api_url = "https://places.googleapis.com/v1/places:searchNearby"

    # Define the JSON body of the request
    request_body = {
        "locationRestriction": {
            "circle": {
                "center": {
                    "latitude": float(lat),
                    "longitude": float(lng)
                },
                "radius": int(radius * 1000)  # Convert radius to meters
            }
        },
        "includedTypes": [
            "art_gallery",
            "monument",
            "museum",
            "cultural_landmark",
            "historical_place",
            "church",
            "mosque",
            "hindu_temple",
            "synagogue",
            "wildlife_park",
            "park",
            "zoo",
            "plaza",
            "aquarium"
        ],
        "maxResultCount": 20,
        # "rankPreference": "POPULARITY"  # Removed as it's not supported in Nearby Search (New)
    }
    
    # Apply categories filter if provided
    if categories:
        request_body["includedTypes"] = categories

    # FieldMask to specify the fields to return (displayName is essential)
    field_mask = "places.displayName,places.shortFormattedAddress,places.location,places.types" 

    # Headers, including the API key and FieldMask
    headers = {
        "Content-Type": "application/json",
        "X-Goog-Api-Key": settings.GOOGLE_PLACES_API_KEY,
        "X-Goog-FieldMask": field_mask, 
    }

    try:
        # Make the POST request
        response = requests.post(api_url, json=request_body, headers=headers)
        
        print(response.json())

        # Check if the response status is OK
        if response.status_code == 200:
            return response.json() 
        else:
            return {'error': 'Failed to fetch data from Places API', 'status_code': response.status_code}
    except Exception as e:
        return {'error': str(e)}



def get_tiqets_products(lat, lng, radius, page=1, page_size=100):
    """
    Fetch products (attractions, events, etc.) from the Tiqets API based on location and radius.

    Args:
        lat (float): Latitude of the location.
        lng (float): Longitude of the location.
        radius (int): Maximum search radius in meters.
        page (int, optional): Page number for pagination. Defaults to 1.
        page_size (int, optional): Number of results per page. Defaults to 100.

    Returns:
        dict: JSON response from Tiqets API with product data.
    """
    api_url = "https://api.tiqets.com/v2/products"

    # Headers for the API request
    headers = {
        "Content-Type": "application/json",
        "Authorization": f"Token {settings.TIQETS_API_KEY}",  # Using the API key from settings
    }
    
    # Parameters for the API request
    params = {
        "lat": lat,
        "lng": lng,
        "max_distance": radius,
        "sort": "popularity desc",  # Sorting by popularity in descending order
        "page": page,
        "page_size": page_size,
    }
    
    try:
        # Make the GET request to the Tiqets API
        response = requests.get(api_url, headers=headers, params=params)
        
        # Check if the response status is OK
        if response.status_code == 200:
            return response.json()  # Return the JSON response with the data
        else:
            return {'error': 'Failed to fetch data from Tiqets API', 'status_code': response.status_code}
    except Exception as e:
        return {'error': str(e)}

