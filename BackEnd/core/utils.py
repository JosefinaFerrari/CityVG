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

    print(f"Fetching places for lat={lat}, lng={lng}, radius={radius}, categories={categories}")
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
        "rankPreference": "POPULARITY" 
    }

    # Apply categories filter if provided
    if categories:
        request_body["includedTypes"] = categories

    # FieldMask to specify the fields to return (displayName is essential)
    field_mask = "places.name,places.displayName,places.shortFormattedAddress,places.location,places.types,places.rating,places.regularOpeningHours,places.userRatingCount,places.formattedAddress,places.photos"

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

def generate_itinerary(lat, lng, start_date, end_date, start_hour, end_hour, num_seniors, num_adults, 
                       num_youth, num_children, budget, places, required_places, removed_places, categories):
    genai.configure(api_key=settings.GEMINI_API_KEY)

    # Create the model
    generation_config = {
    "temperature": 0.6,
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
    system_instruction="Scenario: A user wants to visit a city for a specific number of days. \n\nYour Goal: Generate 3 distinct itineraries, each tailored to the user's preferences and requirements.\n\nYou will receive an object with the following fields:\nInput Fields:\n1. City: Latitude and longitude (lat, lng) of the city.\n2. Arrival Date: Arrival date and hour.\n3. Departure Date: Departure date and hour.\n4. Number of Days: The number of days the trip should last, taking into consideration the given dates.\n5. Number of Travelers: Seniors (65+), Adults (24–65), Youth (13–24), Children (<13).\n6. Budget: User's preference (Cheap, Balanced, Luxury or Flexible).\n7. Places: A JSON of all available attractions in the city , where each place includes:\n\ta. Name: name of the place (you should refer to a place using this field when returning the selected attractions).\n\tb. Associated Product: Details about a purchasable product related to the attraction, such as tours, museum visits, or activities (Not all the attractions will have an associated product).\n\tc. Summary: Information about the product.\n\td. Price of the product.\n7. Required attractions: attractions that must be included.\n8. Removed attractions: attractions that must be excluded.\n9. Categories: the categories the user has selected as preferences\n\nRequirements:\n1. The itineraries must cover all available days from arrival to departure. (example: if a user arrives 2024-10-22 12:00:00 and departures 2024-10-25 18:00:00 the first visit must start at 2024-10-22 12:00:00 and the last visit must end at 2024-10-25 18:00:00. All the other visits must be included between start date and end date).\n2. Ensure to use all the time the user has to visit the city, also the day of the departure if possible.\n3. All itineraries must Include attractions in required_places and exclude attractions in removed_places.\n4. Select additional attractions based on reviews, ratings, and user preferences.\n5. Focus on different themes for each itinerary (e.g., cultural, historical, adventure, entertainment). Select based on the age group of the traveller.\n6. Schedule at least 1 or 2 hour of spare time between consecutive visits, that is time for travel and breaks.\n7. If you select a place, the visit will be based on the product associated, so be aware of what the product includes and take into consideration the product summary and information.\n\nFor each itinerary you must retrieve these informations: \n1. itineraryName: Assign a unique and meaningful name to each itinerary that reflects its theme, focus, or style (e.g., 'Cultural Escapade', 'Adventure Highlights', 'Relaxed Retreat'). Avoid generic names such as 'Itinerary 1' or 'Itinerary 2'.\n2. list of attractions with: \n\ta. Name: the name of the attraction must be equal to Attraction Name, you can’t change it. (Example: If you receive a list with a place: 'Duomo di Milano’ and you want to use it, in the name you must put 'Duomo di Milano', without any changes).\n\tb. Starting Hour and EndingHour: Specify the starting and ending times for each attraction visit in the format HH:MM. Consider an average range of duration for each attractions (example: if it’s a museum minimum 3 hours, if it’s a dinnerShow minimum 3-4 hours). Consider also that some attractions must be done at specific range of time (example: a dinner should start between 19 and 23).\n\tc. Day: the day in which the visit is scheduled ",
    )

    chat_session = model.start_chat(
    history=[
    ]
    )

    num_days = (end_date - start_date).days + 1

    start_date = f"{start_date} at {start_hour}"
    end_date = f"{end_date} at {end_hour}"

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
        f'Categories: {categories}\n'
    )

    response = chat_session.send_message(input)

    return response.text

