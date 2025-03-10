
import 'package:flutter/material.dart';
import 'package:aidify/theme/app_theme.dart';
import 'package:aidify/components/feature_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            CircleAvatar(
              backgroundColor: AppTheme.primaryPurple,
              child: Icon(Icons.accessibility_new, color: Colors.white),
            ),
            SizedBox(width: 12),
            Text('Aidify'),
          ],
        ),
        actions: [
          PopupMenuButton(
            icon: const CircleAvatar(
              backgroundImage: NetworkImage('https://github.com/shadcn.png'),
            ),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'profile',
                child: Row(
                  children: [
                    Icon(Icons.person),
                    SizedBox(width: 8),
                    Text('Profile'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings),
                    SizedBox(width: 8),
                    Text('Settings'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'help',
                child: Row(
                  children: [
                    Icon(Icons.help),
                    SizedBox(width: 8),
                    Text('Help & Support'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 8),
                    Text('Log out'),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 'logout') {
                Navigator.pushReplacementNamed(context, '/');
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome section
              Text(
                'Welcome back, John',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'What would you like to do today?',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 32),
              
              // Features grid
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  FeatureCard(
                    title: 'Text to Speech',
                    description: 'Convert written text into spoken words with natural-sounding voices.',
                    icon: Icons.record_voice_over,
                    color: AppTheme.primaryBlue,
                    onTap: () {
                      Navigator.pushNamed(context, '/text-to-speech');
                    },
                  ),
                  FeatureCard(
                    title: 'Speech to Text',
                    description: 'Accurately transcribe spoken words into written text in real-time.',
                    icon: Icons.mic,
                    color: AppTheme.primaryPurple,
                    onTap: () {
                      Navigator.pushNamed(context, '/speech-to-text');
                    },
                  ),
                  FeatureCard(
                    title: 'Translation',
                    description: 'Translate text between multiple languages instantly.',
                    icon: Icons.translate,
                    color: AppTheme.accentCyan,
                    onTap: () {
                      Navigator.pushNamed(context, '/translation');
                    },
                  ),
                  FeatureCard(
                    title: 'Object Detection',
                    description: 'Identify and describe objects using your camera.',
                    icon: Icons.visibility,
                    color: AppTheme.accentCoral,
                    onTap: () {
                      Navigator.pushNamed(context, '/object-detection');
                    },
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
              
              // Recent Activity
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recent Activity',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    _buildActivityItem(
                      context,
                      title: 'Translated document from English to Spanish',
                      time: 'Today, 2:30 PM',
                      icon: Icons.translate,
                      color: AppTheme.accentCyan,
                    ),
                    const Divider(),
                    _buildActivityItem(
                      context,
                      title: 'Converted speech to text (2 minutes)',
                      time: 'Yesterday, 4:15 PM',
                      icon: Icons.mic,
                      color: AppTheme.primaryPurple,
                    ),
                    const Divider(),
                    _buildActivityItem(
                      context,
                      title: 'Generated audio from article',
                      time: 'Yesterday, 10:20 AM',
                      icon: Icons.record_voice_over,
                      color: AppTheme.primaryBlue,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityItem(
    BuildContext context, {
    required String title,
    required String time,
    required IconData icon,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  time,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
