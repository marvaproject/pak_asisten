import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pak_asisten/core/services/custom_icon_icons.dart';

class TranslateWidget extends StatefulWidget {
  const TranslateWidget({super.key});

  @override
  State<TranslateWidget> createState() => _TranslateWidgetState();
}

class _TranslateWidgetState extends State<TranslateWidget> {
  final ValueNotifier<bool> _hasText = ValueNotifier<bool>(false);
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.swap_horiz_rounded,
                color: Theme.of(context).primaryIconTheme.color,
                size: 30,
              ),
            )
          ],
        ),
        SizedBox(height: 20),
        TextField(
          maxLines: 3,
          decoration: InputDecoration(
            hintText: "Enter text to translate...",
            hintStyle: GoogleFonts.lato(color: Colors.grey, fontSize: 14,),
            contentPadding: EdgeInsets.all(20),
            filled: true,
            fillColor: Theme.of(context).colorScheme.inverseSurface,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.outline,
                    width: 1,
                    style: BorderStyle.solid)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(25)),
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.outline,
                  width: 1,
                  style: BorderStyle.solid),
            ),
          ),
        ),
        SizedBox(height: 15),
        TextField(
          controller: _textController,
          maxLines: 3,
          onChanged: (text) {
            _hasText.value = text.isNotEmpty;
          },
          decoration: InputDecoration(
            hintText: "Translation result...",
            hintStyle: GoogleFonts.lato(color: const Color.fromARGB(255, 70, 63, 63), fontSize: 14),
            contentPadding: EdgeInsets.all(20),
            filled: true,
            fillColor: Theme.of(context).colorScheme.inverseSurface,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.outline,
                    width: 1,
                    style: BorderStyle.solid)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(25)),
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.outline,
                  width: 1,
                  style: BorderStyle.solid),
            ),
            suffixIcon: ValueListenableBuilder<bool>(
              valueListenable: _hasText,
              builder: (context, hasText, child) {
                return hasText
                    ? IconButton(
                        icon: Icon(
                          CustomIcon.clipboard,
                          size: 20,
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                        onPressed: _copyToClipboard,
                      )
                    : SizedBox.shrink();
              },
            ),
          ),
        ),
      ],
    );
  }

  void _copyToClipboard() {
    if (_textController.text.isEmpty) return;

    Clipboard.setData(ClipboardData(text: _textController.text));
    _showSuccessSnackBar('Copied to clipboard');
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
}
