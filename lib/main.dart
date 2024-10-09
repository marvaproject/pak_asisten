import 'package:flutter/material.dart';
import 'package:pak_asisten/chat_page.dart';

void main() {
  runApp(const PakAsisten());
}

class PakAsisten extends StatelessWidget {
  const PakAsisten({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChatPage(),
    );
  }
}
