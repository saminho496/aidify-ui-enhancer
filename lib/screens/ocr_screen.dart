
import 'package:flutter/material.dart';
import 'package:aidify/theme/app_theme.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class OcrScreen extends StatefulWidget {
  const OcrScreen({Key? key}) : super(key: key);

  @override
  _OcrScreenState createState() => _OcrScreenState();
}

class _OcrScreenState extends State<OcrScreen> {
  final TextEditingController _textController = TextEditingController();
  File? _imageFile;
  bool _isProcessing = false;
  final ImagePicker _picker = ImagePicker();
  bool _isEditing = false;
  
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );
      
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
          _isProcessing = true;
        });
        
        // Simulate OCR processing
        await Future.delayed(const Duration(seconds: 2));
        
        // Sample OCR result
        final String ocrResult = '''This is a sample OCR text.
This text would be extracted from the image in a real application.
The OCR engine would process the image and extract the text content.
You can edit this text after extraction if needed.''';
        
        setState(() {
          _textController.text = ocrResult;
          _isProcessing = false;
        });
      }
    } catch (e) {
      print('Error picking image: $e');
      setState(() {
        _isProcessing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
  
  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }
  
  void _copyText() {
    if (_textController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No text to copy')),
      );
      return;
    }
    
    // In a real app, we would use Clipboard.setData
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Text copied to clipboard')),
    );
  }
  
  void _saveText() {
    if (_textController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No text to save')),
      );
      return;
    }
    
    // In a real app, we would handle file saving
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Text saved to file')),
    );
  }
  
  void _clearAll() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All'),
        content: const Text('Are you sure you want to clear the image and text?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _imageFile = null;
                _textController.clear();
              });
              Navigator.pop(context);
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
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
        title: const Text('OCR - Text Recognition'),
        actions: [
          if (_textController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.content_copy),
              onPressed: _copyText,
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
                  color: AppTheme.primaryPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'OCR',
                  style: TextStyle(
                    color: AppTheme.primaryPurple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Optical Character Recognition',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Extract text from images or use your camera to scan documents',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 32),
              
              // Image preview
              Container(
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.border),
                ),
                child: _imageFile != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.file(
                              _imageFile!,
                              fit: BoxFit.cover,
                            ),
                            if (_isProcessing)
                              Container(
                                color: Colors.black.withOpacity(0.5),
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image,
                            size: 64,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No image selected',
                            style: TextStyle(color: AppTheme.textSecondary),
                          ),
                        ],
                      ),
              ),
              
              // Image source buttons
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Camera'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryPurple,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () => _pickImage(ImageSource.camera),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Gallery'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () => _pickImage(ImageSource.gallery),
                  ),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.clear),
                    label: const Text('Clear'),
                    onPressed: _clearAll,
                  ),
                ],
              ),
              
              // Text result
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Extracted Text',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(_isEditing ? Icons.check : Icons.edit),
                        onPressed: _toggleEditing,
                        tooltip: _isEditing ? 'Save edits' : 'Edit text',
                      ),
                      IconButton(
                        icon: const Icon(Icons.save),
                        onPressed: _saveText,
                        tooltip: 'Save to file',
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _textController,
                decoration: InputDecoration(
                  hintText: 'Extracted text will appear here...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                maxLines: 10,
                readOnly: !_isEditing,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
              
              // Word count
              if (_textController.text.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    '${_textController.text.split(RegExp(r'\s+')).where((s) => s.isNotEmpty).length} words, ${_textController.text.length} characters',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.end,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
