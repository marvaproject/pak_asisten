// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:pak_asisten/custom_class/custom_icon_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'dart:io';
import 'package:flutter/services.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  File? _image;
  final TextRecognizer _textRecognizer = TextRecognizer();
  final TextEditingController _textController = TextEditingController();
  bool _isProcessing = false;
  final ValueNotifier<bool> _hasText = ValueNotifier<bool>(false);

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _recognizeText() async {
    if (_image == null) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      final inputImage = InputImage.fromFile(_image!);
      final recognizedText = await _textRecognizer.processImage(inputImage);

      setState(() {
        _textController.text = recognizedText.text;
        _isProcessing = false;
      });
      _hasText.value = _textController.text.isNotEmpty; // Tambahkan ini
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error recognizing text',
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
          backgroundColor: Theme.of(context).dialogBackgroundColor,
          duration: Duration(milliseconds: 700),
        ),
      );
    }
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _textController.text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Copied to clipboard',
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
        backgroundColor: Theme.of(context).dialogBackgroundColor,
        duration: Duration(milliseconds: 700),
      ),
    );
  }

  @override
  void dispose() {
    _textRecognizer.close();
    _textController.dispose();
    _hasText.dispose(); // Tambahkan ini
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 4 / 3,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      image: _image != null
                          ? DecorationImage(
                              image: FileImage(_image!),
                              fit: BoxFit.cover,
                            )
                          : null,
                      color: _image == null
                          ? Theme.of(context).colorScheme.surface
                          : null,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        style: BorderStyle.solid,
                        color: Theme.of(context).colorScheme.outline,
                        width: 1,
                      ),
                    ),
                    child: _image == null
                        ? Text(
                            "Image not selected",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.outline,
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                            ),
                            textAlign: TextAlign.center,
                          )
                        : null,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _getImage(ImageSource.camera),
                        label: Text("Open Camera",
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .displayMedium
                                    ?.color)),
                        icon: Icon(CustomIcon.camera),
                        iconAlignment: IconAlignment.end,
                        style: Theme.of(context).filledButtonTheme.style,
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _getImage(ImageSource.gallery),
                        label: Text("Upload Image"),
                        icon: Icon(CustomIcon.upload),
                        iconAlignment: IconAlignment.end,
                        style: Theme.of(context).outlinedButtonTheme.style,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _textController,
                  maxLines: 3,
                  onChanged: (text) {
                    _hasText.value = text.isNotEmpty; // Tambahkan ini
                  },
                  decoration: InputDecoration(
                    hintText: "Recognized Text Result...",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                    contentPadding: EdgeInsets.all(20),
                    border: OutlineInputBorder(
                      borderSide: Theme.of(context)
                          .inputDecorationTheme
                          .border!
                          .borderSide,
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                    ),
                    suffixIcon: ValueListenableBuilder<bool>(
                      valueListenable: _hasText,
                      builder: (context, hasText, child) {
                        return hasText
                            ? IconButton(
                                icon: Icon(
                                  CustomIcon.clipboard,
                                  size: 20,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.color,
                                ),
                                onPressed: _copyToClipboard,
                              )
                            : SizedBox.shrink();
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20),
                if (_image != null)
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: TextButton(
                      onPressed: _isProcessing ? null : _recognizeText,
                      style: Theme.of(context).filledButtonTheme.style,
                      child: _isProcessing
                          ? CircularProgressIndicator()
                          : Text(
                              "Generate",
                              style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .displayMedium
                                    ?.color,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
