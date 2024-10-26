// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pak_asisten/core/services/custom_icon_icons.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  File? _image;
  late final TextRecognizer _textRecognizer;
  final TextEditingController _textController = TextEditingController();
  bool _isProcessing = false;
  bool _isImageLoading = false;
  final ValueNotifier<bool> _hasText = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _textRecognizer = TextRecognizer();
  }

  Future<void> _getImage(ImageSource source) async {
    try {
      setState(() => _isImageLoading = true);

      final pickedFile = await ImagePicker().pickImage(
        source: source,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
          _textController.clear();
          _hasText.value = false;
        });
      }
    } on PlatformException catch (e) {
      _showErrorSnackBar('Failed to pick image: ${e.message}');
    } catch (e) {
      _showErrorSnackBar('An unexpected error occurred');
    } finally {
      setState(() => _isImageLoading = false);
    }
  }

  Future<void> _recognizeText() async {
    if (_image == null) {
      _showErrorSnackBar('Please select an image first');
      return;
    }

    setState(() => _isProcessing = true);

    try {
      final inputImage = InputImage.fromFile(_image!);
      final recognizedText = await _textRecognizer.processImage(inputImage);

      setState(() {
        _textController.text = recognizedText.text;
        _hasText.value = recognizedText.text.isNotEmpty;
      });
    } catch (e) {
      _showErrorSnackBar('Error recognizing text. Please try again');
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  void _copyToClipboard() {
    if (_textController.text.isEmpty) return;

    Clipboard.setData(ClipboardData(text: _textController.text));
    _showSuccessSnackBar('Copied to clipboard');
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.lato(
            fontSize: 16,
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.error,
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.lato(
            fontSize: 16,
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
        backgroundColor: Theme.of(context).dialogBackgroundColor,
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  void dispose() {
    _textRecognizer.close();
    _textController.dispose();
    _hasText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Text('Text Recognition',
                          style: Theme.of(context).textTheme.displayLarge),
                      SizedBox(height: 15),
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
                              width: 0.5,
                            ),
                          ),
                          child: _image == null
                              ? Text(
                                  "Image not selected",
                                  style: GoogleFonts.lato(
                                    color:
                                        Theme.of(context).colorScheme.outline,
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
                              onPressed: _isImageLoading
                                  ? null
                                  : () => _getImage(ImageSource.camera),
                              label: Text("Open Camera",
                                  style: GoogleFonts.lato(
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
                              onPressed: _isImageLoading
                                  ? null
                                  : () => _getImage(ImageSource.gallery),
                              label: Text("Upload Image"),
                              icon: Icon(CustomIcon.upload),
                              iconAlignment: IconAlignment.end,
                              style:
                                  Theme.of(context).outlinedButtonTheme.style,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: _textController,
                        minLines: 3,
                        maxLines: 7,
                        onChanged: (text) {
                          _hasText.value = text.isNotEmpty;
                        },
                        decoration: InputDecoration(
                          hintText: "Recognized text results...",
                          hintStyle: GoogleFonts.lato(
                              color: Colors.grey, fontSize: 14),
                          contentPadding: EdgeInsets.all(20),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context)
                                    .inputDecorationTheme
                                    .border!
                                    .borderSide
                                    .color,
                                width: 0.5),
                            borderRadius: BorderRadius.all(
                              Radius.circular(25),
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context)
                                    .inputDecorationTheme
                                    .border!
                                    .borderSide
                                    .color,
                                width: 0.5),
                            borderRadius: BorderRadius.all(
                              Radius.circular(25),
                            ),
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
                    ],
                  ),
                ),
              ),
            ),
            if (_image != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: TextButton(
                    onPressed: _isProcessing ? null : _recognizeText,
                    style: Theme.of(context).filledButtonTheme.style,
                    child: _isProcessing
                        ? CircularProgressIndicator()
                        : Text(
                            "Generate",
                            style: GoogleFonts.lato(
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
              ),
          ],
        ),
      ),
    );
  }
}
