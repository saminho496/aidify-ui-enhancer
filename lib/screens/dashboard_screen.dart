
import 'package:flutter/material.dart';
import 'package:aidify/theme/app_theme.dart';
import 'package:aidify/components/feature_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final String _userName = "John";
  
  final List<Map<String, dynamic>> _features = [
    {
      'title': 'Text to Speech',
      'description': 'Convert written text into spoken words with natural-sounding voices in multiple languages.',
      'icon': Icons.message_rounded,
      'color': AppTheme.primaryBlue,
      'route': '/text-to-speech',
    },
    {
      'title': 'Speech to Text',
      'description': 'Accurately transcribe spoken words into written text in real-time with high accuracy.',
      'icon': Icons.mic,
      'color': AppTheme.primaryPurple,
      'route': '/speech-to-text',
    },
    {
      'title': 'Translation',
      'description': 'Translate text between multiple languages instantly with support for over 50 languages.',
      'icon': Icons.translate,
      'color': AppTheme.accentCyan,
      'route': '/translation',
    },
    {
      'title': 'Object Detection',
      'description': 'Identify and describe objects in the real world using your camera with AI-powered recognition.',
      'icon': Icons.visibility,
      'color': AppTheme.accentCoral,
      'route': '/object-detection',
    },
  ];
  
  final List<Map<String, dynamic>> _recentActivity = [
    {
      'title': 'Translated document from English to Spanish',
      'time': 'Today, 2:30 PM',
      'icon': Icons.translate,
      'color': AppTheme.accentCyan,
    },
    {
      'title': 'Converted speech to text (2 minutes)',
      'time': 'Yesterday, 4:15 PM',
      'icon': Icons.mic,
      'color': AppTheme.primaryPurple,
    },
    {
      'title': 'Generated audio from article',
      'time': 'Yesterday, 10:20 AM',
      'icon': Icons.message_rounded,
      'color': AppTheme.primaryBlue,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Container(
              height: 36,
              width: 36,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppTheme.primaryBlue, AppTheme.primaryPurple],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.accessibility_new_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            const Text('Aidify'),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const CircleAvatar(
              radius: 18,
              backgroundColor: AppTheme.primaryPurple,
              child: Text(
                'JD',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            onSelected: (value) {
              if (value == 'logout') {
                Navigator.pushReplacementNamed(context, '/welcome');
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                enabled: false,
                child: Text(
                  'My Account',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'profile',
                child: Row(
                  children: [
                    Icon(Icons.person, size: 18),
                    SizedBox(width: 8),
                    Text('Profile'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings, size: 18),
                    SizedBox(width: 8),
                    Text('Settings'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'help',
                child: Row(
                  children: [
                    Icon(Icons.help_outline, size: 18),
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
                    Icon(Icons.logout, size: 18),
                    SizedBox(width: 8),
                    Text('Log out'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome section
            Text(
              'Welcome back, $_userName',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'What would you like to do today?',
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),
            
            // Features grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              itemCount: _features.length,
              itemBuilder: (context, index) {
                final feature = _features[index];
                return FeatureCard(
                  title: feature['title'],
                  description: feature['description'],
                  icon: feature['icon'],
                  color: feature['color'],
                  onTap: () => Navigator.pushNamed(context, feature['route']),
                );
              },
            ),
            
            // Recent activity
            const SizedBox(height: 32),
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Recent Activity',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _recentActivity.isEmpty
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 24.0),
                            child: Text(
                              'No recent activity yet',
                              style: TextStyle(color: AppTheme.textSecondary),
                            ),
                          ),
                        )
                      : Column(
                          children: _recentActivity.map((activity) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppTheme.border),
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: (activity['color'] as Color).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Icon(
                                      activity['icon'],
                                      color: activity['color'],
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          activity['title'],
                                          style: const TextStyle(fontWeight: FontWeight.w500),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          activity['time'],
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppTheme.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
