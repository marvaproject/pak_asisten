import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pak_asisten/core/utils/error_handler.dart';
import 'package:pak_asisten/core/services/custom_icon_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pak_asisten/presentation/widgets/message_bubble.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

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
    ErrorHandler.handleFutureError(loadMessages);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface),
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
            return const Center(child: CircularProgressIndicator());
          }

          return MessageBubble(
            message: message,
            currentUserId: currentUser.id,
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
                  side: const BorderSide(
                      color: Color(0xFF274688),
                      width: 1,
                      style: BorderStyle.solid),
                ),
                backgroundColor: Colors.white,
                onPressed: () {
                  scrollController.animateTo(
                    0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                },
                elevation: 5,
                child: const Icon(
                  Icons.arrow_downward_rounded,
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
        inputToolbarPadding: const EdgeInsets.only(bottom: 15),
        inputToolbarMargin: const EdgeInsets.only(top: 15),
        inputTextStyle: GoogleFonts.lato(),
        sendButtonBuilder: (onSend) {
          return IconButton(
            icon: const Icon(CustomIcon.send),
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
          hintStyle: GoogleFonts.lato(color: Colors.grey, fontSize: 14),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
          borderRadius: BorderRadius.circular(20),
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
          String response =
              event.content?.parts?.map((part) => part.text).join() ?? "";

          if (fullResponse.isEmpty) {
            fullResponse = response;
          } else {
            fullResponse += response;
          }

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

  Future<void> saveMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final messagesToSave = messages
        .map((msg) => {
              'text': msg.text,
              'createdAt': msg.createdAt.toIso8601String(),
              'userId': msg.user.id,
              // Tambahkan properti lain yang perlu disimpan
            })
        .toList();
    await prefs.setString('chat_messages', jsonEncode(messagesToSave));
  }

  Future<void> loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedMessages = prefs.getString('chat_messages');
    if (savedMessages != null) {
      final List<dynamic> decodedMessages = jsonDecode(savedMessages);
      final now = DateTime.now();
      setState(() {
        messages = decodedMessages
            .map((msgMap) {
              final messageDate = DateTime.parse(msgMap['createdAt']);
              // Hanya tampilkan pesan yang kurang dari 24 jam
              if (now.difference(messageDate) < Duration(hours: 24)) {
                return ChatMessage(
                  text: msgMap['text'],
                  createdAt: messageDate,
                  user: msgMap['userId'] == currentUser.id
                      ? currentUser
                      : geminiUser,
                  // Sesuaikan dengan properti lain yang Anda simpan
                );
              } else {
                // Lewati pesan yang sudah lebih dari 24 jam
                return null;
              }
            })
            .whereType<ChatMessage>() // Hapus pesan null
            .toList();
      });
    }
  }
}
