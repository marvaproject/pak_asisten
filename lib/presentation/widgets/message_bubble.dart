import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pak_asisten/core/services/custom_icon_icons.dart';
// Sesuaikan import

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final String currentUserId;

  const MessageBubble(
      {super.key, required this.message, required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    String parsedText = parseMarkdown(message.text);
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 20, left: 6),
          child: RichText(
            text: TextSpan(
              children: _buildTextSpans(parsedText),
              style: GoogleFonts.lato(
                color: message.user.id == currentUserId
                    ? Theme.of(context).textTheme.bodySmall?.color
                    : Theme.of(context).textTheme.bodyMedium?.color ??
                        Colors.white,
              ),
            ),
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: IconButton(
            icon: const Icon(
              Icons.more_vert,
              size: 16,
              color: Color(0xFFD1DBF2),
            ),
            onPressed: () => _showCopyOption(message.text, context),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ),
      ],
    );
  }

  String parseMarkdown(String text) {
    // Bold
    text = text.replaceAllMapped(RegExp(r'\*\*(.*?)\*\*'), (match) {
      return '<b>${match.group(1)}</b>';
    });

    // Italic
    text = text.replaceAllMapped(RegExp(r'\*(.*?)\*'), (match) {
      return '<i>${match.group(1)}</i>';
    });

    // Strikethrough
    text = text.replaceAllMapped(RegExp(r'~~(.*?)~~'), (match) {
      return '<s>${match.group(1)}</s>';
    });

    // List items
    text = text.replaceAllMapped(
        RegExp(r'^[ \t]*\*[ \t](.+)$', multiLine: true), (match) {
      return '<li>${match.group(1)}</li>';
    });

    return text;
  }

  List<TextSpan> _buildTextSpans(String text) {
    List<TextSpan> spans = [];
    RegExp exp = RegExp(
        r'<(\w+)(?:\s+[^>]*)?>(((?!<\1[^>]*>).)*?)</\1>|([^<]+)',
        dotAll: true);

    exp.allMatches(text).forEach((match) {
      if (match.group(4) != null) {
        // Plain text
        spans.add(TextSpan(text: match.group(4)));
      } else {
        // Formatted text
        String tag = match.group(1)!;
        String content = match.group(2)!;

        switch (tag.toLowerCase()) {
          case 'b':
          case 'strong':
            spans.add(TextSpan(
                text: content,
                style: const TextStyle(fontWeight: FontWeight.bold)));
            break;
          case 'i':
          case 'em':
            spans.add(TextSpan(
                text: content,
                style: const TextStyle(fontStyle: FontStyle.italic)));
            break;
          case 's':
          case 'strike':
            spans.add(TextSpan(
                text: content,
                style:
                    const TextStyle(decoration: TextDecoration.lineThrough)));
            break;
          case 'li':
            spans.add(TextSpan(text: "• $content\n"));
            break;
          default:
            spans.add(TextSpan(text: content));
        }
      }
    });

    return spans;
  }

  void _showCopyOption(String text, BuildContext contexts) {
    showModalBottomSheet(
      context: contexts,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                horizontalTitleGap: 8,
                leading: Icon(
                  CustomIcon.clipboard,
                  size: 20,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
                title: Text(
                  'Copy to Clipboard',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
                tileColor: Theme.of(context).dialogBackgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                contentPadding:
                    EdgeInsets.only(bottom: 15, left: 15, right: 15),
                onTap: () {
                  Clipboard.setData(ClipboardData(text: text));
                  Navigator.pop(context);
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
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
