import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
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
        debugShowCheckedModeBanner: false,
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
  bool status = false;

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
          //App Bar
          elevation: 0,
          shape: Border(bottom: BorderSide(color: ColorSelect.borderTab)),
          backgroundColor: ColorSelect.lightBackground,
          title: Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 10),
            child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              SvgPicture.asset('assets/logo/LightLogoAppBar.svg', width: 150,),
              Spacer(),
              FlutterSwitch(
                  //Switch Dark Mode
                  width: 50,
                  height: 30,
                  toggleSize: 28,
                  value: status,
                  borderRadius: 30,
                  padding: 2,
                  activeToggleColor: ColorSelect.lightActiveIcon,
                  inactiveToggleColor: ColorSelect.darkBackground,
                  activeSwitchBorder: Border.all(
                    color: ColorSelect.lightActiveIcon,
                    width: 2,
                  ),
                  inactiveSwitchBorder: Border.all(
                    color: ColorSelect.darkBackground,
                    width: 2,
                  ),
                  activeColor: ColorSelect.darkBackground,
                  inactiveColor: ColorSelect.lightBackground,
                  activeIcon: Icon(
                    Icons.nightlight_round,
                    color: Colors.amber,
                  ),
                  inactiveIcon: Icon(
                    Icons.wb_sunny,
                    color: Colors.amber,
                  ),
                  onToggle: (val) {
                    setState(() {
                      status = val;
                    });
                  })
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
                  top: 15, bottom: 30, right: 20, left: 20),
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
                  GButton(icon: CustomIcon.scan, text: 'Scan'),
                  GButton(icon: CustomIcon.logo, text: 'Logo'),
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
