import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const String baseImageUrl = 'https://image.tmdb.org/t/p/w500';

const Color richBlack = Color(0xFF000814);
const Color prussianBlue = Color(0xFF003566);
const Color mikadoYellow = Color(0xFFffc300);
const Color davysGrey = Color(0xFF4B5358);

final TextStyle heading5 = GoogleFonts.poppins(
  fontSize: 23,
  fontWeight: FontWeight.w400,
);
final TextStyle heading6 = GoogleFonts.poppins(
  fontSize: 19,
  fontWeight: FontWeight.w500,
  letterSpacing: 0.15,
);
final TextStyle subtitle = GoogleFonts.poppins(
  fontSize: 15,
  fontWeight: FontWeight.w400,
  letterSpacing: 0.15,
);
final TextStyle bodyText = GoogleFonts.poppins(
  fontSize: 13,
  fontWeight: FontWeight.w400,
  letterSpacing: 0.25,
);

final textTheme = TextTheme(
  headlineMedium: heading5,
  headlineSmall: heading6,
  labelMedium: subtitle,
  bodyMedium: bodyText,
);

final drawerTheme = DrawerThemeData(backgroundColor: Colors.grey.shade700);

const colorScheme = ColorScheme(
  primary: mikadoYellow,
  secondary: prussianBlue,
  secondaryContainer: prussianBlue,
  surface: richBlack,
  error: Colors.red,
  onPrimary: richBlack,
  onSecondary: Colors.white,
  onSurface: Colors.white,
  onError: Colors.white,
  brightness: Brightness.dark,
);
