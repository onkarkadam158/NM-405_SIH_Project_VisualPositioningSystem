nm405_enigmatic_cipherers
Smart India Hackathon 2020 Winner in Software Edition

This project was developed as part of the Smart India Hackathon 2020, where it won the Software Edition for ISRO's problem statement. The goal of this project is to create a Visual Positioning System (VPS) that uses raw GNSS data and Augmented Reality (AR) to provide accurate navigation for visually impaired users.

Overview
Project Context
The increasing availability of GNSS sensors in Android smartphones, which support multiple GNSS constellations such as GPS, Galileo, Beidou, Glonass, QZSS, and NavIC, opens up new possibilities for smartphone-based GNSS applications. These applications offer high accuracy and integrity, which were previously not feasible.

Our project leverages these capabilities to create a navigation system that integrates AR and vibrational feedback to assist visually impaired users. The system includes both indoor and outdoor navigation features, emergency alert mechanisms, and theft detection.

Key Features
Visual Positioning System (VPS Mapping):

Uses ARCore to create routes with Anchor Points for navigation.
Supports mapping of varying altitude points (e.g., stairs) and turns for outdoor navigation.
Indoor Navigation:

Combines Pedestrian Dead Reckoning (PDR) with GNSS data for precise indoor location tracking.
Utilizes Mobile Sensors to calculate intermediate Lat-Long Coordinates.
Outdoor Navigation:

Modifies GNSS data to calculate pseudo ranges and distances accurately.
Provides vibrational feedback for route guidance.
Fall Detection:

Detects falls using the phone's accelerometer.
Sends an emergency signal if a fall is detected, with an option to cancel the alert.
Emergency Alerts:

Includes two distinct gestures (Scale and LongPressUp) for triggering emergency contacts or police SOS.
Theft Detection using Bluetooth:

Detects phone theft based on Bluetooth device disconnection.
Prompts for a password and sends a signal to authorities if the password is incorrect.
Tools and Technologies Used
Android:

Accesses raw GNSS measurements, computes pseudo ranges, and calculates accurate positions and velocities.
Flutter:

Provides cross-platform compatibility with a simple and neat user interface.
Manages GNSS and Sensor data via Event Channels.
ARCore:

Enables AR features for VPS Mapping and navigation.
Maps routes and provides vibrational feedback for guidance.
Firebase:

Stores Lat-Long coordinates for route points and facilitates route sharing.
Future Work
Implement a trifecta of Bluetooth, WiFi, and audio to maintain social distancing in public places.
Enhance step and depth detection for surfaces and improve indoor mapping.
Getting Started
This project is a starting point for a Flutter application.

Prerequisites
Flutter SDK: Ensure Flutter is installed on your machine. Flutter Installation Guide
Android SDK: Required for building the Android version of the app.
Firebase Account: Needed for storing route data and managing the backend.
Installation
Clone the repository:

bash
Copy code
git clone https://github.com/your-repo/nm405_enigmatic_cipherers.git
Navigate to the project directory:

bash
Copy code
cd nm405_enigmatic_cipherers
Install dependencies:

bash
Copy code
flutter pub get
Set up Firebase:

Create a Firebase project and add the Android app.
Download the google-services.json file and place it in the android/app directory.
Run the app:

bash
Copy code
flutter run
Usage
The application is designed to provide a navigation solution for visually impaired users. Key functionalities include:

Mapping routes using VPS Mapping.
Navigating both indoor and outdoor environments.
Utilizing fall detection and emergency alerts for safety.
Contributions
Contributions are welcome! Please open an issue or submit a pull request for any enhancements or bug fixes.

License
This project is licensed under the MIT License. See the LICENSE file for more details.

Acknowledgments
ISRO for providing the problem statement.
AICTE and MHRD, GOI for organizing the Smart India Hackathon 2020.
All team members and contributors who made this project possible.
Feel free to modify this README to fit your specific needs or preferences!