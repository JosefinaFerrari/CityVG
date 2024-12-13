import os
from django.conf import settings
from core.utils import get_places

def test_get_places(mocker):

    os.environ["DJANGO_SETTINGS_MODULE"] = "mysite.settings"

    mocker.patch.object(settings, "GOOGLE_PLACES_API_KEY", "test_api_key")

    mock_response = {
        "places": [
            {
                "displayName": {"text": "Art Gallery"},
                "location": {"latitude": 40.7128, "longitude": -74.0060},
                "types": ["art_gallery"],
                "rating": 4.5
            },
            {
                "displayName": {"text": "Museum"},
                "location": {"latitude": 40.7128, "longitude": -74.0059},
                "types": ["museum"],
                "rating": 4.8
            }
        ]
    }

    mocker.patch("requests.post", return_value=mocker.Mock(status_code=200, json=lambda: mock_response))

    result = get_places(40.7128, -74.0060, 5)


    assert isinstance(result, dict)
    assert "places" in result
    assert len(result["places"]) == 2
    assert result["places"][0]["displayName"]["text"] == "Art Gallery"
