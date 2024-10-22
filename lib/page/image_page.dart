// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:intl/intl.dart';
import 'package:pak_asisten/custom_class/custom_icon_icons.dart';
import 'package:pak_asisten/custom_class/flux_service.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:typed_data';

class ImagePage extends StatefulWidget {
  const ImagePage({super.key});

  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  final TextEditingController _promptController = TextEditingController();
  final FluxService _fluxService = FluxService();
  Uint8List? _generatedImage;
  bool _isLoading = false;
  bool _showButtons = false;

  Future<void> _generateImage() async {
    setState(() {
      _isLoading = true;
      _showButtons = false;
    });

    final generatedImage =
        await _fluxService.generateImage(_promptController.text);

    setState(() {
      _generatedImage = generatedImage;
      _isLoading = false;
      _showButtons = generatedImage != null;
    });
  }

  Future<void> _downloadImage() async {
    if (_generatedImage != null) {
      await saveImageToGallery(context, _generatedImage!);
    }
  }

  Future<void> saveImageToGallery(
      BuildContext context, Uint8List imageBytes) async {
    try {
      // Buat nama file dengan format yang diinginkan
      final now = DateTime.now();
      final formatter = DateFormat('yyyyMMdd_HHmmss');
      final String fileName =
          'Pak Asisten Image Generation_${formatter.format(now)}.png';

      // Buat file temporary dengan nama yang baru
      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/$fileName').create();
      await file.writeAsBytes(imageBytes);

      // Simpan gambar menggunakan gal
      await Gal.putImage(file.path,
          album: "Image Generation from Pak Asisiten");

      // Hapus file temporary
      await file.delete();

      // Pemberitahuan sukses
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Image saved to gallery',
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
          backgroundColor: Theme.of(context).dialogBackgroundColor,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save image: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  Future<void> _shareImage() async {
    if (_generatedImage != null) {
      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/generated_image.png').create();
      await file.writeAsBytes(_generatedImage!);

      await Share.shareXFiles([XFile(file.path)],
          text: 'Check out this generated image!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: AspectRatio(
                aspectRatio: 4 / 3,
                child: Container(
                  decoration: BoxDecoration(
                    image: _generatedImage != null
                        ? DecorationImage(
                            image: MemoryImage(_generatedImage!),
                            fit: BoxFit.cover,
                          )
                        : null,
                    color: _generatedImage == null
                        ? Theme.of(context).colorScheme.surface
                        : null,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      style: BorderStyle.solid,
                      color: Color(0xFFBBBBBB),
                      width: 1,
                    ),
                  ),
                  child: _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : null,
                ),
              ),
            ),
            SizedBox(height: 20),
            Visibility(
              visible: _showButtons,
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _downloadImage,
                      label: Text("Download",
                          style: TextStyle(
                              color: Theme.of(context)
                                  .textTheme
                                  .displayMedium
                                  ?.color)),
                      icon: Icon(CustomIcon.download),
                      iconAlignment: IconAlignment.end,
                      style: Theme.of(context).filledButtonTheme.style,
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _shareImage,
                      label: Text("Share"),
                      icon: Icon(CustomIcon.share),
                      iconAlignment: IconAlignment.end,
                      style: Theme.of(context).outlinedButtonTheme.style,
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: TextField(
                    maxLines: 3,
                    minLines: 1,
                    controller: _promptController,
                    decoration: InputDecoration(
                      hintText: "Unleash Your Imagination...",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      border: OutlineInputBorder(
                        borderSide: Theme.of(context)
                            .inputDecorationTheme
                            .border!
                            .borderSide,
                        borderRadius: BorderRadius.all(
                          Radius.circular(25),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Flexible(
                  flex: 0,
                  child: IconButton(
                    icon: Icon(CustomIcon.send),
                    onPressed: _generateImage,
                    color: Theme.of(context)
                        .bottomNavigationBarTheme
                        .unselectedIconTheme
                        ?.color,
                    visualDensity: VisualDensity.standard,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
