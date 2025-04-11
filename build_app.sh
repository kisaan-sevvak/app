#!/bin/bash

# Exit on error
set -e

echo "🚀 Starting Flutter app build process..."

# Clean the project
echo "🧹 Cleaning the project..."
flutter clean

# Get dependencies
echo "📦 Getting dependencies..."
flutter pub get

# Build the APK
echo "🔨 Building the APK..."
flutter build apk --release

echo "✅ Build completed successfully!"
echo "📱 The APK is available at: build/app/outputs/flutter-apk/app-release.apk" 