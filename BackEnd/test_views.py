import os
import pytest
import json
from unittest.mock import patch, MagicMock
from django.conf import settings
from core.utils import get_places, get_tiqets_products
from core.views import get_itinerary, get_recommendations, get_top10, tags, get_product, merge_gemini_places, group_products_by_venue
from django.http import QueryDict, JsonResponse
from django.urls import reverse
from django.test import RequestFactory
from datetime import datetime

@pytest.mark.django_db
def test_places(mocker):
    os.environ["DJANGO_SETTINGS_MODULE"] = "mysite.settings"
    mocker.patch.object(settings, "GOOGLE_PLACES_API_KEY", "test_api_key")
    mock_response = {
        "places": [
            {"displayName": {"text": "Art Gallery"}, "location": {
                "latitude": 40.7128, "longitude": -74.0060}},
            {"displayName": {"text": "Museum"}, "location": {
                "latitude": 40.7128, "longitude": -74.0059}}
        ]
    }
    mocker.patch("requests.post", return_value=mocker.Mock(
        status_code=200, json=lambda: mock_response))
    lat, lng, radius = 40.7128, -74.0060, 5000
    result = get_places(lat, lng, radius)
    assert isinstance(result, dict)
    assert "places" in result
    assert len(result["places"]) == 2
    assert result["places"][0]["displayName"]["text"] == "Art Gallery"


@pytest.mark.django_db
def test_get_itinerary(mocker):
    os.environ["DJANGO_SETTINGS_MODULE"] = "mysite.settings"
    mocker.patch.object(settings, "GOOGLE_PLACES_API_KEY", "test_api_key")
    mock_response = {
        "itinerary": [
            {"name": "Museum", "location": {
                "latitude": 40.7128, "longitude": -74.0060}},
            {"name": "Art Gallery", "location": {
                "latitude": 40.7128, "longitude": -74.0059}}
        ]
    }
    mocker.patch("requests.get", return_value=mocker.Mock(
        status_code=200, json=lambda: mock_response))
    request = MagicMock()
    request.GET = QueryDict('', mutable=True)
    request.GET['lat'] = '40.7128'
    request.GET['lng'] = '-74.0060'
    request.GET['start_date'] = '2024-12-01'
    request.GET['end_date'] = '2024-12-02'
    request.GET['start_time'] = '09:00'
    request.GET['end_time'] = '18:00'
    request.GET['num_seniors'] = '0'
    request.GET['num_adults'] = '2'
    request.GET['num_youth'] = '0'
    request.GET['num_children'] = '1'
    request.GET['budget'] = 'Balanced'
    request.GET.setlist('categories', ['museum', 'art_gallery'])
    result = get_itinerary(request)
    result_json = json.loads(result.content)
    print(f"Result JSON: {result_json}")
    assert isinstance(
        result_json, dict), f"Expected dict, but got {type(result_json)}"
    assert "itinerary" in result_json, f"Key 'itinerary' not found in result: {result_json}"
    assert len(result_json["itinerary"]
               ) == 2, f"Expected 2 itinerary items, but got {len(result_json['itinerary'])}"
    assert result_json["itinerary"][0][
        "name"] == "Museum", f"Expected 'Museum', but got {result_json['itinerary'][0]['name']}"


@pytest.mark.django_db
def test_get_recommendations(mocker):
    os.environ["DJANGO_SETTINGS_MODULE"] = "mysite.settings"
    mocker.patch.object(settings, "GOOGLE_PLACES_API_KEY", "test_api_key")
    mock_response = {
        "recommendations": [
            {"name": "Museum", "location": {
                "latitude": 40.7128, "longitude": -74.0060}},
            {"name": "Art Gallery", "location": {
                "latitude": 40.7128, "longitude": -74.0059}}
        ]
    }
    mocker.patch("requests.get", return_value=mocker.Mock(
        status_code=200, json=lambda: mock_response))
    request = MagicMock()
    request.GET = QueryDict('', mutable=True)
    request.GET['lat'] = '40.7128'
    request.GET['lng'] = '-74.0060'
    request.GET['radius'] = '5000'
    request.GET['start_date'] = '2024-12-01'
    request.GET['end_date'] = '2024-12-02'
    request.GET.setlist('categories', ['museum', 'art_gallery'])
    request.GET['budget'] = 'Balanced'
    result = get_recommendations(request)
    result_json = json.loads(result.content)
    print(f"Result JSON: {result_json}")
    assert isinstance(
        result_json, list), f"Expected list, but got {type(result_json)}"
    assert len(
        result_json) > 0, f"Expected at least one recommendation, but got {len(result_json)}"
    assert result_json[0][
        "name"] == "Museum", f"Expected 'Museum',  got {result_json[0]['name']}"


