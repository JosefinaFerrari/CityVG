# CityVG

This guide provides instructions to set up and run the Django server for the project. Follow the steps carefully depending on your operating system.

---

## Prerequisites

Ensure you have the following installed:

- **Python 3.8+** (verify by running `python --version` or `python3 --version`)
- **pip** (Python package manager)
- **Virtual environment** (`venv` module is included with Python)

---

## Setup and Run Instructions

### For Windows:

1. **Navigate to the Backend Directory**  
   Open a terminal and navigate to the `BackEnd` directory where the project files are located:

   ```bash
   cd path\to\BackEnd
   ```

2. **Activate the Virtual Environment**  
   Run the following command to activate the virtual environment:

   ```bash
   Scripts\activate.bat
   ```

3. **Install Dependencies**  
   Install the required Python packages listed in `requirements.txt`:

   ```bash
   pip install -r requirements.txt
   ```

4. **Run Migrations (Optional)**  
   If there are any database migrations pending, run:

   ```bash
   python manage.py migrate
   ```

5. **Start the Server**  
   Launch the Django development server:

   ```bash
   python manage.py runserver
   ```

   Important: The root URL http://127.0.0.1:8000/ will not serve content. Only the endpoints are functional. Refer to the list of available endpoints below.
   
   The main endpoints are:
   - /generate/, parameters: lat, lng, radius, start_date, end_date, start_time, end_time, categories, budget, required_places, removed_places
   - /get_top10/, parameters: lat, lng, radius, start_date, end_date, start_time, end_time, categories, budget

---

### For macOS/Linux:

1. **Navigate to the Backend Directory**  
   Open a terminal and navigate to the `BackEnd` directory:

   ```bash
   cd pathTo/BackEnd
   ```

2. **Create and Activate the Virtual Environment**  
   Create a virtual environment named `env`:

   ```bash
   python3 -m venv env
   ```

   Activate the virtual environment:

   ```bash
   source env/bin/activate
   ```

3. **Install Dependencies**  
   Install the required Python packages:

   ```bash
   pip install -r requirements.txt
   ```

4. **Run Migrations (Optional)**  
   If there are any database migrations pending, run:

   ```bash
   python3 manage.py migrate
   ```

5. **Start the Server**  
   Launch the Django development server:

   ```bash
   python3 manage.py runserver
   ```

   Important: The root URL http://127.0.0.1:8000/ will not serve content. Only the endpoints are functional. Refer to the list of available endpoints below.
   
   The main endpoints are:
   - /generate/, parameters: lat, lng, radius, start_date, end_date, start_time, end_time, categories, budget, required_places, removed_places
   - /get_top10/, parameters: lat, lng, radius, start_date, end_date, start_time, end_time, categories, budget
---

## Deployment on Heroku

The server is live and hosted on Heroku. It is set up for automatic deployment whenever changes are pushed to the `main` branch on GitHub.

### Live URL
[https://cityvg-5fcc7f07e779.herokuapp.com/](https://cityvg-5fcc7f07e779.herokuapp.com/)

### Automatic Deployment
The project is configured with **Heroku GitHub Integration**, enabling automatic deployment upon every successful push to the `main` branch in your GitHub repository.

**Example Endpoints on Heroku**:
- Generate a trip:  
  [https://cityvg-5fcc7f07e779.herokuapp.com/generate/?lat=48.864716&lng=2.349014&radius=10&start_date=2024-11-23&end_date=2024-11-30&start_time=9&end_time=15&num_seniors=0&num_adults=2&num_youth=0&num_children=1&budget=low](https://cityvg-5fcc7f07e779.herokuapp.com/generate/?lat=48.864716&lng=2.349014&radius=10&start_date=2024-11-23&end_date=2024-11-30&start_time=9&end_time=15&num_seniors=0&num_adults=2&num_youth=0&num_children=1&budget=low)

- Get top 10 recommendations:  
  [https://cityvg-5fcc7f07e779.herokuapp.com/get_top10/?lat=45.4642&lng=9.1900&radius=5&start_date=2024-11-29&end_date=2024-11-30&categories=Museums%20and%20Galleries,Historical%20Sites&budget=Cheap](https://cityvg-5fcc7f07e779.herokuapp.com/get_top10/?lat=45.4642&lng=9.1900&radius=5&start_date=2024-11-29&end_date=2024-11-30&categories=Museums%20and%20Galleries,Historical%20Sites&budget=Cheap)

---
## Credentials

Make sure to have the credentials in the .env file:

1. **TIQETS_API_KEY** 
2. **GOOGLE_PLACES_API_KEY**
3. **GEMINI_API_KEY**
---
## Troubleshooting

- **Virtual Environment Activation Issues:** Ensure you are in the correct directory before activating the environment.
- **Credential File:** Ensure you have the .env file with the API keys
- **Dependency Errors:** If `pip install -r requirements.txt` fails, ensure `pip` is updated using:

   ```bash
   pip install --upgrade pip
   ```

---

## Notes

- The `migrate` command is necessary if your project involves a database, as it applies any changes defined in Django's models.
- Always use the virtual environment to avoid conflicts with global Python packages.
  

---

## Test Trip generation

/generate/?lat=48.864716&lng=2.349014&radius=10&start_date=2024-11-23&end_date=2024-11-30&start_time=9&end_time=15&num_seniors=0&num_adults=2&num_youth=0&num_children=1&budget=low

/get_top10/?lat=45.4642&lng=9.1900&radius=5&start_date=2024-11-29&end_date=2024-11-30&categories=Museums%20and%20Galleries,Historical%20Sites&budget=Cheap
