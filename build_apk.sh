#!/bin/bash

# Exit on error
set -e

echo "🚀 Building Kisan Saathi APK..."

# Clean the project
echo "🧹 Cleaning project..."
flutter clean

# Get dependencies
echo "📦 Getting dependencies..."
flutter pub get

# Build APK
echo "🔨 Building APK..."
flutter build apk --release

# Move APK to a more accessible location
echo "📦 Moving APK to build directory..."
mkdir -p build
mv build/app/outputs/flutter-apk/app-release.apk build/kisan_saathi.apk

echo "✅ Build complete! APK is available at build/kisan_saathi.apk" 