@pytest.mark.django_db
def test_get_tiqets_products(mocker):
    mock_response = {
        "products": [
            {"title": "Museum Ticket", "price": "20.00",
                "description": "A great museum tour."}
        ]
    }
    mocker.patch("requests.get", return_value=mocker.Mock(
        status_code=200, json=lambda: mock_response))
    result = get_tiqets_products(40.7128, -74.0060, 5)
    assert 'products' in result
    assert len(result['products']) > 0
    assert result['products'][0]['title'] == "Museum Ticket"


@pytest.mark.django_db
def test_tags(mocker):
    mock_response = {
        "tags": [
            {"id": 1, "name": "Art"},
            {"id": 2, "name": "History"}
        ]
    }

    mocker.patch("requests.get", return_value=MagicMock(
        status_code=200, json=lambda: mock_response))

    request = MagicMock()
    response = tags(request)
    response_data = json.loads(response.content)

    assert isinstance(response, JsonResponse)
    assert "tags" in response_data
    assert len(response_data["tags"]) == 2
    assert response_data["tags"][0]["name"] == "Art"


@pytest.mark.django_db
def test_get_product_with_mocked_data(mocker):
    mock_response = {
        "products": [
            {"title": "Museum Ticket", "price": 10, "rating": 4.5},
            {"title": "Art Gallery Pass", "price": 20, "rating": 4.7},
            {"title": "Historical Tour", "price": 30, "rating": 4.2},
            {"title": "Luxury City Experience", "price": 40, "rating": 4.8},
        ]
    }

    mocker.patch("requests.get", return_value=mocker.Mock(
        status_code=200, json=lambda: mock_response))

    products = mock_response["products"]

    result_cheap = get_product(products, 'cheap')
    assert result_cheap == {
        "title": "Museum Ticket", "price": 10, "rating": 4.5}

    result_balanced = get_product(products, 'balanced')
    assert result_balanced == {
        "title": "Historical Tour", "price": 30, "rating": 4.2}

    result_luxury = get_product(products, 'luxury')
    assert result_luxury == {
        "title": "Luxury City Experience", "price": 40, "rating": 4.8}


@pytest.mark.django_db
def test_group_products_by_venue(mocker):
    mock_tiqets_response = [
        {
            "venue": {"name": "Eiffel Tower", "address": "Champ de Mars"},
            "city_name": "Paris",
            "geolocation": {"lat": 48.8584, "lng": 2.2945},
            "tag_ids": ["442"],
            "title": "Eiffel Tower Tour",
            "price": 20,
            "ratings": {"average": 4.7},
            "tagline": "Discover the Eiffel Tower with this amazing tour",
            "product_checkout_url": "https://example.com/eiffel",
            "wheelchair_access": "Yes"
        },
        {
            "venue": {"name": "Louvre Museum", "address": "Rue de Rivoli"},
            "city_name": "Paris",
            "geolocation": {"lat": 48.8606, "lng": 2.3376},
            "tag_ids": ["442"],
            "title": "Louvre Museum Entry",
            "price": 15,
            "ratings": {"average": 4.8},
            "tagline": "Experience the world's largest art museum",
            "product_checkout_url": "https://example.com/louvre",
            "wheelchair_access": "No"
        },
        {
            "venue": {"name": "Eiffel Tower", "address": "Champ de Mars"},
            "city_name": "Paris",
            "geolocation": {"lat": 48.8584, "lng": 2.2945},
            "tag_ids": ["442"],
            "title": "Eiffel Tower Skip-the-Line",
            "price": 30,
            "ratings": {"average": 4.9},
            "tagline": "Skip the line and save time at the Eiffel Tower",
            "product_checkout_url": "https://example.com/eiffel-skip",
            "wheelchair_access": "Yes"
        }
    ]

    def mock_requests_get(url, params=None, *args, **kwargs):
        return mocker.Mock(status_code=200, json=lambda: mock_tiqets_response)

    mocker.patch("requests.get", side_effect=mock_requests_get)

    result = group_products_by_venue(mock_tiqets_response)

    assert len(result) == 2

    eiffel_tower = result["Eiffel Tower"]
    assert eiffel_tower["name"] == "Eiffel Tower"
    assert eiffel_tower["address"] == "Champ de Mars"
    assert eiffel_tower["city"] == "Paris"
    assert eiffel_tower["lat"] == 48.8584
    assert eiffel_tower["lng"] == 2.2945
    assert len(eiffel_tower["products"]) == 2

    louvre_museum = result["Louvre Museum"]
    assert louvre_museum["name"] == "Louvre Museum"
    assert louvre_museum["address"] == "Rue de Rivoli"
    assert louvre_museum["city"] == "Paris"
    assert louvre_museum["lat"] == 48.8606
    assert louvre_museum["lng"] == 2.3376
    assert len(louvre_museum["products"]) == 1


