import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../custom_class/custom_icon_icons.dart';

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
          gap: 4,
          backgroundColor: Colors.transparent,
          activeColor: Color(0xFF274688),
          tabBackgroundColor: Color(0xFFD1DBF2),
          color: Color(0xFF171F22),
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          tabs: const[
          GButton(icon: CustomIcon.chat, text: 'Chat'),
          GButton(icon: CustomIcon.image, text: 'Image'),
          GButton(icon: CustomIcon.imagetotext, text: 'Image to Text'),
          GButton(icon: CustomIcon.logogenerator, text: 'Logo'),
          GButton(icon: CustomIcon.illustration, text: 'Illuatration'),
          ],
        ),),
      )
    );
  }
}
