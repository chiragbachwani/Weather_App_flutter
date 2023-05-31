import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'const/colors.dart';

class CustomThemes {
  static final lighttheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Vx.gray800,
    cardColor: Vx.gray100,
    iconTheme: const IconThemeData(
      color: Vx.gray600,
    ),
  );

  static final darktheme = ThemeData(
    scaffoldBackgroundColor: bgColor,
    cardColor: Vx.gray600,
    primaryColor: Vx.white,
    iconTheme: const IconThemeData(
      color: Vx.white,
    ),
  );
}
