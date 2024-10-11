import 'package:flutter/material.dart';
import 'package:pak_asisten/custom_class/color.dart';

class ImagePage extends StatefulWidget {
  const ImagePage({super.key});

  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSelect.lightBackground,
    );
  }
}