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

1. **Clone the Repository**  
   Open a terminal and clone the repository to your local machine:

   ```bash
   git clone https://github.com/JosefinaFerrari/CityVG.git
   ```

2. **Navigate to the Backend Directory**  
   Navigate to the `BackEnd` directory where the project files are located:

   ```bash
   cd CityVG/BackEnd
   ```

3. **Activate the Virtual Environment**  
   Run the following command to activate the virtual environment:

   ```bash
   Scripts\activate.bat
   ```

4. **Install Dependencies**  
   Install the required Python packages listed in `requirements.txt`:

   ```bash
   pip install -r requirements.txt
   ```

5. **Run Migrations (Optional)**  
   If there are any database migrations pending, run:

   ```bash
   python manage.py migrate
   ```

6. **Start the Server**  
   Launch the Django development server:

   ```bash
   python manage.py runserver
   ```
   
   **Important:** The root URL [http://127.0.0.1:8000/](http://127.0.0.1:8000/) will not serve content. Only the endpoints are functional. Refer to the list of available endpoints below.

   The main endpoints are:
   - `/generate/`, parameters: `lat`, `lng`, `radius`, `start_date`, `end_date`, `start_time`, `end_time`, `categories`, `budget`, `required_places`, `removed_places`
   - `/get_top10/`, parameters: `lat`, `lng`, `radius`, `start_date`, `end_date`, `start_time`, `end_time`, `categories`, `budget`

---

### For macOS/Linux:

1. **Clone the Repository**  
   Open a terminal and clone the repository to your local machine:

   ```bash
   git clone https://github.com/JosefinaFerrari/CityVG.git
   ```

2. **Navigate to the Backend Directory**  
   Navigate to the `BackEnd` directory:

   ```bash
   cd CityVG/BackEnd
   ```

3. **Create and Activate the Virtual Environment**  
   Create a virtual environment named `env`:

   ```bash
   python3 -m venv env
   ```

   Activate the virtual environment:

   ```bash
   source env/bin/activate
   ```

4. **Install Dependencies**  
   Install the required Python packages:

   ```bash
   pip install -r requirements.txt
   ```

5. **Run Migrations (Optional)**  
   If there are any database migrations pending, run:

   ```bash
   python3 manage.py migrate
   ```

6. **Start the Server**  
   Launch the Django development server:

   ```bash
   python3 manage.py runserver
   ```

   **Important:** The root URL [http://127.0.0.1:8000/](http://127.0.0.1:8000/) will not serve content. Only the endpoints are functional. Refer to the list of available endpoints below.

   The main endpoints are:
   - `/generate/`, parameters: `lat`, `lng`, `radius`, `start_date`, `end_date`, `start_time`, `end_time`, `categories`, `budget`, `required_places`, `removed_places`
   - `/get_top10/`, parameters: `lat`, `lng`, `radius`, `start_date`, `end_date`, `start_time`, `end_time`, `categories`, `budget`
     
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

- **Virtual Environment Activation Issues:**  
  Ensure you are in the correct directory before activating the environment. Check that you have run the command to activate the virtual environment (`Scripts\activate.bat` for Windows, or `source env/bin/activate` for macOS/Linux).
- **Credential File:**  
  Ensure you have the `.env` file with the required API keys (e.g., `TIQETS_API_KEY`, `GOOGLE_PLACES_API_KEY`, and `GEMINI_API_KEY`). If the file is missing or the keys are incorrect, API calls will fail.
- **Dependency Errors:** If `pip install -r requirements.txt` fails, ensure `pip` is updated using:

   ```bash
   pip install --upgrade pip
   ```
- **API Call Errors (e.g., 400 or 500 HTTP Status Codes):**  
  - Double-check that all required parameters are included in your API requests. Missing or invalid parameters will result in errors.
  - If you encounter a **401 Unauthorized** error, verify that your API keys are correct and have the necessary permissions.
  - For **timeout errors**, ensure your internet connection is stable or check if the external APIs are experiencing downtime.

- **Testing API Calls Directly:**  
  You can test the APIs alone without running the entire application by using the following example endpoints:
  - [Get Places](https://cityvg-5fcc7f07e779.herokuapp.com/places/?lat=45.4642&lng=9.1900&radius=5):  
    `https://cityvg-5fcc7f07e779.herokuapp.com/places/?lat=45.4642&lng=9.1900&radius=5`
  - [Get Tiqets](https://cityvg-5fcc7f07e779.herokuapp.com/tiqets/?lat=45.4642&lng=9.1900&radius=5):  
    `https://cityvg-5fcc7f07e779.herokuapp.com/tiqets/?lat=45.4642&lng=9.1900&radius=5`

    Use tools like **Postman**, **cURL**, or a browser to make requests to these URLs. These will help you verify if the backend APIs are functioning correctly.

---

## Notes

- The `migrate` command is necessary if your project involves a database, as it applies any changes defined in Django's models.
- Always use the virtual environment to avoid conflicts with global Python packages.
- Running the server allows you to test the API endpoints. You can make API calls to the endpoints listed below and view their responses in your browser or using tools like Postman or cURL
  
---

## Test Trip generation

/generate/?lat=48.864716&lng=2.349014&radius=10&start_date=2024-11-23&end_date=2024-11-30&start_time=9&end_time=15&num_seniors=0&num_adults=2&num_youth=0&num_children=1&budget=low

/get_top10/?lat=45.4642&lng=9.1900&radius=5&start_date=2024-11-29&end_date=2024-11-30&categories=Museums%20and%20Galleries,Historical%20Sites&budget=Cheap
