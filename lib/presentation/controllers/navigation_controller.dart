import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pak_asisten/presentation/pages/chat_page.dart';
import 'package:pak_asisten/presentation/pages/image_page.dart';
import 'package:pak_asisten/presentation/pages/quiz_page.dart';
import 'package:pak_asisten/presentation/pages/reword_page.dart';
import 'package:pak_asisten/presentation/pages/scan_page.dart';

class NavigationController with ChangeNotifier {
  int _selectedIndex = 0;
  late PageController pageController;

  int get selectedIndex => _selectedIndex;

  List<Widget> get widgetOptions => [
        ChatPage(),
        ImagePage(),
        ScanPage(),
        QuizPage(),
        RewordPage(),
      ];

  NavigationController() {
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void changeIndex(int index) {
    // Validasi index
    if (index >= 0 && index < widgetOptions.length) {
      _selectedIndex = index;
      pageController.jumpToPage(index);
      notifyListeners();
    } else {
      // Handle index yang tidak valid, misal:
      if (kDebugMode) {
        print('Error: Invalid index for navigation');
      }
      // Atau tampilkan pesan error ke pengguna
    }
  }
}