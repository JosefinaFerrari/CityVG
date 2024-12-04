from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
import json
import google.generativeai as genai
from backend.firebase_config import db

@csrf_exempt
def upload_to_firebase(request):
    if request.method == 'POST':
        try:
            body = json.loads(request.body)
            prompt = body.get('prompt')

            if not prompt:
                return JsonResponse({'error': 'Prompt is required.'}, status=400)

            genai.configure(api_key='AIzaSyAW_PFP93zNzKobgYVEDEhgklZ0MxWYXVk')
            model = genai.GenerativeModel("gemini-1.0-pro")
            response = model.generate_content(prompt)

            db.collection('prompts').add({'prompt': prompt, 'response': response.text})

            return JsonResponse({'message': 'Data uploaded to Firebase successfully.', 'response': response.text}, status=201)

        except Exception as e:
            return JsonResponse({'error': str(e)}, status=500)

    return JsonResponse({'error': 'Invalid request method. Only POST is allowed.'}, status=405)
