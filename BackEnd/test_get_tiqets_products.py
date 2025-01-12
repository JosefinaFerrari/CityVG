import pytest
import os
from unittest.mock import patch
from core.utils import get_tiqets_products


def test_get_tiqets_products(mocker):
    os.environ["DJANGO_SETTINGS_MODULE"] = "mysite.settings"
    mock_response = {
        "products": [
            {"title": "Museum Ticket", "price": "20.00", "description": "A great museum tour."}
        ]
    }

    mocker.patch("requests.get", return_value=mocker.Mock(status_code=200, json=lambda: mock_response))

    with patch("django.conf.settings.TIQETS_API_KEY", "mock_api_key"):
        result = get_tiqets_products(40.7128, -74.0060, 5, 3)

    assert 'products' in result  
    assert len(result['products']) > 0 
    assert result['products'][0]['title'] == "Museum Ticket"
