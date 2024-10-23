import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:pak_asisten/presentation/controllers/navigation_controller.dart';
import 'package:pak_asisten/presentation/widgets/custom_icon_icons.dart';
import 'package:provider/provider.dart';

class CustomBottomNavBar extends StatefulWidget { // Ubah menjadi StatefulWidget
  final int selectedIndex;
  final Function(int) onTabChange;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTabChange,
  });

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    final navigationController = Provider.of<NavigationController>(context); // Akses di sini

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outline,
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
              top: 15, bottom: 25, right: 20, left: 20),
          child: GNav(
            gap: 8,
            hoverColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            activeColor: Theme.of(context)
                .bottomNavigationBarTheme
                .selectedIconTheme
                ?.color,
            tabBackgroundColor:
                Theme.of(context).bottomNavigationBarTheme.selectedItemColor!,
             color: Theme.of(context)
                .bottomNavigationBarTheme
                .unselectedIconTheme
                ?.color,
            iconSize: 22,
            textStyle: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Theme.of(context)
                  .bottomNavigationBarTheme
                  .selectedLabelStyle
                  ?.color,
            ),
            tabMargin: EdgeInsets.all(0),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            tabs: const [
              GButton(icon: CustomIcon.chat, text: 'Chat'),
              GButton(icon: CustomIcon.image, text: 'Image'),
              GButton(icon: CustomIcon.scan, text: 'Scan Text'),
              GButton(icon: CustomIcon.quiz, text: 'Quiz'),
              GButton(icon: CustomIcon.transcript, text: 'Reword'),
            ],
            selectedIndex: navigationController.selectedIndex,
            onTabChange: widget.onTabChange,
          ),
        ),
      ),
    );
  }
}