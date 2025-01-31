import 'package:flutter/material.dart';
import 'package:weather_app/responsive/desktop_screen.dart';
import 'package:weather_app/responsive/mobile_screen.dart';
import 'package:weather_app/responsive/responsive_layout.dart';
import 'package:weather_app/responsive/tablet_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.isDarkMode,
    required this.onThemeToogle,
  });

  final bool isDarkMode;
  final VoidCallback onThemeToogle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileScreenLayout: MobileScreen(
          isDarkMode: isDarkMode,
          onThemeToogle: onThemeToogle,
        ),
        tabletScreenLayout: TabletScreen(
          isDarkMode: isDarkMode,
          onThemeToogle: onThemeToogle,
        ),
        desktopScreenLayout: DesktopScreen(
          isDarkMode: isDarkMode,
          onThemeToogle: onThemeToogle,
        ),
      ),
    );
  }
}
