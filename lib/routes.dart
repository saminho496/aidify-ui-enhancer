
import 'package:flutter/material.dart';
import 'package:aidify/screens/splash_screen.dart';
import 'package:aidify/screens/welcome_screen.dart';
import 'package:aidify/screens/login_screen.dart';
import 'package:aidify/screens/signup_screen.dart';
import 'package:aidify/screens/dashboard_screen.dart';
import 'package:aidify/screens/text_to_speech_screen.dart';
import 'package:aidify/screens/speech_to_text_screen.dart';
import 'package:aidify/screens/translation_screen.dart';
import 'package:aidify/screens/object_detection_screen.dart';
import 'package:aidify/screens/color_detection_screen.dart';
import 'package:aidify/screens/ocr_screen.dart';
import 'package:aidify/screens/settings_screen.dart';
import 'package:aidify/screens/not_found_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const SplashScreen(),
  '/welcome': (context) => const WelcomeScreen(),
  '/login': (context) => const LoginScreen(),
  '/signup': (context) => const SignUpScreen(),
  '/dashboard': (context) => const DashboardScreen(),
  '/text-to-speech': (context) => const TextToSpeechScreen(),
  '/speech-to-text': (context) => const SpeechToTextScreen(),
  '/translation': (context) => const TranslationScreen(),
  '/object-detection': (context) => const ObjectDetectionScreen(),
  '/color-detection': (context) => const ColorDetectionScreen(),
  '/ocr': (context) => const OcrScreen(),
  '/settings': (context) => const SettingsScreen(),
  '/not-found': (context) => const NotFoundScreen(),
};
