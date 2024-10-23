// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pak_asisten/core/services/custom_icon_icons.dart';
import 'package:pak_asisten/core/services/flux_service.dart';
import 'package:pak_asisten/presentation/widgets/filter_popup.dart';
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
  bool _showClearButton = false;
  bool _showClearFilterButton = false;

  Set<String> _selectedFilters = {};

  @override
  void initState() {
    super.initState();
    _promptController.addListener(() {
      if (mounted) {
        // Periksa apakah widget masih aktif
        setState(() {
          _showClearButton = _promptController.text.isNotEmpty;
        });
      }
    });
  }

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  Future<void> _generateImage() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _showButtons = false;
      });
    }

    try {
      String fullPrompt = _promptController.text;
      if (_selectedFilters.isNotEmpty) {
        fullPrompt += ', ${_selectedFilters.join(', ')}';
      }

      final generatedImage = await _fluxService.generateImage(fullPrompt);

      if (mounted) {
        setState(() {
          _generatedImage = generatedImage;
          _isLoading = false;
          _showButtons = generatedImage != null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error generating image: $e',
              style: GoogleFonts.lato(
                fontSize: 12,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
            duration: Duration(seconds: 1),
          ),
        );
      }
    }
  }

  Future<void> _downloadImage() async {
    if (_generatedImage != null) {
      try {
        await saveImageToGallery(context, _generatedImage!);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to save image: $e',
              style: GoogleFonts.lato(
                fontSize: 12,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
            duration: Duration(seconds: 1),
          ),
        );
      }
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
            style: GoogleFonts.lato(
              fontSize: 16,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
          backgroundColor: Theme.of(context).dialogBackgroundColor,
          duration: Duration(seconds: 1),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to save image: $e',
            style: GoogleFonts.lato(
              fontSize: 12,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  Future<void> _shareImage() async {
    if (_generatedImage != null) {
      try {
        final tempDir = await getTemporaryDirectory();
        final file = await File('${tempDir.path}/generated_image.png').create();
        await file.writeAsBytes(_generatedImage!);

        await Share.shareXFiles([XFile(file.path)],
            text: 'Check out this generated image!');

        // Hapus file temporary
        await file.delete();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to share image: $e',
              style: GoogleFonts.lato(
                fontSize: 12,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
            duration: Duration(seconds: 1),
          ),
        );
      }
    }
  }

  void _updateFilters(List<String> filters) {
    setState(() {
      _selectedFilters = filters.toSet();
      _showClearFilterButton = _selectedFilters.isNotEmpty;
    });
  }

  void _clearFilters() {
    setState(() {
      _selectedFilters.clear();
      _showClearFilterButton = false;
    });
  }

  void _showFilterPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: FilterPopup(
            selectedFilters: _selectedFilters.toList(),
            onFiltersChanged: _updateFilters,
          ),
        );
      },
    );
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: AspectRatio(
                          aspectRatio: 4 / 3,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                style: BorderStyle.solid,
                                color: Theme.of(context).colorScheme.outline,
                                width: 1,
                              ),
                            ),
                            child: _isLoading
                                ? Center(
                                    child: Image.asset(
                                      'assets/other/loading.gif',
                                      height: 100,
                                      width: 100,
                                    ),
                                  )
                                : _generatedImage != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(25),
                                        child: Image.memory(
                                          _generatedImage!,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Center(
                                        child: Text(
                                          "Image not generated",
                                          style: GoogleFonts.lato(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .outline,
                                            fontSize: 18,
                                            fontWeight: FontWeight.normal,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
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
                                    style: GoogleFonts.lato(
                                        color: Theme.of(context)
                                            .textTheme
                                            .displayMedium
                                            ?.color)),
                                icon: Icon(CustomIcon.download),
                                iconAlignment: IconAlignment.end,
                                style:
                                    Theme.of(context).filledButtonTheme.style,
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: _shareImage,
                                label: Text("Share"),
                                icon: Icon(CustomIcon.share),
                                iconAlignment: IconAlignment.end,
                                style:
                                    Theme.of(context).outlinedButtonTheme.style,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 30,
                      child: ElevatedButton(
                        onPressed: _showFilterPopup,
                        style: ButtonStyle(
                          backgroundColor: Theme.of(context)
                              .outlinedButtonTheme
                              .style
                              ?.backgroundColor,
                          alignment: Alignment.center,
                          padding: WidgetStateProperty.all(
                              EdgeInsets.symmetric(horizontal: 10)),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              side: BorderSide(
                                  color: Color(0xFF274688),
                                  width: 1,
                                  style: BorderStyle.solid),
                            ),
                          ),
                        ),
                        child: Text(
                          'Filter',
                          style: GoogleFonts.lato(
                            fontSize: 14,
                            color: Color(0xFF274688),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    if (_showClearFilterButton)
                      SizedBox(
                        width: 30,
                        height: 30,
                        child: Center(
                          child: IconButton(
                            onPressed: _clearFilters,
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                            style: ButtonStyle(
                              alignment: Alignment.center,
                              padding: WidgetStateProperty.all(EdgeInsets.zero),
                              minimumSize:
                                  WidgetStateProperty.all(Size(30, 30)),
                              fixedSize: WidgetStateProperty.all(Size(30, 30)),
                              maximumSize:
                                  WidgetStateProperty.all(Size(30, 30)),
                              shape: WidgetStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              backgroundColor: WidgetStateProperty.all(
                                  Theme.of(context).colorScheme.primary),
                            ),
                            icon: Icon(Icons.clear_rounded,
                                color: Colors.white, size: 18),
                            alignment: Alignment.center,
                          ),
                        ),
                      )
                  ],
                ),
                SizedBox(height: 12),
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
                          hintText: "Unleash your imagination...",
                          hintStyle:
                              GoogleFonts.lato(color: Colors.grey, fontSize: 14),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          border: OutlineInputBorder(
                            borderSide: Theme.of(context)
                                .inputDecorationTheme
                                .border!
                                .borderSide,
                            borderRadius: BorderRadius.all(
                              Radius.circular(25),
                            ),
                          ),
                          suffixIcon: _showClearButton
                              ? IconButton(
                                  icon: Icon(Icons.clear_rounded),
                                  onPressed: () {
                                    _promptController.clear();
                                  },
                                )
                              : null,
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
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
