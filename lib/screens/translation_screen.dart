
import 'package:flutter/material.dart';
import 'package:aidify/theme/app_theme.dart';

class TranslationScreen extends StatefulWidget {
  const TranslationScreen({Key? key}) : super(key: key);

  @override
  _TranslationScreenState createState() => _TranslationScreenState();
}

class _TranslationScreenState extends State<TranslationScreen> {
  final TextEditingController _sourceTextController = TextEditingController();
  final TextEditingController _translatedTextController = TextEditingController();
  String _sourceLanguage = 'en';
  String _targetLanguage = 'es';
  bool _isTranslating = false;

  @override
  void dispose() {
    _sourceTextController.dispose();
    _translatedTextController.dispose();
    super.dispose();
  }

  void _handleTranslate() {
    if (_sourceTextController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter text to translate')),
      );
      return;
    }
    
    setState(() {
      _isTranslating = true;
    });
    
    // Simulate API call with a delay
    Future.delayed(const Duration(seconds: 2), () {
      // Sample translations for demo purposes
      final Map<String, Map<String, String>> translations = {
        'en': {
          'es': "Este es un ejemplo de texto traducido al español. En una aplicación real, esto sería reemplazado con una traducción real.",
          'fr': "Ceci est un exemple de texte traduit en français. Dans une vraie application, cela serait remplacé par une vraie traduction.",
          'de': "Dies ist ein Beispiel für einen ins Deutsche übersetzten Text. In einer echten Anwendung würde dies durch eine echte Übersetzung ersetzt werden.",
        },
        'es': {
          'en': "This is an example of text translated to English. In a real application, this would be replaced with an actual translation.",
        },
      };
      
      // Get translation if available, otherwise use placeholder
      final translation = translations[_sourceLanguage]?[_targetLanguage] ?? 
        "This is a placeholder translation. In a real application, this would be replaced with an actual translation.";
      
      setState(() {
        _translatedTextController.text = translation;
        _isTranslating = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Translation complete!')),
      );
    });
  }
  
  void _handleSwapLanguages() {
    if (_translatedTextController.text.isEmpty) return;
    
    setState(() {
      // Swap languages
      final tempLang = _sourceLanguage;
      _sourceLanguage = _targetLanguage;
      _targetLanguage = tempLang;
      
      // Swap text
      final tempText = _sourceTextController.text;
      _sourceTextController.text = _translatedTextController.text;
      _translatedTextController.text = tempText;
    });
  }
  
  void _handleCopyText() {
    if (_translatedTextController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No translation to copy')),
      );
      return;
    }
    
    // In a real app, we would use Clipboard.setData
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Translation copied to clipboard')),
    );
  }
  
  void _clearText() {
    setState(() {
      _sourceTextController.clear();
      _translatedTextController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Translation'),
        actions: [
          IconButton(
            icon: const Icon(Icons.content_copy),
            onPressed: _translatedTextController.text.isNotEmpty ? _handleCopyText : null,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.accentCyan.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Translation',
                  style: TextStyle(
                    color: AppTheme.accentCyan,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Language Translation',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Translate text between multiple languages with high accuracy',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 32),
              
              // Source language selector and input
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DropdownButton<String>(
                    value: _sourceLanguage,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _sourceLanguage = value;
                        });
                      }
                    },
                    items: const [
                      DropdownMenuItem(value: 'en', child: Text('English')),
                      DropdownMenuItem(value: 'es', child: Text('Spanish')),
                      DropdownMenuItem(value: 'fr', child: Text('French')),
                      DropdownMenuItem(value: 'de', child: Text('German')),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.mic),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Voice input feature coming soon')),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _sourceTextController,
                decoration: const InputDecoration(
                  hintText: 'Enter text to translate...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
              ),
              const SizedBox(height: 8),
              Text(
                '${_sourceTextController.text.length} characters',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.end,
              ),
              
              // Swap languages button
              Center(
                child: IconButton(
                  icon: const Icon(Icons.swap_vert),
                  onPressed: _handleSwapLanguages,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppTheme.accentCyan,
                    padding: const EdgeInsets.all(12),
                    shape: const CircleBorder(),
                    shadowColor: Colors.black12,
                    elevation: 4,
                  ),
                ),
              ),
              
              // Target language selector and output
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DropdownButton<String>(
                    value: _targetLanguage,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _targetLanguage = value;
                        });
                      }
                    },
                    items: const [
                      DropdownMenuItem(value: 'en', child: Text('English')),
                      DropdownMenuItem(value: 'es', child: Text('Spanish')),
                      DropdownMenuItem(value: 'fr', child: Text('French')),
                      DropdownMenuItem(value: 'de', child: Text('German')),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.volume_up),
                    onPressed: _translatedTextController.text.isNotEmpty 
                        ? () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Text-to-speech feature coming soon')),
                            );
                          }
                        : null,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Stack(
                children: [
                  TextField(
                    controller: _translatedTextController,
                    decoration: const InputDecoration(
                      hintText: 'Translation will appear here...',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 5,
                    readOnly: true,
                  ),
                  if (_isTranslating)
                    Positioned.fill(
                      child: Container(
                        color: Colors.white.withOpacity(0.8),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${_translatedTextController.text.length} characters',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.end,
              ),
              
              // Action buttons
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isTranslating ? null : _handleTranslate,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accentCyan,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(_isTranslating ? 'Translating...' : 'Translate'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  OutlinedButton(
                    onPressed: _clearText,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.refresh),
                        SizedBox(width: 8),
                        Text('Clear'),
                      ],
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
}
