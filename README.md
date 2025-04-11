# Kisan Saathi - AI-Powered Farming Assistant

Kisan Saathi is a multilingual farming assistant app designed specifically for Indian farmers. It provides real-time weather updates, crop recommendations, disease detection, market prices, and soil analysis.

## Features

- **Weather Updates**: Real-time weather forecasts and alerts
- **Crop Management**: Recommendations for crop selection and management
- **Disease Detection**: AI-powered plant disease detection from images
- **Market Prices**: Real-time market prices from Agmarknet
- **Soil Analysis**: Soil type detection and recommendations
- **Multilingual Support**: Available in multiple Indian languages

## Tech Stack

- **Frontend**: Flutter
- **Backend**: FastAPI (Python)
- **Database**: SQLite (development), PostgreSQL (production)
- **Authentication**: Google OAuth
- **APIs**: OpenWeather, Agmarknet

## Setup Instructions

### Prerequisites

- Python 3.10+
- Flutter SDK
- Android Studio / Xcode
- Git

### Backend Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/kisan-saathi.git
   cd kisan-saathi
   ```

2. Set up the Agmarknet API:
   ```bash
   cd backend
   ./setup_agmarknet_api.sh
   ```

3. Create and activate a virtual environment:
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

4. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

5. Set up environment variables:
   ```bash
   cp .env.example .env
   # Edit .env with your API keys and configuration
   ```

6. Run the backend server:
   ```bash
   python run.py
   ```

### Flutter App Setup

1. Install Flutter dependencies:
   ```bash
   cd ..
   flutter pub get
   ```

2. Run the app:
   ```bash
   flutter run
   ```

## API Endpoints

### Authentication
- `POST /api/auth/google`: Google OAuth authentication

### Weather
- `GET /api/weather/forecast`: Get weather forecast
- `GET /api/weather/alerts`: Get weather alerts

### Crops
- `GET /api/crops/recommendations`: Get crop recommendations
- `POST /api/crops`: Add a new crop

### Diseases
- `POST /api/diseases/detect`: Detect plant diseases from image
- `GET /api/diseases/common`: Get common diseases for a crop

### Market
- `GET /api/market/prices`: Get market prices
- `GET /api/market/trends`: Get market trends

### Soil
- `POST /api/soil/analyze`: Analyze soil from image
- `GET /api/soil/recommendations`: Get soil recommendations

## Deployment

### Backend Deployment

1. Build the Docker image:
   ```bash
   cd backend
   docker build -t kisan-saathi-api .
   ```

2. Run the container:
   ```bash
   docker run -d -p 8000:8000 --name kisan-saathi-api kisan-saathi-api
   ```

### Flutter App Deployment

1. Build the APK:
   ```bash
   flutter build apk --release
   ```

2. The APK will be available at `build/app/outputs/flutter-apk/app-release.apk`

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Flutter team for the amazing framework
- Firebase for backend services
- Google Cloud for AI/ML capabilities
- All contributors and supporters of the project
