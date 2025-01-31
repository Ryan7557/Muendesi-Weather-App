import 'package:flutter/material.dart';
import 'package:weather_app/constants/constants.dart';

class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    super.key,
    required this.mobileScreenLayout,
    required this.tabletScreenLayout,
    required this.desktopScreenLayout,
  });

  final Widget mobileScreenLayout;
  final Widget tabletScreenLayout;
  final Widget desktopScreenLayout;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < Breakpoints.mobile) {
          return mobileScreenLayout;
        } else if (constraints.maxWidth < Breakpoints.tablet) {
          return tabletScreenLayout;
        } else {
          return desktopScreenLayout;
        }
      },
    );
  }
}
