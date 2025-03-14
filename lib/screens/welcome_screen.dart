
import 'package:flutter/material.dart';
import 'package:aidify/theme/app_theme.dart';
import 'package:aidify/components/feature_card.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // App bar / Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo and name
                  Row(
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [AppTheme.primaryBlue, AppTheme.primaryPurple],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.accessibility_new_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Aidify',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  
                  // Action buttons
                  Row(
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pushNamed(context, '/login'),
                        child: const Text('Login'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () => Navigator.pushNamed(context, '/signup'),
                        child: const Text('Sign Up'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Main content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      // Main headline
                      const SizedBox(height: 48),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryPurple.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Accessibility for Everyone',
                          style: TextStyle(
                            color: AppTheme.primaryPurple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      Text(
                        'Your personal assistant for accessibility',
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Aidify helps specially-abled users with speech-to-text, text-to-speech, translation, and object detection.',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      
                      // Action buttons
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pushNamed(context, '/signup'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryPurple,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('Get Started'),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () => Navigator.pushNamed(context, '/login'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('Sign In'),
                        ),
                      ),
                      
                      // Features section
                      const SizedBox(height: 48),
                      GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          FeatureCard(
                            title: 'Text to Speech',
                            description: 'Convert written text into spoken words',
                            icon: Icons.message_rounded,
                            color: AppTheme.primaryBlue,
                            onTap: () => Navigator.pushNamed(context, '/text-to-speech'),
                          ),
                          FeatureCard(
                            title: 'Speech to Text',
                            description: 'Accurately transcribe spoken words',
                            icon: Icons.mic,
                            color: AppTheme.primaryPurple,
                            onTap: () => Navigator.pushNamed(context, '/speech-to-text'),
                          ),
                          FeatureCard(
                            title: 'Translation',
                            description: 'Translate text between languages',
                            icon: Icons.translate,
                            color: AppTheme.accentCyan,
                            onTap: () => Navigator.pushNamed(context, '/translation'),
                          ),
                          FeatureCard(
                            title: 'Object Detection',
                            description: 'Identify objects using your camera',
                            icon: Icons.visibility,
                            color: AppTheme.accentCoral,
                            onTap: () => Navigator.pushNamed(context, '/object-detection'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Footer
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: AppTheme.border,
                    width: 1,
                  ),
                ),
              ),
              child: Text(
                '© ${DateTime.now().year} Aidify. All rights reserved.',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
