import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});
  Widget svg(String assetPath) {
    return SvgPicture.asset(assetPath);
  }

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Color(0xFFEAEAEA), width: 1),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: GNav(
          gap: 8,
          backgroundColor: Colors.transparent,
          activeColor: Color(0xFF274688),
          tabBackgroundColor: Color(0xFFD1DBF2),
          color: Color(0xFF171F22),
          tabs: const[
          GButton(icon: Icons.chat, text: 'Chat'),
          GButton(icon: Icons.image, text: 'Image'),
          GButton(icon: Icons.text_fields, text: 'Text'),
          GButton(icon: Icons.image_outlined, text: 'Logo'),
        ]),),
      )
    );
  }
}
