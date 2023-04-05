import 'package:flutter/cupertino.dart';

class Theme {
  const Theme();

  // static const Color gradientStart = Color(0xFF1A2980);
  // static const Color gradientEnd = Color(0xFF26D0CE);

  static const Color gradientStart = Color(0xFF0052D4);
  static const Color gradientEnd = Color(0xFF1488CC);

  static const gradient = LinearGradient(
    colors: [gradientStart, gradientEnd],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.0, 1.0],
  );
}
