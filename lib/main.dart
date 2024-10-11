import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:pak_asisten/custom_class/color.dart';
import 'package:pak_asisten/page/chat_page.dart';
import 'package:pak_asisten/page/illustration_page.dart';
import 'package:pak_asisten/page/image_page.dart';
import 'package:pak_asisten/page/logo_page.dart';
import 'package:pak_asisten/page/scan_page.dart';
import '../custom_class/custom_icon_icons.dart';

void main() {
  runApp(const PakAsisten());
}

class PakAsisten extends StatelessWidget {
  const PakAsisten({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: AnimatedSplashScreen(
      //Splash Screen
      splash: 'assets/logo/LogoSplashScreen.gif',
      splashIconSize: 300,
      nextScreen: NavBar(),
      duration: 2800,
      splashTransition: SplashTransition.fadeTransition,
      backgroundColor: Color.fromARGB(255, 13, 28, 58),
    ));
  }
}

class NavBar extends StatefulWidget {
  //NavBar
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    ChatPage(),
    ImagePage(),
    ScanPage(),
    LogoPage(),
    IllustrationPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.00,
          shape: Border(bottom: BorderSide(color: ColorSelect.borderTab)),
          backgroundColor: ColorSelect.lightBackground,
          title: Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 10),
            child: Column(children: [
              Image(
                width: 200,
                image: Svg('assets/logo/LightLogoAppBar.svg'),
              ),
            ]),
          ),
        ),
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: ColorSelect.lightBackground,
            border: Border(
              top: BorderSide(color: ColorSelect.borderTab, width: 1),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 15, bottom: 20, right: 20, left: 20),
              child: GNav(
                gap: 8,
                hoverColor: Colors.transparent,
                backgroundColor: Colors.transparent,
                activeColor: ColorSelect.lightActiveIcon,
                tabBackgroundColor: ColorSelect.lightBackgroundIcon,
                color: ColorSelect.lightIcon,
                iconSize: 22,
                textStyle: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: ColorSelect.lightActiveIcon,
                ),
                tabMargin: EdgeInsets.all(0),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                tabs: const [
                  GButton(icon: CustomIcon.chat, text: 'Chat'),
                  GButton(icon: CustomIcon.image, text: 'Image'),
                  GButton(icon: CustomIcon.imagetotext, text: 'Scan'),
                  GButton(icon: CustomIcon.logogenerator, text: 'Logo'),
                  GButton(icon: CustomIcon.illustration, text: 'Illustration'),
                ],
                selectedIndex: _selectedIndex,
                onTabChange: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
              ),
            ),
          ),
        ));
  }
}
