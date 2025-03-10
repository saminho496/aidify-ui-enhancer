
import 'package:flutter/material.dart';
import 'package:aidify/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;
  bool _notificationsEnabled = true;
  bool _textToSpeechEnabled = true;
  String _defaultLanguage = 'en-US';
  double _textSize = 1.0; // 1.0 is normal
  
  @override
  void initState() {
    super.initState();
    _loadSettings();
  }
  
  Future<void> _loadSettings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _darkMode = prefs.getBool('darkMode') ?? false;
      _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
      _textToSpeechEnabled = prefs.getBool('textToSpeechEnabled') ?? true;
      _defaultLanguage = prefs.getString('defaultLanguage') ?? 'en-US';
      _textSize = prefs.getDouble('textSize') ?? 1.0;
    });
  }
  
  Future<void> _saveSettings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', _darkMode);
    await prefs.setBool('notificationsEnabled', _notificationsEnabled);
    await prefs.setBool('textToSpeechEnabled', _textToSpeechEnabled);
    await prefs.setString('defaultLanguage', _defaultLanguage);
    await prefs.setDouble('textSize', _textSize);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings saved')),
    );
  }
  
  void _resetSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Settings'),
        content: const Text('Are you sure you want to reset all settings to default?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              setState(() {
                _darkMode = false;
                _notificationsEnabled = true;
                _textToSpeechEnabled = true;
                _defaultLanguage = 'en-US';
                _textSize = 1.0;
              });
              await _saveSettings();
              Navigator.pop(context);
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Settings'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              
              // App settings
              _buildSectionHeader(context, 'App Settings'),
              const SizedBox(height: 8),
              _buildSettingCard(
                context,
                children: [
                  _buildSwitchTile(
                    title: 'Dark Mode',
                    subtitle: 'Enable dark theme for the app',
                    value: _darkMode,
                    onChanged: (value) {
                      setState(() {
                        _darkMode = value;
                      });
                    },
                    leadingIcon: Icons.dark_mode,
                  ),
                  const Divider(),
                  _buildSwitchTile(
                    title: 'Notifications',
                    subtitle: 'Enable notifications from the app',
                    value: _notificationsEnabled,
                    onChanged: (value) {
                      setState(() {
                        _notificationsEnabled = value;
                      });
                    },
                    leadingIcon: Icons.notifications,
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Accessibility settings
              _buildSectionHeader(context, 'Accessibility'),
              const SizedBox(height: 8),
              _buildSettingCard(
                context,
                children: [
                  _buildSwitchTile(
                    title: 'Text-to-Speech',
                    subtitle: 'Enable text-to-speech functionality',
                    value: _textToSpeechEnabled,
                    onChanged: (value) {
                      setState(() {
                        _textToSpeechEnabled = value;
                      });
                    },
                    leadingIcon: Icons.record_voice_over,
                  ),
                  const Divider(),
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryPurple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.text_fields,
                        color: AppTheme.primaryPurple,
                      ),
                    ),
                    title: const Text('Text Size'),
                    subtitle: Text(_getTextSizeLabel(_textSize)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: _showTextSizeDialog,
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Language settings
              _buildSectionHeader(context, 'Language'),
              const SizedBox(height: 8),
              _buildSettingCard(
                context,
                children: [
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.language,
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                    title: const Text('Default Language'),
                    subtitle: Text(_getLanguageName(_defaultLanguage)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: _showLanguageDialog,
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Account settings
              _buildSectionHeader(context, 'Account'),
              const SizedBox(height: 8),
              _buildSettingCard(
                context,
                children: [
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Colors.orange,
                      ),
                    ),
                    title: const Text('Edit Profile'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Edit Profile feature coming soon')),
                      );
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.logout,
                        color: Colors.red,
                      ),
                    ),
                    title: const Text('Log Out'),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Log Out'),
                          content: const Text('Are you sure you want to log out?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pushReplacementNamed(context, '/');
                              },
                              child: const Text('Log Out'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // About and Help
              _buildSectionHeader(context, 'About & Help'),
              const SizedBox(height: 8),
              _buildSettingCard(
                context,
                children: [
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.accentCyan.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.info,
                        color: AppTheme.accentCyan,
                      ),
                    ),
                    title: const Text('About Aidify'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      showAboutDialog(
                        context: context,
                        applicationName: 'Aidify',
                        applicationVersion: '1.0.0',
                        applicationIcon: const Icon(
                          Icons.accessibility_new,
                          size: 32,
                          color: AppTheme.primaryPurple,
                        ),
                        children: [
                          const Text(
                            'Aidify is an accessibility app that provides speech to text, text to speech, translation, and object detection capabilities.',
                          ),
                        ],
                      );
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryPurple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.help,
                        color: AppTheme.primaryPurple,
                      ),
                    ),
                    title: const Text('Help & Support'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Help & Support feature coming soon')),
                      );
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.privacy_tip,
                        color: Colors.green,
                      ),
                    ),
                    title: const Text('Privacy Policy'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Privacy Policy feature coming soon')),
                      );
                    },
                  ),
                ],
              ),
              
              // Save and Reset buttons
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveSettings,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Save Settings'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _resetSettings,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Reset to Default'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _showTextSizeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Text Size'),
        content: StatefulBuilder(
          builder: (context, setState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Adjust the text size for the app'),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('A', style: TextStyle(fontSize: 14)),
                  Expanded(
                    child: Slider(
                      value: _textSize,
                      min: 0.8,
                      max: 1.4,
                      divisions: 6,
                      label: _getTextSizeLabel(_textSize),
                      onChanged: (value) {
                        setState(() {
                          _textSize = value;
                        });
                        this.setState(() {});
                      },
                    ),
                  ),
                  const Text('A', style: TextStyle(fontSize: 24)),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }
  
  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Default Language'),
        content: StatefulBuilder(
          builder: (context, setState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: const Text('English (US)'),
                value: 'en-US',
                groupValue: _defaultLanguage,
                onChanged: (value) {
                  setState(() {
                    _defaultLanguage = value!;
                  });
                  this.setState(() {});
                },
              ),
              RadioListTile<String>(
                title: const Text('English (UK)'),
                value: 'en-GB',
                groupValue: _defaultLanguage,
                onChanged: (value) {
                  setState(() {
                    _defaultLanguage = value!;
                  });
                  this.setState(() {});
                },
              ),
              RadioListTile<String>(
                title: const Text('Spanish'),
                value: 'es-ES',
                groupValue: _defaultLanguage,
                onChanged: (value) {
                  setState(() {
                    _defaultLanguage = value!;
                  });
                  this.setState(() {});
                },
              ),
              RadioListTile<String>(
                title: const Text('French'),
                value: 'fr-FR',
                groupValue: _defaultLanguage,
                onChanged: (value) {
                  setState(() {
                    _defaultLanguage = value!;
                  });
                  this.setState(() {});
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  
  Widget _buildSettingCard(BuildContext context, {required List<Widget> children}) {
    return Container(
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
        children: children,
      ),
    );
  }
  
  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
    required IconData leadingIcon,
  }) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      title: Text(title),
      subtitle: Text(subtitle),
      secondary: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.primaryPurple.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          leadingIcon,
          color: AppTheme.primaryPurple,
        ),
      ),
    );
  }
  
  String _getTextSizeLabel(double size) {
    if (size <= 0.8) return 'Small';
    if (size <= 0.9) return 'Medium Small';
    if (size <= 1.0) return 'Medium (Default)';
    if (size <= 1.1) return 'Medium Large';
    if (size <= 1.2) return 'Large';
    if (size <= 1.3) return 'Extra Large';
    return 'XX Large';
  }
  
  String _getLanguageName(String code) {
    switch (code) {
      case 'en-US': return 'English (US)';
      case 'en-GB': return 'English (UK)';
      case 'es-ES': return 'Spanish';
      case 'fr-FR': return 'French';
      case 'de-DE': return 'German';
      case 'it-IT': return 'Italian';
      case 'ja-JP': return 'Japanese';
      default: return 'Unknown';
    }
  }
}
