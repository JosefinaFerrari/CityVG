"""
URL configuration for mysite project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/5.1/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path
from core.views import tiqets
from core.views import places
#from core.views import merge_tiqets_and_places
from core.views import gemini
from core.views import get_itinerary

urlpatterns = [
    path('admin/', admin.site.urls),
    path('tiqets/', tiqets, name='tiqets_products'),
    path('places/', places, name='places'),
    #path('merge/', merge_tiqets_and_places, name='merge_tiqets_places'),
    path('gemini/', gemini, name='gemini'),
    path('generate/', get_itinerary, name='get_itinerary'),
]
