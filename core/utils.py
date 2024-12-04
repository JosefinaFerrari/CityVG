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
    "temperature": 0.3,
    "top_p": 0.8,
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
        system_instruction=(
            "Consider a scenario where a user wants to visit a city for a specific number of days (X). "
            "You will receive an object with the following fields:\n"
            "- 'City': lat, lng (latitude and longitude of the city).\n"
            "- 'Start Date': The user's arrival date.\n"
            "- 'End Date': The user's departure date.\n"
            "- 'Start Hour': The time the user will arrive.\n"
            "- 'End Hour': The time the user will leave.\n"
            "- 'Number of Seniors': Count of travelers aged 65 or above.\n"
            "- 'Number of Adults': Count of travelers aged 24–65.\n"
            "- 'Number of Youth': Count of travelers aged 13–24.\n"
            "- 'Number of Children': Count of travelers younger than 13.\n"
            "- 'Budget': User's preference (Cheap/Balanced/Luxury/Flexible).\n"
            "- 'Places': A list of all available attractions in the city.\n"
            "- 'Required Places': A list of must-see attractions (optional).\n"
            "- 'Removed Places': A list of attractions to exclude (optional).\n"
            
            "Key Points to Consider:\n"
            "- 'places_str' contains all attractions in the city.\n"
            "- 'required_places' lists attractions that must always be included in the itinerary.\n"
            "- 'removed_places' lists attractions that must never be included.\n"

            "Your task is to generate 3 distinct itineraries:\n"
            "1. Each itinerary spans X days and adheres to the user's arrival ('Start Hour') and departure ('End Hour') times.\n"
            "2. All itineraries must include attractions in 'required_places' and exclude those in 'removed_places'.\n"
            "3. Select additional attractions based on reviews, ratings, and user preferences to create balanced, high-quality experiences.\n"
            "4. Ensure each itinerary focuses on different themes or categories of attractions (e.g., cultural, historical, adventure).\n"
            
            "Itinerary Details:\n"
            "- Include starting and ending times for each visit.\n"
            "- Provide an estimated average time for each attraction.\n"
            "- Schedule at least 1 hour of spare time between consecutive visits to account for travel and breaks.\n"
            "- Optimize the order of attractions for time efficiency.\n"
            
            "Additional Considerations:\n"
            "- Some attractions may offer products (e.g., tours). Select the product that best matches user preferences.\n"
            "- If a product includes multiple attractions, mention the product name only at the first applicable attraction.\n"

            "The output must follow the response schema provided."
        )
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