@pytest.mark.django_db
def test_merge_gemini_places(mocker):
    merged_places_x_tiqets = {
        "Eiffel Tower": {
            "lat": 48.8584,
            "lng": 2.2945,
            "products": {
                "Tour Ticket": {
                    "title": "Eiffel Tower Tour",
                    "price": 20,
                    "city": "Paris",
                    "country": "France",
                    "product_checkout_url": "https://example.com/checkout"
                }
            }
        },
        "Louvre Museum": {
            "lat": 48.8606,
            "lng": 2.3376,
            "products": {}
        }
    }

    gemini_response_str = json.dumps({
        "response": {
            "itineraries": [
                {
                    "attractions": [
                        {"name": "Eiffel Tower", "day": "2024-11-30", "startingHour": "10:00"},
                        {"name": "Louvre Museum", "day": "2024-11-30", "startingHour": "14:00"},
                        {"name": "Unknown Place", "day": "2024-11-30", "startingHour": "18:00"}
                    ]
                }
            ]
        }
    })

    budget = "balanced"
    lat = 48.8566
    lng = 2.3522

    def mock_requests_get(url, *args, **kwargs):
        if "google-place-image" in url:  # Mock fetching Google Place images
            place_name = kwargs.get("params", {}).get("name", "default")
            return mocker.Mock(status_code=200, json=lambda: {"photos": f"Mock image for {place_name}"})
        return mocker.Mock(status_code=404, json=lambda: {"error": "Not Found"})

    mocker.patch("requests.get", side_effect=mock_requests_get)

    result = merge_gemini_places(
        merged_places_x_tiqets, gemini_response_str, budget, lat, lng
    )

    assert len(result["itineraries"][0]["attractions"]) == 3

    eiffel_tower = result["itineraries"][0]["attractions"][0]
    assert eiffel_tower["name"] == "Eiffel Tower"
    assert eiffel_tower["lat"] == 48.8584
    assert eiffel_tower["lng"] == 2.2945
    assert eiffel_tower["product"]["title"] == "Eiffel Tower Tour"
    assert eiffel_tower["product"]["price"] == 20
    assert eiffel_tower["city"] == "Paris"

    louvre = result["itineraries"][0]["attractions"][1]
    assert louvre["name"] == "Louvre Museum"
    assert louvre["lat"] == 48.8606
    assert louvre["lng"] == 2.3376
    assert "product" not in louvre

    unknown = result["itineraries"][0]["attractions"][2]
    assert unknown["name"] == "Unknown Place"
    assert unknown["lat"] == 48.8566
    assert unknown["lng"] == 2.3522
    assert "product" not in unknown



@pytest.mark.django_db
def test_get_top10(mocker):
    # Mock request parameters
    mock_request = MagicMock()
    mock_request.GET = {
        'lat': '45.4642',
        'lng': '9.1900',
        'radius': '5000',
        'categories': 'Museums and Galleries,Historical Sites',
        'start_date': '2024-11-29',
        'end_date': '2024-11-30',
        'budget': 'Cheap'
    }

    # Mock dependencies with the correct module path
    mocker.patch('core.views.get_associated_categories', side_effect=lambda categories, mapping: categories)
    mocker.patch('core.views.get_places', return_value={"places": [
        {"name": "Prado Museum", "rating": 4.7, "num_reviews": 180, "categories": ["Museums"]},
        {"name": "Alhambra", "rating": 4.9, "num_reviews": 250, "categories": ["Historical Sites"]}
    ]})
    mocker.patch('core.views.get_tiqets_products', return_value={"products": [
        {"name": "Sagrada Familia Tickets", "images": ["url_a"]},
        {"name": "Park Güell Entrance", "images": ["url_b"]}
    ]})
    mocker.patch('core.views.filter_tiqets_data', side_effect=lambda data, categories: data)
    mocker.patch('core.views.merge_places_tiqets', side_effect=lambda places, tiqets: {
        "Prado Museum": {"rating": 4.7, "num_reviews": 180, "categories": ["Museums"]},
        "Alhambra": {"rating": 4.9, "num_reviews": 250, "categories": ["Historical Sites"]}
    })
    mocker.patch('core.views.calculate_weighted_rating', side_effect=lambda rating, num_reviews, global_avg: (rating * num_reviews) / (num_reviews + 50))
    mocker.patch('core.views.calculate_place_common_categories', return_value=0.9)
    mocker.patch('core.views.fetch_google_place_image', return_value=['image_url'])
    mocker.patch('core.views.get_product', return_value={"images": ["product_image_url"]})

    # Call the view function
    response = get_top10(mock_request)

    # Verify response
    assert isinstance(response, JsonResponse)
    assert response.status_code == 200

    # Parse the JSON response
    response_data = json.loads(response.content.decode('utf-8'))
    assert len(response_data) <= 10

    for recommendation in response_data:
        assert 'place' in recommendation
        assert 'recommended_score' in recommendation
        assert isinstance(recommendation['recommended_score'], float)

    # Validate `num_days` calculation
    expected_num_days = (datetime.strptime('2024-11-30', "%Y-%m-%d") - datetime.strptime('2024-11-29', "%Y-%m-%d")).days + 1
    assert expected_num_days == 2
