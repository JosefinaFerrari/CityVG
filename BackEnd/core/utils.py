import requests
from django.conf import settings
import os
import json
from django.conf import settings
from google.ai.generativelanguage_v1beta.types import content
import google.generativeai as genai

# Documentation for google places nearby search https://developers.google.com/maps/documentation/places/web-service/nearby-search?hl=it

from django.conf import settings
import requests
import os

def fetch_unsplash_image(query):
    """
    Fetch the first image URL from Unsplash for a given query.

    Args:
        query (str): Search term for the image (e.g., "Eiffel Tower").
    
    Returns:
        str: URL of the first image or a placeholder URL if no images are found.
    """
    UNSPLASH_API_KEY = settings.UNSPLASH_API_KEY  # Use settings to load the API key

    print(f"Loaded API Key: {UNSPLASH_API_KEY}")  # Debugging: print the loaded API key

    api_url = f"https://api.unsplash.com/search/photos?query={query}"

    headers = {
        'Authorization': f'Client-ID {UNSPLASH_API_KEY}',
    }

    try:
        response = requests.get(api_url, headers=headers)
        response.raise_for_status()  
        data = response.json()

        if data['results']:
            return data['results'][0]['urls']['regular']
    except Exception as e:
        print(f"Error fetching image from Unsplash: {e}")

    return "https://via.placeholder.com/300"


 
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
    field_mask = "places.name,places.displayName,places.shortFormattedAddress,places.location,places.types,places.rating,places.regularOpeningHours,places.userRatingCount"

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
    "temperature": 0.3,
    "top_p": 0.8,
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
    system_instruction="A user wants to visit a city for a specific number of days. You will receive an object with the following fields:\nInput Fields:\n\n    City: Latitude and longitude (lat, lng) of the city.\n    Start Date: The user's arrival date and hour.\n    End Date: The user's departure date and hour (this day is part of the trip; any available time before departure should be used, such as the morning in case of an afternoon departure), the user will depart on the day and hour showw in this field.\n  Number of Seniors: Count of travelers aged 65 or above.\n    Number of Adults: Count of travelers aged 24–65.\n    Number of Youth: Count of travelers aged 13–24.\n    Number of Children: Count of travelers younger than 13.\n    Budget: User's preference (Cheap, Balanced, Luxury, or Flexible). \n    Places: A list of all available attractions in the city.\n\nKey Points:\n\n    Placs is an object that contains: \n - Attraction Name \n - Associated Product: Details about a purchasable product related to the attraction, such as tours, museum visits, or activities - Summary: Information about the product. - What's included: What the product includes\n - Price of the product\n\nTask:\n\nGenerate 3 distinct itineraries, each tailored to the user's preferences and requirements.\nRequirements for Itineraries:\n\n    Each itinerary spans X days and adheres to the user's arrival (Start Hour) and departure (End Hour) times.\n    All itineraries must:\n        Include attractions in required_places.\n        Exclude attractions in removed_places.\n    Select additional attractions based on reviews, ratings, and user preferences to create balanced, high-quality experiences.\n    Ensure each itinerary focuses on different themes or categories of attractions (e.g., cultural, historical, adventure).\n\nItinerary Details:\n\n    Specify the starting and ending times for each attraction visit in the format HH:MM.\n    Include an estimated average time for each attraction.\n    Schedule at least 1 hour of spare time between consecutive visits for travel and breaks.\n    Optimize the order of attractions to improve time efficiency. \n Ensure to use all the time the user has to visit the city, also the day of the departure if possible \n Itinerary Naming:\n - Assign a unique and meaningful name to each itinerary that reflects its theme, focus, or style (e.g., 'Cultural Escapade', 'Adventure Highlights', 'Relaxed Retreat').\n Avoid generic names such as 'Itinerary 1' or 'Itinerary 2'.\n The name of the attractions must be in the list of received places\n If you select a place, the visit will be based on the product associated, so be aware of what the product includes and take into consideration the product summary and informations",
    )

    chat_session = model.start_chat(
    history=[
    ]
    )

    num_days = (end_date - start_date).days + 1

    start_date = f"{start_date} {start_hour}"
    end_date = f"{end_date} {end_hour}"


    input = (
        f'City: lat={lat} lng={lng}\n'
        f'Arrival Date and Hour: {start_date}\n'
        f'Departure Date and Hour: {end_date}\n'
        f'Number of days: {num_days}'
        f'Number of Seniors: {num_seniors}\n'
        f'Number of Adults: {num_adults}\n'
        f'Number of Youth: {num_youth}\n'
        f'Number of Children: {num_children}\n'
        f'Budget: {budget}\n'
        f'Places: {places}\n'
        f'Required places: {required_places}\n'
        f'Removed places: {removed_places}\n'
    )


    print(json.dumps(input, indent=4))

    response = chat_session.send_message(input)

    return response.text

