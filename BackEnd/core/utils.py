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
    "temperature": 0.4,
    "top_p": 0.95,
    "top_k": 40,
    "max_output_tokens": 8192,
    "response_schema": content.Schema(
        type = content.Type.OBJECT,
        enum = [],
        required = ["response"],
        properties = {
        "response": content.Schema(
            type = content.Type.OBJECT,
            enum = [],
            required = ["itineraries"],
            properties = {
            "itineraries": content.Schema(
                type = content.Type.ARRAY,
                items = content.Schema(
                type = content.Type.OBJECT,
                enum = [],
                required = ["itineraryName", "attractions"],
                properties = {
                    "itineraryName": content.Schema(
                    type = content.Type.STRING,
                    ),
                    "attractions": content.Schema(
                    type = content.Type.ARRAY,
                    items = content.Schema(
                        type = content.Type.OBJECT,
                        enum = [],
                        required = ["name", "startingHour", "endingHour", "day"],
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
    system_instruction="Here’s the text converted and formatted clearly:\nScenario:\n\nA user wants to visit a city for a specific number of days (X). You will receive an object with the following fields:\nInput Fields:\n\n    City: Latitude and longitude (lat, lng) of the city.\n    Start Date: The user's arrival date.\n    End Date: The user's departure date.\n    Start Hour: The time the user will arrive.\n    End Hour: The time the user will leave.\n    Number of Seniors: Count of travelers aged 65 or above.\n    Number of Adults: Count of travelers aged 24–65.\n    Number of Youth: Count of travelers aged 13–24.\n    Number of Children: Count of travelers younger than 13.\n    Budget: User's preference (Cheap, Balanced, Luxury, or Flexible).\n    Places: A list of all available attractions in the city.\n\nKey Points:\n\n    places_str contains the list of available attractions in the city\n\nTask:\n\nGenerate 3 distinct itineraries, each tailored to the user's preferences and requirements.\nRequirements for Itineraries:\n\n    Each itinerary spans X days and adheres to the user's arrival (Start Hour) and departure (End Hour) times.\n    All itineraries must:\n        Include attractions in required_places.\n        Exclude attractions in removed_places.\n    Select additional attractions based on reviews, ratings, and user preferences to create balanced, high-quality experiences.\n    Ensure each itinerary focuses on different themes or categories of attractions (e.g., cultural, historical, adventure).\n\nItinerary Details:\n\n    Specify the starting and ending times for each attraction visit.\n    Include an estimated average time for each attraction.\n    Schedule at least 1 hour of spare time between consecutive visits for travel and breaks.\n    Optimize the order of attractions to improve time efficiency.",
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

    print(input)

    response = chat_session.send_message(input)

    print(response.text)
    return response.text
