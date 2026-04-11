import 'package:flutter/widgets.dart';

class Responsive {
  Responsive._();

  static bool isMobile(BuildContext context) {
    return MediaQuery.sizeOf(context).width < 600;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= 600 && width <= 1024;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.sizeOf(context).width > 1024;
  }

  static double contentMaxWidth(BuildContext context) {
    if (isDesktop(context)) {
      return 1200;
    }
    return MediaQuery.sizeOf(context).width;
  }

  static int gridColumns(BuildContext context) {
    if (isDesktop(context)) return 4;
    if (isTablet(context)) return 3;
    return 2;
  }
}
