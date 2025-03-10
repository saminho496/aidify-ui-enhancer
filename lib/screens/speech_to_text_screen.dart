
import 'package:flutter/material.dart';
import 'package:aidify/theme/app_theme.dart';
import 'package:aidify/components/glass_card.dart';

class SpeechToTextScreen extends StatefulWidget {
  const SpeechToTextScreen({Key? key}) : super(key: key);

  @override
  _SpeechToTextScreenState createState() => _SpeechToTextScreenState();
}

class _SpeechToTextScreenState extends State<SpeechToTextScreen> {
  bool _isRecording = false;
  String _text = '';
  String _selectedLanguage = 'en-US';
  bool _isLoading = false;
  int _recordingTime = 0;
  
  final List<Map<String, String>> _languages = [
    {'code': 'en-US', 'name': 'English (US)'},
    {'code': 'en-GB', 'name': 'English (UK)'},
    {'code': 'es-ES', 'name': 'Spanish'},
    {'code': 'fr-FR', 'name': 'French'},
    {'code': 'de-DE', 'name': 'German'},
    {'code': 'it-IT', 'name': 'Italian'},
    {'code': 'ja-JP', 'name': 'Japanese'},
  ];

  void _handleRecord() {
    if (_isRecording) {
      // Stop recording
      setState(() {
        _isRecording = false;
        _isLoading = true;
      });
      
      // Simulate processing
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          _text += (_text.isEmpty ? '' : '\n\n') + 
              'This is a sample transcribed text to demonstrate the speech to text functionality. ' +
              'In a real application, this would be replaced with actual transcription from your microphone recording.';
          _isLoading = false;
        });
      });
    } else {
      // Start recording
      setState(() {
        _isRecording = true;
        _recordingTime = 0;
      });
      
      // Start timer
      _startRecordingTimer();
    }
  }
  
  void _startRecordingTimer() {
    Future.delayed(Duration(seconds: 1), () {
      if (_isRecording) {
        setState(() {
          _recordingTime++;
        });
        _startRecordingTimer();
      }
    });
  }
  
  String _formatTime(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }
  
  void _handleCopyText() {
    if (_text.trim().isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Text copied to clipboard'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No text to copy'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  void _handleSaveText() {
    if (_text.trim().isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Text saved to file'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No text to save'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  void _handleClearText() {
    if (_text.trim().isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Clear Text'),
          content: const Text('Are you sure you want to clear all text?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _text = '';
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Text cleared'),
                    backgroundColor: Colors.blue,
                  ),
                );
              },
              child: const Text('Clear'),
            ),
          ],
        ),
      );
    }
  }
  
  void _handleFileUpload() {
    // Simulate file upload and processing
    setState(() {
      _isLoading = true;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Processing audio file...'),
        duration: Duration(seconds: 1),
      ),
    );
    
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _text += (_text.isEmpty ? '' : '\n\n') +
            'This is a sample transcribed text from the uploaded audio file. ' +
            'In a real application, this would be replaced with actual transcription from your audio file.';
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Audio file processed successfully'),
          backgroundColor: Colors.green,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacementNamed(context, '/dashboard'),
        ),
        title: const Text('Speech to Text'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.primaryPurple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Speech to Text',
                style: TextStyle(
                  color: AppTheme.primaryPurple,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Convert Speech to Text',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Record your voice or upload an audio file to convert to text',
              style: TextStyle(
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            
            // Main content with two cards
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 600) {
                  // For larger screens, show side by side
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: _buildOptionsCard(),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: _buildTranscriptionCard(),
                      ),
                    ],
                  );
                } else {
                  // For smaller screens, stack vertically
                  return Column(
                    children: [
                      _buildOptionsCard(),
                      const SizedBox(height: 16),
                      _buildTranscriptionCard(),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildOptionsCard() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recording Options',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // Language selector
          const Text('Language'),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.border),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedLanguage,
                isExpanded: true,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                borderRadius: BorderRadius.circular(8),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedLanguage = value;
                    });
                  }
                },
                items: _languages.map((language) {
                  return DropdownMenuItem<String>(
                    value: language['code'],
                    child: Text(language['name']!),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Record button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _handleRecord,
              icon: Icon(_isRecording ? Icons.mic_off : Icons.mic),
              label: Text(_isRecording ? 'Stop Recording' : 'Start Recording'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _isRecording ? Colors.red : AppTheme.primaryPurple,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          
          if (_isRecording) ...[
            const SizedBox(height: 16),
            Center(
              child: Text(
                'Recording: ${_formatTime(_recordingTime)}',
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: _recordingTime / 180, // 3 minutes max
                backgroundColor: Colors.red.withOpacity(0.2),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
              ),
            ),
          ],
          
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),
          
          const Text(
            'Or upload an audio file',
            style: TextStyle(
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _handleFileUpload,
              icon: const Icon(Icons.upload_file),
              label: const Text('Upload Audio'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTranscriptionCard() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Transcription',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: _handleCopyText,
                    icon: const Icon(Icons.copy),
                    tooltip: 'Copy Text',
                    iconSize: 20,
                  ),
                  IconButton(
                    onPressed: _handleSaveText,
                    icon: const Icon(Icons.save),
                    tooltip: 'Save to File',
                    iconSize: 20,
                  ),
                  IconButton(
                    onPressed: _handleClearText,
                    icon: const Icon(Icons.refresh),
                    tooltip: 'Clear Text',
                    iconSize: 20,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Stack(
            children: [
              Container(
                height: 300,
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.border),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: TextEditingController(text: _text),
                  onChanged: (value) {
                    setState(() {
                      _text = value;
                    });
                  },
                  maxLines: null,
                  expands: true,
                  decoration: InputDecoration(
                    hintText: _isLoading 
                        ? 'Processing...' 
                        : 'Your transcription will appear here...',
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(16),
                  ),
                  enabled: !_isLoading,
                ),
              ),
              if (_isLoading)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text(
                            'Processing audio...',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_text.length} characters',
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                ),
              ),
              Text(
                '${_text.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length} words',
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
