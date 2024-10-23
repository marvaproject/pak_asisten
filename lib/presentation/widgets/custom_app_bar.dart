import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:pak_asisten/core/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:pak_asisten/core/services/custom_icon_icons.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 10.0);

  @override
  Widget build(BuildContext context) {
    // Cache theme values
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      // App Bar
      elevation: 0,
      shape: Border(
        bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline, width: 0.5),
      ),
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      title: Container(
        width: double.infinity,
        padding: EdgeInsets.only(top: 10),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SvgPicture.asset(
                'assets/logo/LightLogoAppBar.svg',
                width: 150,
                // ignore: deprecated_member_use
                color: isDarkMode ? Colors.white : null,
              ),
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
                  CustomIcon.moon,
                  color: Colors.amber,
                ),
                inactiveIcon: Icon(
                  CustomIcon.sun,
                  color: Colors.amber,
                ),
                onToggle: (value) {
                  try {
                    themeProvider.toggleTheme();
                  } catch (e) {
                    if (kDebugMode) {
                      print('Error toggling theme: $e');
                    }
                  }
                },
              )
            ]),
      ),
    );
  }
}