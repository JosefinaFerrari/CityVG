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


def fetch_google_place_image(query):
    # Google Places API key
    GOOGLE_API_KEY = settings.GOOGLE_PLACES_API_KEY

    google_api_url = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json"
    google_params = {
        "input": query,
        "inputtype": "textquery",
        "fields": "name,photos",
        "key": GOOGLE_API_KEY
    }

    try:
        google_response = requests.get(google_api_url, params=google_params)
        google_response.raise_for_status()
        google_data = google_response.json()

        if google_data.get("status") == "OK" and google_data.get("candidates"):
            # Extract photo reference from the first candidate
            photos = google_data["candidates"][0].get("photos", [])
            if photos:
                # Build the photo URL using the photo reference
                photo_reference = photos[0]["photo_reference"]
                photo_url = f"https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference={photo_reference}&key={GOOGLE_API_KEY}"
                return photo_url
    except Exception as e:
        print(f"Error fetching place details from Google Places API: {e}")

    return "https://via.placeholder.com/300"


def fetch_google_image(query):
    google_api_url = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json"
    google_params = {
        "input": query,
        "inputtype": "textquery",
        "fields": "name,photos",
        "key": settings.GOOGLE_PLACES_API_KEY
    }

    try:
        # Call the Google Places API
        google_response = requests.get(google_api_url, params=google_params)
        google_response.raise_for_status()
        google_data = google_response.json()

        if google_data.get("status") == "OK" and google_data.get("candidates"):
            # Extract photo reference from the first candidate
            photos = google_data["candidates"][0].get("photos", [])
            if photos:
                # Build the photo URL using the photo reference
                photo_reference = photos[0]["photo_reference"]
                photo_url = f"https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference={photo_reference}&key={GOOGLE_API_KEY}"
                return photo_url
    except Exception as e:
        print(f"Error fetching place details from Google Places API: {e}")

    # Return a placeholder image if no photos are available or errors occur
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
        "rankPreference": "POPULARITY" 
    }

    # Apply categories filter if provided
    if categories:
        request_body["includedTypes"] = categories

    # FieldMask to specify the fields to return (displayName is essential)
    field_mask = "places.name,places.addressComponents,places.displayName,places.shortFormattedAddress,places.location,places.types,places.rating,places.regularOpeningHours,places.userRatingCount,places.formattedAddress,places.photos,places.accessibilityOptions,places.allowsDogs,places.editorialSummary,places.reviews"

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
            places = response.json().get("places", [])

            if(len(places) < 5):
                print("Less than 5 places found, expanding search radius")
                return get_places(lat, lng, radius)
            
            return response.json()
        else:
            return {'error': 'Failed to fetch data from Places API', 'status_code': response.status_code}
    except Exception as e:
        return {'error': str(e)}

