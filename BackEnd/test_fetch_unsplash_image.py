from core.utils import fetch_unsplash_image
from pytest_mock import MockerFixture
from django.conf import settings
import os

def test_fetch_unsplash_image(mocker: MockerFixture):

    os.environ["DJANGO_SETTINGS_MODULE"] = "mysite.settings"
    mocker.patch.object(settings, "UNSPLASH_API_KEY", "test_api_key")

    mock_response = {
        "results": [{"urls": {"regular": "https://example.com/image.jpg"}}]
    }
    mocker.patch("requests.get", return_value=mocker.Mock(status_code=200, json=lambda: mock_response))


    result = fetch_unsplash_image("Eiffel Tower")
    
    assert result == "https://example.com/image.jpg"
