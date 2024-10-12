import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:pak_asisten/custom_class/theme_provider.dart';
import 'package:pak_asisten/page/chat_page.dart';
import 'package:pak_asisten/page/illustration_page.dart';
import 'package:pak_asisten/page/image_page.dart';
import 'package:pak_asisten/page/logo_page.dart';
import 'package:pak_asisten/page/scan_page.dart';
import 'package:pak_asisten/theme/dark_theme.dart';
import 'package:pak_asisten/theme/light_theme.dart';
import 'package:provider/provider.dart';
import '../custom_class/custom_icon_icons.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const PakAsisten(),
    ),
  );
}

class PakAsisten extends StatelessWidget {
  const PakAsisten({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode:
            themeProvider.themeMode, // Menggunakan tema dari ThemeProvider
        theme: lightTheme,
        darkTheme: darkTheme,
        home: AnimatedSplashScreen(
          //Splash Screen
          splash: 'assets/logo/LogoSplashScreen.gif',
          splashIconSize: 300,
          nextScreen: const NavBar(),
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark; // Cek mode tema
    return Scaffold(
        appBar: AppBar(
          // App Bar
          elevation: 0,
          shape: Border(
            bottom: BorderSide(color: Theme.of(context).colorScheme.outline),
          ),
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          title: Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 10),
            child:
                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              SvgPicture.asset(
                'assets/logo/LightLogoAppBar.svg',
                width: 150,
                color: isDarkMode ? Colors.white : null,
              ),
              Spacer(),
              FlutterSwitch(
                // Switch Button Dark Mode
                width: 50,
                height: 30,
                toggleSize: 28,
                value: themeProvider.themeMode == ThemeMode.dark,
                borderRadius: 30,
                padding: 2,
                activeToggleColor: Color(0xFF274688),
                inactiveToggleColor: Color(0xFF14274F),
                activeSwitchBorder: Border.all(
                  color: Color(0xFF274688),
                  width: 2,
                ),
                inactiveSwitchBorder: Border.all(
                  color: Color(0xFF14274F),
                  width: 2,
                ),
                activeColor: Color(0xFF14274F),
                inactiveColor: Color(0xFFF4F8FF),
                activeIcon: Icon(
                  Icons.nightlight_round,
                  color: Colors.amber,
                ),
                inactiveIcon: Icon(
                  Icons.wb_sunny,
                  color: Colors.amber,
                ),
                onToggle: (value) {
                  themeProvider
                      .toggleTheme(); // Memanggil fungsi untuk mengubah tema
                },
              )
            ]),
          ),
        ),
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            border: Border(
              top: BorderSide(
                  color: Theme.of(context).colorScheme.outline, width: 1,),
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
                activeColor: Theme.of(context)
                    .bottomNavigationBarTheme
                    .selectedIconTheme
                    ?.color,
                tabBackgroundColor: Theme.of(context)
                    .bottomNavigationBarTheme
                    .selectedItemColor!,
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
