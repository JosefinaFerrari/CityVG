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
    system_instruction="Scenario: A user wants to visit a city for a specific number of days.\n\nGoal: Generate 3 unique itineraries, each with a distinct focus and tailored to the user's preferences and requirements.\n\nInput Fields:\n\n    City: Latitude and longitude (lat, lng) of the city.\n    Arrival Date & Time: The arrival timestamp (e.g., YYYY-MM-DD HH:MM).\n    Departure Date & Time: The departure timestamp (e.g., YYYY-MM-DD HH:MM).\n    Duration: Number of days the trip should span, aligning with the arrival and departure times.\n    Travelers: Breakdown by age groups:\n        Seniors (65+)\n        Adults (24–65)\n        Youth (13–24)\n        Children (<13)\n    Budget Preference: Budget type—Cheap, Balanced, Luxury, or Flexible.\n    Available Attractions: JSON object with details for each attraction:\n        Name (must be referred to exactly as provided).\n        Associated Product: Details of purchasable experiences (e.g., tours, museum entries). If no product exists, treat it as a free or self-guided attraction.\n        Product Summary (if applicable).\n        Price (if applicable).\n    Required Attractions: List of must-visit attractions.\n    Excluded Attractions: List of attractions to exclude.\n    Categories: User-preferred attraction categories (e.g., cultural, adventure, historical).\n\nRequirements for Itineraries:\n\n    Coverage: Use the entire available time (including arrival/departure days). Optimize schedules to make the most of the user’s visit while considering breaks and travel time.\n    Unique Themes:\n        Each itinerary must have a distinct focus (e.g., cultural, adventure, family-friendly) catering to different traveler interests and demographics.\n        Prioritize attractions relevant to the theme and age groups (e.g., adventure parks for youth, cultural sites for seniors).\n    Attraction Selection:\n        Required attractions must be included.\n        Excluded attractions must not appear.\n        Choose additional attractions based on user-selected categories, ratings, reviews, and availability of products (if any).\n        If an attraction lacks an associated product, include it as a free/self-guided activity where appropriate.\n    Scheduling:\n        Allow 1–2 hours of buffer time between visits for travel and breaks.\n        Account for time-specific attractions (e.g., dinner shows between 19:00–23:00).\n    Diversity: Ensure meaningful differences between itineraries, such as:\n        Visiting different attractions (or different combinations).\n        Different themes or focal points (e.g., history vs. entertainment).\n        Variations in intensity or pacing (e.g., relaxed vs. adventurous).\n\nOutput Format:\n\n    Itinerary Name: A unique, descriptive title reflecting the theme (e.g., Urban Explorer Adventure, Cultural Retreat).\n    Daily Schedule:\n        Day-by-day breakdown:\n            Attraction Name: Exact match to the provided data.\n            Start Time: HH:MM (aligned with attraction availability).\n            End Time: HH:MM.\n        Include travel and break times.\n",
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

