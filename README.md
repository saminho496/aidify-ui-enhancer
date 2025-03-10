
# Aidify Flutter App

A Flutter application that provides accessibility features including speech-to-text, text-to-speech, translation, and object detection.

## Features

- Speech to Text: Convert spoken words to written text
- Text to Speech: Convert written text to spoken words
- Translation: Translate text between multiple languages
- Object Detection: Identify objects using your camera

## Getting Started

### Prerequisites

- Flutter SDK (version 2.17.0 or higher)
- Dart SDK (version 2.17.0 or higher)
- Android Studio / Xcode for mobile development

### Installation

1. Clone this repository
   ```
   git clone https://github.com/yourusername/aidify-flutter.git
   ```

2. Navigate to the project directory
   ```
   cd aidify-flutter
   ```

3. Install dependencies
   ```
   flutter pub get
   ```

4. Run the app
   ```
   flutter run
   ```

## Project Structure

- `lib/` - Contains all the Dart code for the application
  - `main.dart` - Entry point of the application
  - `routes.dart` - App navigation routes
  - `components/` - Reusable UI components
  - `screens/` - App screens
  - `theme/` - App theme configuration

## Dependencies

- google_fonts - For custom fonts
- provider - For state management
- flutter_tts - For text-to-speech functionality
- speech_to_text - For speech recognition
- translator - For language translation
- camera - For object detection
- flutter_sound - For audio recording and playback
- permission_handler - For handling device permissions

## Future Improvements

- Add user authentication and profile management
- Implement cloud storage for saved transcriptions
- Add more languages for translation
- Improve object detection accuracy
- Add offline mode functionality
