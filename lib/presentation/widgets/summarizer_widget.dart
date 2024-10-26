// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pak_asisten/core/services/custom_icon_icons.dart';
import 'package:pak_asisten/core/services/summarizer_service.dart';

class SummarizerWidget extends StatefulWidget {
  const SummarizerWidget({super.key});

  @override
  _SummarizerWidgetState createState() => _SummarizerWidgetState();
}

class _SummarizerWidgetState extends State<SummarizerWidget> {
  static const _snackBarDuration = Duration(seconds: 1);
  static const _borderRadius = BorderRadius.all(Radius.circular(25));
  static const _languages = ['English'];

  final ValueNotifier<bool> _hasSourceText = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _hasSummarizedText = ValueNotifier<bool>(false);
  final TextEditingController _sourceTextController = TextEditingController();
  final TextEditingController _summarizedTextController =
      TextEditingController();

  String _selectedLanguage = 'English';
  bool _isSummarizing = false;

  @override
  void initState() {
    super.initState();
    _sourceTextController.addListener(
        () => _hasSourceText.value = _sourceTextController.text.isNotEmpty);
  }

  @override
  void dispose() {
    _sourceTextController.dispose();
    _summarizedTextController.dispose();
    _hasSourceText.dispose();
    _hasSummarizedText.dispose();
    super.dispose();
  }

  Future<void> _summarizeText() async {
    if (_sourceTextController.text.isEmpty) return;

    setState(() {
      _isSummarizing = true;
      _summarizedTextController.text = 'Summarizing...';
    });

    try {
      final summary = await SummarizerService.summarizeText(
        _sourceTextController.text,
        _selectedLanguage,
      );
      if (mounted) {
        setState(() {
          _summarizedTextController.text = summary;
          _hasSummarizedText.value = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _summarizedTextController.text = 'Error: ${e.toString()}';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSummarizing = false;
        });
      }
    }
  }

  void _clearSourceText() {
    setState(() {
      _sourceTextController.clear();
      _summarizedTextController.clear();
      _hasSourceText.value = false;
      _hasSummarizedText.value = false;
      _isSummarizing = false;
    });
  }

  void _copyToClipboard(TextEditingController controller) {
    if (controller.text.isEmpty) return;
    Clipboard.setData(ClipboardData(text: controller.text))
        .then((_) => _showSuccessSnackBar('Copied to clipboard'));
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message,
            style: GoogleFonts.lato(
                fontSize: 16,
                color: Theme.of(context).textTheme.bodyMedium?.color)),
        backgroundColor: Theme.of(context).dialogBackgroundColor,
        duration: _snackBarDuration,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Text Summarizer',
            style: Theme.of(context).textTheme.displayLarge),
        const SizedBox(height: 15),
        _buildTextField(
          controller: _sourceTextController,
          hintText: "Enter text to summarize...",
          hasText: _hasSourceText,
          onCopy: () => _copyToClipboard(_sourceTextController),
          onClear: _clearSourceText,
        ),
        if (_isSummarizing || _hasSummarizedText.value) ...[
          const SizedBox(height: 15),
          _buildTextField(
            controller: _summarizedTextController,
            hintText: "Summary result...",
            hasText: _hasSummarizedText,
            onCopy: () => _copyToClipboard(_summarizedTextController),
            readOnly: true,
          ),
        ],
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: SizedBox(
                height: 44,
                child: ElevatedButton.icon(
                  onPressed: _isSummarizing ? null : _summarizeText,
                  label: Text(
                    _isSummarizing ? "Summarizing..." : "Summarize",
                    style: GoogleFonts.lato(
                        color:
                            Theme.of(context).textTheme.displayMedium?.color),
                  ),
                  icon: Icon(_isSummarizing
                      ? Icons.hourglass_empty_rounded
                      : CustomIcon.summarizer),
                  iconAlignment: IconAlignment.end,
                  style: Theme.of(context).filledButtonTheme.style,
                ),
              ),
            ),
            const SizedBox(width: 15),
            Flexible(
              flex: 2,
              child: SizedBox(
                height: 44,
                child: _buildConstrainedDropdown(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildConstrainedDropdown() {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFF274688), width: 0.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x4C274688),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton<String>(
            value: _selectedLanguage,
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  _selectedLanguage = newValue;
                });
              }
            },
            isExpanded: true,
            icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF274688)),
            style: GoogleFonts.lato(
              fontSize: 15,
              color: const Color(0xFF274688),
              fontWeight: FontWeight.bold,
            ),
            borderRadius: BorderRadius.circular(25),
            dropdownColor: Theme.of(context).colorScheme.tertiaryContainer,
            menuMaxHeight: MediaQuery.of(context).size.height * 0.6,
            itemHeight: 50,
            items: _languages.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Container(
                  constraints: const BoxConstraints(minWidth: 120),
                  child: Text(
                    value,
                    style: GoogleFonts.lato(),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required ValueNotifier<bool> hasText,
    required VoidCallback onCopy,
    bool readOnly = false,
    VoidCallback? onClear,
  }) {
    return TextField(
      controller: controller,
      maxLines: 5,
      readOnly: readOnly,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.lato(color: Colors.grey, fontSize: 14),
        contentPadding: const EdgeInsets.all(20),
        filled: true,
        fillColor: Theme.of(context).colorScheme.inverseSurface,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color:
                Theme.of(context).inputDecorationTheme.border!.borderSide.color,
            width: 0.5,
          ),
          borderRadius: _borderRadius,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color:
                Theme.of(context).inputDecorationTheme.border!.borderSide.color,
            width: 0.5,
          ),
          borderRadius: _borderRadius,
        ),
        suffixIcon: ValueListenableBuilder<bool>(
          valueListenable: hasText,
          builder: (context, hasText, child) {
            return hasText
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(CustomIcon.clipboard,
                            size: 20,
                            color:
                                Theme.of(context).textTheme.bodyMedium?.color),
                        onPressed: onCopy,
                      ),
                      if (onClear != null)
                        IconButton(
                          icon: Icon(Icons.clear_rounded,
                              size: 20,
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.color),
                          onPressed: onClear,
                        ),
                    ],
                  )
                : const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
