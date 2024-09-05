# Speed Detection Video Processing App

This project consists of two parts: a Flask-based backend that processes videos and a Flutter frontend that allows users to upload videos, which are then processed by the backend and returned with object detection and speed estimation.

## Part 1: Flask Backend Setup

### Prerequisites
- Python 3.7 or above
- pip (Python package manager)
- `virtualenv` (optional but recommended for managing dependencies)

### Installation

1. **Clone the repository:**

   ```bash
   git clone https://github.com/TayyubKhan/speedDetectionapp.git
   cd speeddetectionFlask

    Set up a virtual environment (optional but recommended):

    bash

python3 -m venv venv
source venv/bin/activate  # On Windows, use `venv\Scripts\activate`

Install the required dependencies:

bash

pip install -r requirements.txt

If you don't have a requirements.txt file, generate it after installing the packages below.

Install the required packages manually if not listed in requirements.txt:

bash

    pip install Flask opencv-python-headless ultralytics scipy

    Download the YOLOv8 model:

    This code uses the YOLOv8n model, which is automatically downloaded by the ultralytics package when first run. No additional setup is needed.

Running the Application

    Start the Flask server:

    bash

    python app.py

    Access the API:

    The API will be running locally at http://localhost:5000. If you're hosting on a remote server, replace localhost with your server's IP address.

Part 2: Flutter Frontend Setup
Prerequisites

    Flutter SDK installed (Installation guide)
    A device or emulator to run the app

Installation

    Clone the Flutter frontend repository:

    bash

git clone [https://github.com/yourusername/speeddetectionFlutter.git](https://github.com/TayyubKhan/speedDetectionapp.git)
cd speeddetectionFlutter

Install dependencies:

Inside the project directory, run:

bash

    flutter pub get

    Connect a device or start an emulator:
        For Android: Ensure that your device is connected via USB and USB debugging is enabled, or start an Android emulator.
        For iOS: Use an iPhone simulator or connect an iOS device.

Modifying the API URL

In the HomeScreen widget, replace the IP address in the _uploadVideo function with your server's IP address:

dart

var request = http.MultipartRequest(
  'POST',
  Uri.parse('http://<your-server-ip>:5000/process_video'),  // Update the URL here
);

Replace <your-server-ip> with the IP address of the server running the Flask backend.
Running the App

    Run the Flutter app:

    bash

    flutter run

    This will launch the app on the connected device or emulator.

    Pick and upload a video:
        Press the "Pick Video" button to select a video from your gallery.
        The app will upload the video to the Flask backend, process it, and return the processed video, which will be displayed in the app.

Dependencies

This Flutter app uses the following packages:

    image_picker for selecting videos from the gallery.
    video_player for playing both the original and processed videos.
    http for making HTTP requests to the Flask API.
    path_provider for accessing the device's file system.
    flutter_spinkit for showing a loading indicator during video processing.

License

This project is licensed under the MIT License - see the LICENSE file for details.

rust


This `README.md` file provides instructions for setting up both the Flask backend and the Flutter frontend, including changing the API URL to match your server's IP address.
