// ignore_for_file: library_private_types_in_public_api

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:pak_asisten/core/theme/dark_theme.dart';
import 'package:pak_asisten/core/theme/light_theme.dart';
import 'package:pak_asisten/core/theme/theme_provider.dart';
import 'package:pak_asisten/presentation/controllers/navigation_controller.dart';
import 'package:pak_asisten/presentation/pages/quiz_page.dart';
import 'package:pak_asisten/presentation/widgets/custom_app_bar.dart';
import 'package:pak_asisten/presentation/widgets/custom_bottom_navbar.dart';
import 'package:pak_asisten/presentation/widgets/quiz_screen_widget.dart';
import 'package:provider/provider.dart';

class PakAsisten extends StatelessWidget {
  const PakAsisten({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NavigationController()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: themeProvider.themeMode,
        theme: lightTheme,
        darkTheme: darkTheme,
        home: QuizScreenWidget(),
        // home: AnimatedSplashScreen(
        //   splash: 'assets/logo/LogoSplashScreen.gif',
        //   splashIconSize: 300,
        //   nextScreen: const NavBar(),
        //   duration: 2800,
        //   splashTransition: SplashTransition.fadeTransition,
        //   backgroundColor: const Color.fromARGB(255, 13, 28, 58),
        // ),
      ),
    );
  }
}

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  late NavigationController navigationController;

  @override
  void initState() {
    super.initState();
    navigationController =
        Provider.of<NavigationController>(context, listen: false);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: PageView(
        controller: navigationController.pageController,
        onPageChanged: (index) {
          navigationController.changeIndex(index);
        },
        children: navigationController.widgetOptions,
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: navigationController.selectedIndex,
        onTabChange: (index) {
          navigationController.pageController.jumpToPage(index);
          navigationController.changeIndex(index);
        },
      ),
    );
  }
}
