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

   _Note: This step is only required if your project uses a database and there are migrations to apply._

5. **Start the Server**  
   Launch the Django development server:

   ```bash
   python manage.py runserver
   ```

   The server should now be running. Open your browser and visit [http://127.0.0.1:8000](http://127.0.0.1:8000) to access the application.

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

   _Note: This step is only required if your project uses a database and there are migrations to apply._

5. **Start the Server**  
   Launch the Django development server:

   ```bash
   python3 manage.py runserver
   ```

   The server should now be running. Open your browser and visit [http://127.0.0.1:8000](http://127.0.0.1:8000) to access the application.

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
