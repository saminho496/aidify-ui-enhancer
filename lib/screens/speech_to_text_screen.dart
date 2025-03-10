
import 'package:flutter/material.dart';
import 'package:aidify/theme/app_theme.dart';
import 'dart:async';

class SpeechToTextScreen extends StatefulWidget {
  const SpeechToTextScreen({Key? key}) : super(key: key);

  @override
  _SpeechToTextScreenState createState() => _SpeechToTextScreenState();
}

class _SpeechToTextScreenState extends State<SpeechToTextScreen> {
  bool isRecording = false;
  bool isLoading = false;
  String text = '';
  String selectedLanguage = 'en-US';
  int recordingTime = 0;
  Timer? recordingTimer;

  void handleRecord() {
    if (isRecording) {
      // Stop recording
      recordingTimer?.cancel();
      setState(() {
        isRecording = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Recording stopped')),
      );
      
      // Simulate processing
      setState(() {
        isLoading = true;
      });
      
      Timer(const Duration(seconds: 2), () {
        setState(() {
          text += (text.isEmpty ? '' : '\n\n') + 
            'This is a sample transcribed text to demonstrate the speech to text functionality. In a real application, this would be replaced with actual transcription from your microphone recording.';
          isLoading = false;
        });
      });
    } else {
      // Start recording
      setState(() {
        isRecording = true;
        recordingTime = 0;
      });
      
      recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          recordingTime++;
        });
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Recording started')),
      );
    }
  }

  void handleCopyText() {
    if (text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No text to copy')),
      );
      return;
    }
    
    // In a real app, we would use clipboard functionality here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Text copied to clipboard')),
    );
  }

  void handleSaveText() {
    if (text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No text to save')),
      );
      return;
    }
    
    // In a real app, we would save the file here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Text saved to file')),
    );
  }

  void handleClearText() {
    if (text.trim().isEmpty) return;
    
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
                text = '';
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Text cleared')),
              );
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  String formatTime(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    recordingTimer?.cancel();
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
        title: const Text('Speech to Text'),
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
                  color: AppTheme.primaryPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Speech to Text',
                  style: TextStyle(
                    color: AppTheme.primaryPurple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Convert Speech to Text',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Record your voice or upload an audio file to convert to text',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 32),
              
              // Main content
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Recording options
                  Expanded(
                    flex: 1,
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
                            'Recording Options',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 16),
                          
                          // Language dropdown
                          DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              labelText: 'Language',
                            ),
                            value: selectedLanguage,
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  selectedLanguage = value;
                                });
                              }
                            },
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
                          
                          // Record button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              icon: Icon(isRecording ? Icons.mic_off : Icons.mic),
                              label: Text(isRecording ? 'Stop Recording' : 'Start Recording'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isRecording ? Colors.red : AppTheme.primaryPurple,
                              ),
                              onPressed: handleRecord,
                            ),
                          ),
                          
                          if (isRecording) ...[
                            const SizedBox(height: 16),
                            Text(
                              'Recording: ${formatTime(recordingTime)}',
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            LinearProgressIndicator(
                              value: recordingTime / 180,
                              backgroundColor: Colors.red.withOpacity(0.1),
                              valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
                            ),
                          ],
                          
                          const SizedBox(height: 24),
                          const Divider(),
                          const SizedBox(height: 16),
                          
                          // Upload audio
                          const Text('Or upload an audio file'),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              icon: const Icon(Icons.upload_file),
                              label: const Text('Upload Audio'),
                              onPressed: () {
                                // In a real app, we would handle file picking here
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Upload functionality would be implemented in a real app')),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 16),
                  
                  // Transcription area
                  Expanded(
                    flex: 2,
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
                          // Title and actions
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Transcription',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.copy),
                                    onPressed: text.isEmpty ? null : handleCopyText,
                                    tooltip: 'Copy text',
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.save),
                                    onPressed: text.isEmpty ? null : handleSaveText,
                                    tooltip: 'Save text',
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.refresh),
                                    onPressed: text.isEmpty ? null : handleClearText,
                                    tooltip: 'Clear text',
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          
                          // Text area
                          Container(
                            height: 300,
                            decoration: BoxDecoration(
                              border: Border.all(color: AppTheme.border),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Stack(
                              children: [
                                TextField(
                                  maxLines: null,
                                  expands: true,
                                  enabled: !isLoading,
                                  controller: TextEditingController(text: text),
                                  onChanged: (value) {
                                    setState(() {
                                      text = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    hintText: isLoading 
                                      ? 'Processing...' 
                                      : 'Your transcription will appear here...',
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.all(16),
                                  ),
                                ),
                                
                                if (isLoading)
                                  Container(
                                    color: Colors.white.withOpacity(0.7),
                                    child: const Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          CircularProgressIndicator(),
                                          SizedBox(height: 16),
                                          Text('Processing audio...'),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${text.length} characters',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              Text(
                                '${text.split(RegExp(r'\s+')).where((s) => s.isNotEmpty).length} words',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ],
                      ),
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
