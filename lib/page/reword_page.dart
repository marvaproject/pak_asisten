import 'package:flutter/material.dart';

class RewordPage extends StatefulWidget {
  const RewordPage({super.key});

  @override
  State<RewordPage> createState() => _RewordPageState();
}

class _RewordPageState extends State<RewordPage> {
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