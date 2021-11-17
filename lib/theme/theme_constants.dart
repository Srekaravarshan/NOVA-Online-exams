import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  appBarTheme: AppBarTheme(
      centerTitle: true,
      titleTextStyle: GoogleFonts.lato(fontSize: 22),
      elevation: 0),
  scaffoldBackgroundColor: Colors.white,
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
          elevation: MaterialStateProperty.all<double>(1.0),
          backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
          textStyle: MaterialStateProperty.all<TextStyle>(
              const TextStyle(color: Colors.white)))),
  textTheme: GoogleFonts.karlaTextTheme(),
);
