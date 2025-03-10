
import 'package:flutter/material.dart';
import 'package:aidify/theme/app_theme.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeechScreen extends StatefulWidget {
  const TextToSpeechScreen({Key? key}) : super(key: key);

  @override
  _TextToSpeechScreenState createState() => _TextToSpeechScreenState();
}

class _TextToSpeechScreenState extends State<TextToSpeechScreen> {
  final TextEditingController _textController = TextEditingController();
  final FlutterTts _flutterTts = FlutterTts();
  bool _isPlaying = false;
  String _language = 'en-US';
  String _voice = 'en-us-x-sfg#male_1-local';
  double _speed = 1.0;
  double _volume = 0.8;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeTts();
  }

  Future<void> _initializeTts() async {
    await _flutterTts.setLanguage(_language);
    await _flutterTts.setSpeechRate(_speed);
    await _flutterTts.setVolume(_volume);
    
    _flutterTts.setCompletionHandler(() {
      setState(() {
        _isPlaying = false;
      });
    });
  }
  
  Future<void> _handlePlayPause() async {
    if (_textController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter text to convert to speech')),
      );
      return;
    }
    
    if (_isPlaying) {
      await _flutterTts.stop();
      setState(() {
        _isPlaying = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Audio paused')),
      );
    } else {
      final result = await _flutterTts.speak(_textController.text);
      if (result == 1) {
        setState(() {
          _isPlaying = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Playing audio...')),
        );
      }
    }
  }
  
  Future<void> _handleSave() async {
    if (_textController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter text to convert to speech')),
      );
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    // Simulate saving process
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() {
      _isLoading = false;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Audio saved successfully!')),
    );
  }
  
  Future<void> _handleLanguageChange(String? value) async {
    if (value != null) {
      setState(() {
        _language = value;
      });
      await _flutterTts.setLanguage(value);
    }
  }
  
  Future<void> _handleVoiceChange(String? value) async {
    if (value != null) {
      setState(() {
        _voice = value;
      });
      // In a real app, we would set the voice here
    }
  }
  
  Future<void> _handleSpeedChange(double value) async {
    setState(() {
      _speed = value;
    });
    await _flutterTts.setSpeechRate(value);
  }
  
  Future<void> _handleVolumeChange(double value) async {
    setState(() {
      _volume = value;
    });
    await _flutterTts.setVolume(value);
  }

  @override
  void dispose() {
    _textController.dispose();
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Text to Speech'),
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
                  color: AppTheme.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Text to Speech',
                  style: TextStyle(
                    color: AppTheme.primaryBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Convert Text to Speech',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Enter text below to convert it to natural-sounding speech',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 32),
              
              // Text input
              Container(
                padding: const EdgeInsets.all(16),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Enter Your Text',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        TextButton.icon(
                          icon: const Icon(Icons.upload_file),
                          label: const Text('Upload Text'),
                          onPressed: () {
                            // In a real app, we would handle file picking here
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Upload functionality would be implemented in a real app')),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _textController,
                      decoration: const InputDecoration(
                        hintText: 'Type or paste your text here...',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 8,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${_textController.text.length} characters',
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.end,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Voice and audio settings
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Voice settings
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
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
                            'Voice Settings',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 16),
                          
                          // Language dropdown
                          DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              labelText: 'Language',
                            ),
                            value: _language,
                            onChanged: _handleLanguageChange,
                            items: const [
                              DropdownMenuItem(value: 'en-US', child: Text('English (US)')),
                              DropdownMenuItem(value: 'en-GB', child: Text('English (UK)')),
                              DropdownMenuItem(value: 'es-ES', child: Text('Spanish')),
                              DropdownMenuItem(value: 'fr-FR', child: Text('French')),
                              DropdownMenuItem(value: 'de-DE', child: Text('German')),
                              DropdownMenuItem(value: 'it-IT', child: Text('Italian')),
                              DropdownMenuItem(value: 'ja-JP', child: Text('Japanese')),
                            ],
                          ),
                          const SizedBox(height: 16),
                          
                          // Voice dropdown
                          DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              labelText: 'Voice',
                            ),
                            value: _voice,
                            onChanged: _handleVoiceChange,
                            items: const [
                              DropdownMenuItem(value: 'en-us-x-sfg#male_1-local', child: Text('Male 1')),
                              DropdownMenuItem(value: 'en-us-x-sfg#male_2-local', child: Text('Male 2')),
                              DropdownMenuItem(value: 'en-us-x-sfg#female_1-local', child: Text('Female 1')),
                              DropdownMenuItem(value: 'en-us-x-sfg#female_2-local', child: Text('Female 2')),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 16),
                  
                  // Audio settings
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
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
                            'Audio Settings',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 16),
                          
                          // Speed slider
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Speed'),
                              Text('${_speed.toStringAsFixed(1)}x'),
                            ],
                          ),
                          Slider(
                            value: _speed,
                            min: 0.5,
                            max: 2.0,
                            divisions: 15,
                            label: _speed.toStringAsFixed(1),
                            onChanged: _handleSpeedChange,
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Volume slider
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Volume'),
                              Text('${(_volume * 100).toInt()}%'),
                            ],
                          ),
                          Slider(
                            value: _volume,
                            min: 0.0,
                            max: 1.0,
                            divisions: 10,
                            label: '${(_volume * 100).toInt()}%',
                            onChanged: _handleVolumeChange,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              
              // Action buttons
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                      label: Text(_isPlaying ? 'Pause' : 'Play'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: _handlePlayPause,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.save),
                      label: Text(_isLoading ? 'Saving...' : 'Save Audio'),
                      onPressed: _isLoading ? null : _handleSave,
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
