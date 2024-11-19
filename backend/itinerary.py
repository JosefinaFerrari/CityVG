import firebase_admin
from firebase_admin import credentials, firestore

cred = credentials.Certificate("/Users/aleksandranicaj7/Desktop/cityvg-1f3e7-firebase-adminsdk-rnf8s-24ba7fe5a7.json")
firebase_admin.initialize_app(cred)

db = firestore.client()

itinerary_data = {
    "city_name": "Paris",
    "city_picture": "https://example.com/paris_picture.jpg",  
    "trip_dates": {
        "start": "2024-12-01",
        "end": "2024-12-05"
    },
    "activities": [
        {
            "day": "December 1",
            "activities": [
                {
                    "name": "Eiffel Tower",
                    "description": "Visit the iconic Eiffel Tower.",
                    "time": "9:00 AM - 10:00 AM",
                    "price": "€25",
                    "location": "Champ de Mars, 5 Avenue Anatole France, Paris",
                    "ratings": 4.7,
                    "transport": "5-minute walk"
                },
                {
                    "name": "Louvre Museum",
                    "description": "Explore the world-famous Louvre Museum.",
                    "time": "10:30 AM - 1:00 PM",
                    "price": "€17",
                    "location": "Rue de Rivoli, 75001 Paris",
                    "ratings": 4.8,
                    "transport": "10-minute walk"
                }
            ]
        },
        {
            "day": "December 2",
            "activities": [
                {
                    "name": "Montmartre",
                    "description": "Wander around the artistic Montmartre district.",
                    "time": "2:00 PM - 4:00 PM",
                    "price": "Free",
                    "location": "Montmartre, Paris",
                    "ratings": 4.6,
                    "transport": "15-minute metro ride"
                }
            ]
        }
    ]
}

def upload_itinerary_to_firestore():
    itineraries_ref = db.collection('itineraries')

    paris_ref = itineraries_ref.document('paris')

    paris_ref.set({
        "city_name": itinerary_data['city_name'],
        "city_picture": itinerary_data['city_picture'],
        "trip_dates": itinerary_data['trip_dates'],
        "activities": itinerary_data['activities']
    })

    print(f"Data for {itinerary_data['city_name']} uploaded successfully!")

upload_itinerary_to_firestore()
