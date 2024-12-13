import os
import json
from core.utils import generate_itinerary
from django.conf import settings

def test_generate_itinerary(mocker):
    # Setup Django environment
    os.environ["DJANGO_SETTINGS_MODULE"] = "mysite.settings"
    mocker.patch.object(settings, "GEMINI_API_KEY", "test_gemini_api_key")

    # Mock AI response
    mock_response = {
        "response": {
            "itineraries": [
                {
                    "itineraryName": "Cultural Tour",
                    "attractions": [
                        {
                            "name": "Art Gallery",
                            "startingHour": "10:00",
                            "endingHour": "12:00",
                            "day": "Day 1"
                        }
                    ]
                }
            ]
        }
    }

    # Mock the behavior of the generative AI model
    mock_chat_session = mocker.Mock()
    mock_chat_session.send_message.return_value = mocker.Mock(text=json.dumps(mock_response))

    mock_model = mocker.Mock()
    mock_model.start_chat.return_value = mock_chat_session

    mocker.patch("google.generativeai.GenerativeModel", return_value=mock_model)

    # Call the function
    result = generate_itinerary(
        lat=40.7128, lng=-74.0060,
        start_date="2024-12-01", end_date="2024-12-02",
        start_hour="09:00", end_hour="18:00",
        num_seniors=0, num_adults=2, num_youth=0, num_children=1,
        budget="Balanced", places=[], required_places=[], removed_places=[]
    )

    # Parse the result as JSON
    result = json.loads(result)  # Convert JSON string to dictionary

    # Assertions
    assert isinstance(result, dict)
    assert "response" in result
    assert len(result["response"]["itineraries"]) == 1
    assert result["response"]["itineraries"][0]["itineraryName"] == "Cultural Tour"
    assert result["response"]["itineraries"][0]["attractions"][0]["name"] == "Art Gallery"
