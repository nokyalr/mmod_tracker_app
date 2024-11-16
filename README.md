# Mood Tracker App

A Flutter-based application for tracking moods. Before starting, ensure the backend programs and database are set up from the [backend_mood_tracker_app](https://github.com/nokyalr/backend_mood_tracker_app).

## Setup Instructions

1. **Backend Setup**  
   Set up the backend by following the instructions in the [backend_mood_tracker_app](https://github.com/nokyalr/backend_mood_tracker_app) repository.

2. **Clone or Download the Repository**  
   - Click the green **Code** button above and select **Download ZIP**.
   - Extract the ZIP file and rename the folder from `mood_tracker_app-main` to `mood_tracker_app`.
   - Move the folder into your Flutter project directory.

3. **Open the Project in Visual Studio Code**  
   - Open **Visual Studio Code (VSCode)**.
   - Use the **Open Folder** option to navigate to the `mood_tracker_app` folder.

4. **Install Dependencies**  
   - Open the terminal in VSCode.
   - Run the following command to download all required dependencies:  
     ```bash
     flutter pub get
     ```

5. **Configure the Backend API URL**  
   - Open the file: `mood_tracker_app\lib\config\constants.dart`.
   - Update the `baseUrl` based on your setup:
     - **Physical Device**: Run `ipconfig` (Windows) or `ifconfig` (Linux/Mac) to find your local IP address, then use:
       ```dart
       static const String baseUrl = 'http://<YOUR_IP_ADDRESS>/mood_tracker_backend/api';
       ```
     - **Windows or Chrome Builds**:
       ```dart
       static const String baseUrl = 'http://localhost/mood_tracker_backend/api';
       ```
     - **Android Emulators**:
       ```dart
       static const String baseUrl = 'http://10.0.2.2/mood_tracker_backend/api';
       ```

6. **Run or Build the Project**  
   - Run the project using the **Run** button in VSCode or the following terminal command:
     ```bash
     flutter run
     ```
