# CityVG Flutter APP

## Setup and Run Instructions

### General Setup:

1. **Clone the Repository**  
   Ensure you have cloned the repository containing both the backend and frontend. The frontend files are located in the `FrontEnd` directory.

2. **Navigate to the Frontend Directory**  
   Open a terminal and navigate to the `FrontEnd` directory:

   ```bash
   cd path/to/FrontEnd
   ```

3. **Install Flutter Dependencies**  
   Use the following command to install all required dependencies for the Flutter application:

   ```bash
   flutter pub get
   ```

4. **Check for Issues**  
   Ensure your environment is properly set up and resolve any issues with the Flutter doctor command:

   ```bash
   flutter doctor
   ```

---

### For Android:

1. **Connect a Device or Launch an Emulator**  
   - **To use a physical device:** Connect an Android device via USB and enable USB debugging.  
   - **To use an emulator:** Open Android Studio and start an emulator.

2. **Run the Application**  
   Start the application on your device or emulator:

   ```bash
   flutter run
   ```

---

### For iOS (macOS only):

1. **Connect a Device or Launch a Simulator**  
   - **To use a physical device:** Connect an iPhone via USB. Ensure the device is trusted.  
   - **To use a simulator:** Open Xcode, navigate to `Xcode > Open Developer Tool > Simulator`, and launch an iOS simulator.

2. **Run the Application**  
   Run the application on your device or simulator:

   ```bash
   flutter run
   ```

   _Note: Ensure you have Xcode configured properly for Flutter development._

---

### For Web:

1. **Ensure Web Support is Enabled**  
   Verify that Flutter's web support is enabled by running:

   ```bash
   flutter devices
   ```

   If the web device is not listed, enable web support with:

   ```bash
   flutter config --enable-web
   ```

2. **Run the Application**  
   Launch the application in a browser:

   ```bash
   flutter run -d chrome
   ```

   _Note: Replace `chrome` with the browser of your choice if multiple are available._

---

## Troubleshooting

- **Emulator or Device Issues:** Ensure your device or emulator is connected and recognized by running `flutter devices`.
- **Dependency Errors:** If `flutter pub get` fails, ensure the Flutter SDK is updated by running:

   ```bash
   flutter upgrade
   ```

- **Web Issues:** Ensure you have a supported browser and web support is enabled.

---

## Notes

- Use the `flutter clean` command if you encounter issues with cached builds or dependencies.