def get_tags():
    api_url = "https://api.tiqets.com/v2/tags"

    # Headers for the API request
    headers = {
        "Content-Type": "application/json",
        "Authorization": f"Token {settings.TIQETS_API_KEY}",  # Using the API key from settings
    }

    params = {
        'lang': "en",
        'page_size': 100,
        'page': 1,
        'type_name': 'main_category'
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

'''
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
'''

def get_tiqets_products(lat, lng, radius, num_days, tag_ids=[], page_size=100):
    """
    Fetch all products (attractions, events, etc.) from the Tiqets API based on location and radius.

    Args:
        lat (float): Latitude of the location.
        lng (float): Longitude of the location.
        radius (int): Maximum search radius in meters.
        page_size (int, optional): Number of results per page. Defaults to 100.

    Returns:
        list: List of all product data from Tiqets API.
    """
    api_url = "https://api.tiqets.com/v2/products"
    
    # Headers for the API request
    headers = {
        "Content-Type": "application/json",
        "Authorization": f"Token {settings.TIQETS_API_KEY}",  # Using the API key from settings
    }
    
    # Initialize variables
    all_products = []
    page = 1  # Start with the first page
    
    pages = 1
    if num_days > 5:
        pages = 2
    elif num_days > 14:
        pages = 3
    
    for i in range(pages):
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
                data = response.json()
                
                # Add the products from the current page to the list
                products = data.get("products", [])
                all_products.extend(products)
                
                # Check if we have fetched all pages
                if len(products) < page_size:  # Last page will have fewer items
                    break
                else:
                    page += 1  # Move to the next page
            else:
                print(f"Error: Failed to fetch data (Status Code: {response.status_code})")
                break
        except Exception as e:
            print(f"Exception occurred: {str(e)}")
            break
    # Convert all_products to a dictionary
    products_data = {
        "products": all_products,
        "total": len(all_products),
    }
    
    return products_data

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
    system_instruction="""
        Scenario: A user wants to visit a city for a specific number of days. 

        Your Goal: Generate 3 distinct itineraries, each tailored to the user's preferences and requirements.

        You will receive an object with the following fields:
        Input Fields:
        1. City: Latitude and longitude (lat, lng) of the city.
        2. Start Date: Arrival date and hour.
        3. End Date: Departure date and hour.
        4. Number of Travelers: Seniors (65+), Adults (24-65), Youth (13-24), Children (<13).
        5. Budget: User's preference (Cheap, Balanced, Luxury or Flexible).
        6. Places: A list of all available attractions in the city, where each place includes:
            a. name: name of the place (You must refer to the place using this name).
                Some places will also include:
            b. product_title: the name of a purchasable product related to the attraction, such as tours, museum visits, or activities.
            c. summary: List of items included in the product.
            d. price: Price of the product.
        7. Required attractions: attractions that must be included.
        8. Removed attractions: attractions that must be excluded.
        9. Categories: the categories the user has selected, the chosen attraction must be of those categories

        Requirements:
        1. The itineraries must cover all available days from arrival to departure. (example: if a user arrives 2024-10-22 12:00:00 and departures 2024-10-25 18:00:00 the first visit must start at 2024-10-22 12:00:00 and the last visit must end at 2024-10-25 18:00:00. All the other visits must be included between start date and end date). Do not schedule visits after the departure date and hour.
        2. Ensure to use all the time the user has to visit the city, also the day of the departure if possible.
        3. All itineraries must Include attractions in required_places and exclude attractions in removed_places. The attractions in required_places do do not have to be necessarily at the beginning of the itinerary, but can be also put in the middle or at the end of the itineray.
        4. Select additional attractions based on reviews, ratings, and user preferences.
        5. Focus on different themes for each itinerary (e.g., cultural, historical, adventure, entertainment). Select based on the age group of the traveller. 
        6. Always schedule at least 1 or 2 hour of spare time between consecutive visits, that is time for travel and breaks.
        7. If you select a place, the visit will be based on the product associated, so be aware of what the product includes and take into consideration the product summary and information.
        8. The attractions must be selected based on the categories the user chosen (e.g., if the user has selected the category 'Stadium', each itinerary must contain at least one attraction belonging to the 'Stadium' Category). There must be at least one attraction per category in all itineraries. The categories of the attractions should be inferred from their name and summary.
        9. Itineraries must be different from each other and ensure variability of attractions and themes. Don't include the same attraction in multiple itineraries (except for the required ones which should be in all the itineraries). For example, if one itinerary already includes a visit to the 'Eiffel Tower', the other itineraries must not include a visit to the 'Eiffel Tower'. If an attraction is already present in one itinerary, it should not be included in the other itineraries.

        For each itinerary you must retrieve these informations: 
        1. itineraryName: Assign a unique and meaningful name to each itinerary that reflects its theme, focus, or style (e.g., 'Cultural Escapade', 'Adventure Highlights', 'Relaxed Retreat'). Avoid generic names such as 'Itinerary 1' or 'Itinerary 2'.
        2. list of attractions with: 
            a. Name: the name of the attraction must be equal to the 'name' field of the place, you can’t change it. (Example: If you receive a list with a place: 'Duomo di Milano’ and you want to use it, in the name you must put 'Duomo di Milano', without any changes).
            b. Starting Hour and EndingHour: Specify the starting and ending times for each attraction visit in the format HH:MM. Consider an average range of duration for each attractions (example: if it's a museum minimum 3 hours, if it's a dinnerShow minimum 3-4 hours). Consider also that some attractions must be done at specific range of time (example: a dinner should start between 19 and 23). Remember that at least 1 or 2 hours of spare time should be scheduled between two consecutive visits. Do not schedule visits after the departure hour of the user.
            c. Day: the day in which the visit is scheduled
    """
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


def fetch_opening_hours(place_name):
    """
    Fetch opening hours for a place using Google Places API.

    Args:
        place_name (str): The name of the place to fetch opening hours for.

    Returns:
        dict: A dictionary with the opening hours or an error message if not found.
    """
    # Google Places API key
    GOOGLE_API_KEY = settings.GOOGLE_PLACES_API_KEY

    # Step 1: Use Place Search API to find the place ID
    search_url = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json"
    search_params = {
        "input": place_name,
        "inputtype": "textquery",
        "fields": "place_id",
        "key": GOOGLE_API_KEY
    }

    try:
        search_response = requests.get(search_url, params=search_params)
        search_response.raise_for_status()
        search_data = search_response.json()

        if search_data.get("status") == "OK" and search_data.get("candidates"):
            place_id = search_data["candidates"][0]["place_id"]
        else:
            return {"error": "Place not found"}

    except Exception as e:
        return {"error": f"Error fetching place ID: {e}"}

    # Step 2: Use Place Details API to fetch opening hours
    details_url = "https://maps.googleapis.com/maps/api/place/details/json"
    details_params = {
        "place_id": place_id,
        "fields": "opening_hours",
        "key": GOOGLE_API_KEY
    }

    try:
        details_response = requests.get(details_url, params=details_params)
        details_response.raise_for_status()
        details_data = details_response.json()

        if details_data.get("status") == "OK" and details_data.get("result"):
            opening_hours = details_data["result"].get("opening_hours", {})
            return opening_hours  # Return opening hours directly
        else:
            return {"error": "Opening hours not available"}

    except Exception as e:
        return {"error": f"Error fetching opening hours: {e}"}