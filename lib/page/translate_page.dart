import 'package:flutter/material.dart';

class IllustrationPage extends StatefulWidget {
  const IllustrationPage({super.key});

  @override
  State<IllustrationPage> createState() => _IllustrationPageState();
}

class _IllustrationPageState extends State<IllustrationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        padding: EdgeInsets.all(16),
        alignment: Alignment.center,
        child: Text(
          'Ini halaman Illustration Generator',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context)
                .bottomNavigationBarTheme
                .unselectedIconTheme
                ?.color,
          ),
        ),
      ),
    );
  }
}