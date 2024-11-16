# Mood Tracker App

A Flutter-based application for tracking moods. Before starting, ensure the backend programs and database are set up from the [backend_mood_tracker_app](https://github.com/nokyalr/backend_mood_tracker_app).

## Setup Instructions

1. **Backend Setup**  
   Make sure you have set up the backend from the repository [backend_mood_tracker_app](https://github.com/nokyalr/backend_mood_tracker_app) before proceeding.

2. **Clone or Download the Repository**  
   - Click the green **Code** button above and select **Download ZIP**.
   - Extract the downloaded ZIP file.
   - Rename the extracted folder from `mood_tracker_app-main` to `mood_tracker_app`.
   - Move the folder into your Flutter project directory.

3. **Open the Project in Visual Studio Code**  
   - Open **Visual Studio Code (VSCode)**.
   - Choose **Open Folder** and navigate to the `mood_tracker_app` folder you just moved.

4. **Install Dependencies**  
   - Open the terminal in VSCode.
   - Run the following command to download the required dependencies:  
     ```bash
     flutter pub get
     ```

5. **Configure the Backend API URL**  
   - Open the file: `mood_tracker_app\lib\config\constants.dart`.
   - Update the `baseUrl` depending on your setup:
     - For physical devices (phone). Run `ipconfig` from terminal to know your ip adress:  
       ```dart
       static const String baseUrl = 'http://192.168.1.10/mood_tracker_backend/api';
       ```
     - For **Windows** or **Chrome** builds:  
       ```dart
       static const String baseUrl = 'http://localhost/mood_tracker_backend/api';
       ```
     - For **Android Emulators**:  
       ```dart
       static const String baseUrl = 'http://10.0.2.2/mood_tracker_backend/api';
       ```

6. **Run or Build the Project**  
   - Run the project via button or terminal
