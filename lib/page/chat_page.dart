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
  TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration:
          BoxDecoration(color: Theme.of(context).colorScheme.background),
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
          return Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(right: 24),
                child: Text(
                  message.text,
                  style: TextStyle(
                    color: message.user.id == currentUser.id
                        ? Theme.of(context).textTheme.bodySmall?.color
                        : Theme.of(context).textTheme.bodyMedium?.color ??
                            Colors.white,
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
        scrollToBottomBuilder: (scrollController) => IconButton(
          icon: Icon(
            Icons.arrow_downward_rounded,
            color: Theme.of(context).primaryIconTheme.color,
            size: 15,
          ),
          onPressed: () {
            scrollController.animateTo(
              0,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          },
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.greenAccent),
              shadowColor: MaterialStateProperty.all(Colors.black),
              fixedSize: MaterialStateProperty.all(
                Size(15, 15),
              ),
              alignment: Alignment.bottomCenter),
          visualDensity: VisualDensity.standard,
          alignment: Alignment.center,
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
            borderSide: Theme.of(context).inputDecorationTheme.border!.borderSide,
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
    });

    try {
      String question = chatMessage.text;
      List<Uint8List>? images;
      if (chatMessage.medias?.isNotEmpty ?? false) {
        images = [
          File(chatMessage.medias!.first.url).readAsBytesSync(),
        ];
      }
      gemini.streamGenerateContent(question, images: images).listen(
        (event) {
          ChatMessage? lastMessage = messages.firstOrNull;
          if (lastMessage != null && lastMessage.user == geminiUser) {
            lastMessage = messages.removeAt(0);
            String response = event.content?.parts?.fold(
                    "", (previous, current) => "$previous ${current.text}") ??
                "";
            lastMessage.text += response;
            setState(() {
              messages = [lastMessage!, ...messages];
            });
          } else {
            String response = event.content?.parts?.fold(
                    "", (previous, current) => "$previous ${current.text}") ??
                "";
            ChatMessage message = ChatMessage(
              user: geminiUser,
              createdAt: DateTime.now(),
              text: response,
            );
            setState(() {
              messages = [...messages, message];
            });
          }
        },
      );
    } catch (e) {
      print(e);
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
                contentPadding: EdgeInsets.only(bottom: 15, left: 15, right: 15),
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
