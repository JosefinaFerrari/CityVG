import requests
from django.conf import settings
import os
import json
from google.ai.generativelanguage_v1beta.types import content
import google.generativeai as genai

# Documentation for google places nearby search https://developers.google.com/maps/documentation/places/web-service/nearby-search?hl=it
 
def get_places(lat, lng, radius, categories=None):
    '''
    Fetch places (attractions, events, etc.) from the Google Places API based on location and radius.
    '''
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
        "rankPreference": "POPULARITY"  # Removed as it's not supported in Nearby Search (New)
    }

    # Apply categories filter if provided
    if categories:
        request_body["includedTypes"] = categories

    # FieldMask to specify the fields to return (displayName is essential)
    field_mask = "places.name,places.displayName,places.shortFormattedAddress,places.location,places.types,places.rating,places.regularOpeningHours"

    # Headers, including the API key and FieldMask
    headers = {
        "Content-Type": "application/json",
        "X-Goog-Api-Key":  settings.GOOGLE_PLACES_API_KEY,
        "X-Goog-FieldMask": field_mask,
    }

    try:
        # Make the POST request
        response = requests.post(api_url, json=request_body, headers=headers)

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

def generate_itinerary(lat, lng, start_date, end_date, start_hour, end_hour, num_seniors, num_adults, num_youth, num_children, budget, places, required_places, removed_places):
    genai.configure(api_key=settings.GEMINI_API_KEY)

    # Create the model
    generation_config = {
    "temperature": 0.5,
    "top_p": 0.95,
    "top_k": 40,
    "max_output_tokens": 8192,
    "response_schema": content.Schema(
        type = content.Type.OBJECT,
        properties = {
        "response": content.Schema(
            type = content.Type.OBJECT,
            properties = {
            "itineraries": content.Schema(
                type = content.Type.ARRAY,
                items = content.Schema(
                type = content.Type.OBJECT,
                properties = {
                    "itineraryName": content.Schema(
                    type = content.Type.STRING,
                    ),
                    "attractions": content.Schema(
                    type = content.Type.ARRAY,
                    items = content.Schema(
                        type = content.Type.OBJECT,
                        properties = {
                        "name": content.Schema(
                            type = content.Type.STRING,
                        ),
                        "startingHour": content.Schema(
                            type = content.Type.STRING,
                        ),
                        "endingHour": content.Schema(
                            type = content.Type.STRING,
                        ),
                        "day": content.Schema(
                            type = content.Type.STRING,
                        ),
                        },
                    ),
                    ),
                },
                ),
            ),
            },
        ),
        },
    ),
    "response_mime_type": "application/json",
    }

    model = genai.GenerativeModel(
    model_name="gemini-1.5-flash",
    generation_config=generation_config,
    system_instruction="Consider a scenario in which a user wants to visit a place for a given number of days X. You will receive an object with those fields: \n        'City: lat={lat} lng={lng}' (latitude and longitude of the city)\n        'Start Date: {start_date}' (when the user will arrive in the city)\n        'End Date: {end_date}' (when the user will leave the city)\n        'Start Hour: {start_hour}' (the hour the user will arrive)\n        'End Hour: {end_hour}' (the hour the user is going to leave)\n        'Number of Seniors: {num_seniors}' (65 or above)\n        'Number of Adults: {num_adults}' (24 - 65)\n        'Number of Youth: {num_youth}' (13 - 24)\n        'Number of Children: {num_children}' (younger than 24)\n        'Budget: {budget}' (Cheap/Balanced/Luxury/Flexible)\n        'Places: {places_str}'\n          'Required places: {required_places}'\n          'Removed places: {removed_places}'\nplaces_str will contain a list of attractions to visit in a city, required_places will contain a list of places that must always be included in an itinerary, and removed_places will contain a list of places that must never be included in an itinerary.\nBased on this information, you must return 3 different itineraries. An itinerary lasts X days and starts when the user arrives (time of arrival) and ends when he/she departs (time of departure). \nEach itinerary should include the places in required_places plus the places you consider the best to visit, based on reviews and ratings of those places, should not contain the places in removed_places, and each one should differ from the other and focus more on different attractions. Arrange the places in an order that allows the user to visit them in the most efficient way. In addition, for each attraction, make an estimation of average time spent to visit the attraction and assign the starting_hours (that is when the visit starts )and ending_hours (that is when the visit should finish). You must schedule each visit to ensure there is some spare time (of at least an hour) between any two consecutive visits and consider the time to reach the next attraction. Give a name to each generated itinerary.\nSome of the places will also have a list of available products (such as tours or visits to a place). If there are multiple products, select the one that fits better based on the user preferences. If there are products that include multiple attractions give the productName in just the first attraction.\n",
    )

    chat_session = model.start_chat(
    history=[
    ]
    )

    places_str = json.dumps(places)
    
    input = (
        f'City: lat={lat} lng={lng}\n'
        f'Start Date: {start_date}\n'
        f'End Date: {end_date}\n'
        f'Start Hour: {start_hour}\n'
        f'End Hour: {end_hour}\n'
        f'Number of Seniors: {num_seniors}\n'
        f'Number of Adults: {num_adults}\n'
        f'Number of Youth: {num_youth}\n'
        f'Number of Children: {num_children}\n'
        f'Budget: {budget}\n'
        f'Places: {places_str}\n'
        f'Required places: {required_places}\n'
        f'Removed places: {removed_places}\n'
    )

    response = chat_session.send_message(input)

    print(response.text)
    return response.text
