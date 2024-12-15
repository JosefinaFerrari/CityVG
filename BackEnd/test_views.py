import os
import pytest
import json
from unittest.mock import patch, MagicMock
from django.conf import settings
from core.utils import get_places, get_tiqets_products
from core.views import get_itinerary, get_recommendations, get_top10
from django.http import QueryDict


@pytest.mark.django_db
def test_places(mocker):
    os.environ["DJANGO_SETTINGS_MODULE"] = "mysite.settings"
    mocker.patch.object(settings, "GOOGLE_PLACES_API_KEY", "test_api_key")
    mock_response = {
        "places": [
            {"displayName": {"text": "Art Gallery"}, "location": {"latitude": 40.7128, "longitude": -74.0060}},
            {"displayName": {"text": "Museum"}, "location": {"latitude": 40.7128, "longitude": -74.0059}}
        ]
    }
    mocker.patch("requests.post", return_value=mocker.Mock(status_code=200, json=lambda: mock_response))
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
            {"name": "Museum", "location": {"latitude": 40.7128, "longitude": -74.0060}},
            {"name": "Art Gallery", "location": {"latitude": 40.7128, "longitude": -74.0059}}
        ]
    }
    mocker.patch("requests.get", return_value=mocker.Mock(status_code=200, json=lambda: mock_response))
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
    assert isinstance(result_json, dict), f"Expected dict, but got {type(result_json)}"
    assert "itinerary" in result_json, f"Key 'itinerary' not found in result: {result_json}"
    assert len(result_json["itinerary"]) == 2, f"Expected 2 itinerary items, but got {len(result_json['itinerary'])}"
    assert result_json["itinerary"][0]["name"] == "Museum", f"Expected 'Museum', but got {result_json['itinerary'][0]['name']}"


@pytest.mark.django_db
def test_get_recommendations(mocker):
    os.environ["DJANGO_SETTINGS_MODULE"] = "mysite.settings"
    mocker.patch.object(settings, "GOOGLE_PLACES_API_KEY", "test_api_key")
    mock_response = {
        "recommendations": [
            {"name": "Museum", "location": {"latitude": 40.7128, "longitude": -74.0060}},
            {"name": "Art Gallery", "location": {"latitude": 40.7128, "longitude": -74.0059}}
        ]
    }
    mocker.patch("requests.get", return_value=mocker.Mock(status_code=200, json=lambda: mock_response))
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
    assert isinstance(result_json, list), f"Expected list, but got {type(result_json)}"
    assert len(result_json) > 0, f"Expected at least one recommendation, but got {len(result_json)}"
    assert result_json[0]["name"] == "Museum", f"Expected 'Museum',  got {result_json[0]['name']}"


@pytest.mark.django_db
def test_get_tiqets_products(mocker):
    mock_response = {
        "products": [
            {"title": "Museum Ticket", "price": "20.00", "description": "A great museum tour."}
        ]
    }
    mocker.patch("requests.get", return_value=mocker.Mock(status_code=200, json=lambda: mock_response))
    result = get_tiqets_products(40.7128, -74.0060, 5)
    assert 'products' in result
    assert len(result['products']) > 0
    assert result['products'][0]['title'] == "Museum Ticket"
