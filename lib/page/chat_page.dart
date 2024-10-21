import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:pak_asisten/custom_class/custom_icon_icons.dart';
import 'package:image_picker/image_picker.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final Gemini gemini = Gemini.instance;

  List<ChatMessage> messages = [];
  final maxMessages = 50;

  ChatUser currentUser = ChatUser(id: "0", firstName: "User");
  ChatUser geminiUser =
      ChatUser(id: "1", firstName: "Gemini", profileImage: null);

  XFile? _attachedImage;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration:
          BoxDecoration(color: Theme.of(context).colorScheme.surface),
      child: _buildUI(),
    );
  }

  Widget _buildUI() {
    return DashChat(
      currentUser: currentUser,
      onSend: _sendMessage,
      messages: messages.reversed.toList(),
      messageOptions: MessageOptions(
        borderRadius: 20,
        showCurrentUserAvatar: false,
        showOtherUsersAvatar: false,
        showOtherUsersName: true,
        currentUserContainerColor:
            Theme.of(context).dialogTheme.backgroundColor,
        containerColor: Theme.of(context).dialogBackgroundColor,
        currentUserTextColor: Theme.of(context).textTheme.bodySmall?.color,
        textColor:
            Theme.of(context).textTheme.bodyMedium?.color ?? Colors.white,
        messageTextBuilder: (message, previousMessage, nextMessage) {
          if (message.customProperties?['isLoading'] == true) {
            return Center(child: CircularProgressIndicator());
          }

          String parsedText = parseMarkdown(message.text);

          return Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(right: 24),
                child: RichText(
                  text: TextSpan(
                    children: _buildTextSpans(parsedText),
                    style: TextStyle(
                      color: message.user.id == currentUser.id
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
                  icon: Icon(
                    Icons.more_vert,
                    size: 16,
                    color: Color(0xFFD1DBF2),
                  ),
                  onPressed: () => _showCopyOption(message.text),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                ),
              ),
            ],
          );
        },
      ),
      scrollToBottomOptions: ScrollToBottomOptions(
        disabled: false,
        scrollToBottomBuilder: (scrollController) => Positioned(
          bottom: 15,
          left: 0,
          right: 0,
          child: Center(
            child: SizedBox(
              height: 25,
              width: 25,
              child: FloatingActionButton(
                mini: true,
                shape: CircleBorder(
                  side: BorderSide(
                      color: Color(0xFF274688),
                      width: 1,
                      style: BorderStyle.solid),
                ),
                backgroundColor: Colors.white,
                onPressed: () {
                  scrollController.animateTo(
                    0,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                },
                elevation: 5,
                child: Icon(
                  Icons.arrow_downward,
                  color: Color(0xFF274688),
                  size: 16,
                ),
              ),
            ),
          ),
        ),
      ),
      inputOptions: InputOptions(
        alwaysShowSend: true,
        inputMaxLines: 5,
        inputToolbarPadding: EdgeInsets.only(bottom: 15),
        inputToolbarMargin: EdgeInsets.only(top: 15),
        sendButtonBuilder: (onSend) {
          return IconButton(
            icon: Icon(CustomIcon.send),
            onPressed: onSend,
            color: Theme.of(context)
                .bottomNavigationBarTheme
                .unselectedIconTheme
                ?.color,
            visualDensity: VisualDensity.standard,
          );
        },
        trailing: [
          GestureDetector(
            onTap: _attachImage,
            child: _buildImagePreview(),
          ),
        ],
        inputDecoration: InputDecoration(
          hintText: "Chat with Gemini...",
          hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          border: OutlineInputBorder(
            borderSide:
                Theme.of(context).inputDecorationTheme.border!.borderSide,
            borderRadius: BorderRadius.all(
              Radius.circular(30),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    if (_attachedImage != null) {
      return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: FileImage(File(_attachedImage!.path)),
            fit: BoxFit.cover,
          ),
        ),
      );
    } else {
      return Icon(
        CustomIcon.addimage,
        color: Theme.of(context)
            .bottomNavigationBarTheme
            .unselectedIconTheme
            ?.color,
      );
    }
  }

  void _sendMessage(ChatMessage chatMessage) {
    if (_attachedImage != null) {
      chatMessage.medias = [
        ChatMedia(
            url: _attachedImage!.path, fileName: "", type: MediaType.image),
      ];
    }

    setState(() {
      messages.add(chatMessage);
      if (messages.length > maxMessages) {
        messages.removeAt(0);
      }
      _attachedImage = null;
      _textController.clear();

      messages.add(ChatMessage(
        user: geminiUser,
        createdAt: DateTime.now(),
        text: "",
        customProperties: {
          'isLoading': true,
        },
      ));
    });

    try {
      String question = chatMessage.text;
      List<Uint8List>? images;
      if (chatMessage.medias?.isNotEmpty ?? false) {
        images = [
          File(chatMessage.medias!.first.url).readAsBytesSync(),
        ];
      }

      String fullResponse = "";
      gemini.streamGenerateContent(question, images: images).listen(
        (event) {
          String response = event.content?.parts?.fold(
                  "", (previous, current) => "$previous ${current.text}") ??
              "";
          fullResponse += response;

          setState(() {
            messages.last = ChatMessage(
              user: geminiUser,
              createdAt: DateTime.now(),
              text: fullResponse,
              customProperties: {
                'isLoading': false,
              },
            );
          });
        },
        onError: (error) {
          // Handle error
          setState(() {
            messages.last = ChatMessage(
              user: geminiUser,
              createdAt: DateTime.now(),
              text: "Sorry, an error occurred.",
              customProperties: {
                'isLoading': false,
              },
            );
          });
        },
      );
    } catch (e) {
      // Handle error
      setState(() {
        messages.last = ChatMessage(
          user: geminiUser,
          createdAt: DateTime.now(),
          text: "Sorry, an error occurred.",
          customProperties: {
            'isLoading': false,
          },
        );
      });
    }
  }

  void _attachImage() async {
    ImagePicker picker = ImagePicker();
    XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() {
        _attachedImage = file;
        _textController.clear();
      });
    }
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
                text: content, style: TextStyle(fontWeight: FontWeight.bold)));
            break;
          case 'i':
          case 'em':
            spans.add(TextSpan(
                text: content, style: TextStyle(fontStyle: FontStyle.italic)));
            break;
          case 's':
          case 'strike':
            spans.add(TextSpan(
                text: content,
                style: TextStyle(decoration: TextDecoration.lineThrough)));
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

// Copy to Clipboard
  void _showCopyOption(String text) {
    showModalBottomSheet(
      context: context,
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
                      duration: Duration(milliseconds: 700),
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
