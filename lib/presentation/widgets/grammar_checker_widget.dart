// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pak_asisten/core/services/custom_icon_icons.dart';
import 'package:pak_asisten/core/services/grammar_checker_service.dart';

class GrammarCheckerWidget extends StatefulWidget {
  const GrammarCheckerWidget({super.key});

  @override
  _GrammarCheckerWidgetState createState() => _GrammarCheckerWidgetState();
}

class _GrammarCheckerWidgetState extends State<GrammarCheckerWidget> {
  static const _borderRadius = BorderRadius.all(Radius.circular(25));

  final GrammarCheckerService _grammarCheckerService = GrammarCheckerService();

  final ValueNotifier<bool> _hasSourceText = ValueNotifier<bool>(false);
  final TextEditingController _sourceTextController = TextEditingController();
  final TextEditingController _checkedTextController = TextEditingController();

  bool _isChecking = false;

  @override
  void initState() {
    super.initState();
    _sourceTextController.addListener(
        () => _hasSourceText.value = _sourceTextController.text.isNotEmpty);
  }

  @override
  void dispose() {
    _sourceTextController.dispose();
    _checkedTextController.dispose();
    _hasSourceText.dispose();
    super.dispose();
  }

  void _clearSourceText() {
    setState(() {
      _sourceTextController.clear();
      _checkedTextController.clear();
      _hasSourceText.value = false;
    });
  }

  void _copyToClipboard(TextEditingController controller) {
    if (controller.text.isEmpty) return;
    Clipboard.setData(ClipboardData(text: controller.text)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Copied to clipboard',
              style: GoogleFonts.lato(
                  fontSize: 16,
                  color: Theme.of(context).textTheme.bodyMedium?.color)),
          duration: const Duration(seconds: 1),
        ),
      );
    });
  }

  Future<void> _checkGrammar() async {
    if (_sourceTextController.text.isEmpty) return;

    setState(() {
      _isChecking = true;
    });

    try {
      String result =
          await _grammarCheckerService.checkGrammar(_sourceTextController.text);
      setState(() {
        _checkedTextController.text = result;
      });
    } catch (e) {
      _showErrorSnackBar(
          'Error checking grammar: $e');
    } finally {
      setState(() {
        _isChecking = false;
      });
    }
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
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Grammar Checker',
            style: Theme.of(context).textTheme.displayLarge),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _sourceTextController,
          hintText: "Enter text to check grammar...",
          hasText: _hasSourceText,
          onCopy: () => _copyToClipboard(_sourceTextController),
          onClear: _clearSourceText,
        ),
        const SizedBox(height: 16),
        if (_isChecking || _checkedTextController.text.isNotEmpty) ...[
          _buildTextField(
            controller: _checkedTextController,
            hintText: "Checked grammar result...",
            hasText: ValueNotifier<bool>(true),
            onCopy: () => _copyToClipboard(_checkedTextController),
            readOnly: true,
          ),
        ],
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: SizedBox(
                height: 44,
                child: ElevatedButton.icon(
                  onPressed: _isChecking ? null : _checkGrammar,
                  label: Text(
                    _isChecking ? "Checking..." : "Check Grammar",
                    style: GoogleFonts.lato(
                        color:
                            Theme.of(context).textTheme.displayMedium?.color),
                  ),
                  icon: Icon(_isChecking
                      ? Icons.hourglass_empty_rounded
                      : CustomIcon.checker),
                  iconAlignment: IconAlignment.end,
                  style: Theme.of(context).filledButtonTheme.style,
                ),
              ),
            ),
          ],
        ),
      ],
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

