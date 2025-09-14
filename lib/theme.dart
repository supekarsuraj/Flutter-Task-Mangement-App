import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  primarySwatch: Colors.blue,
  brightness: Brightness.light,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.blue,
    foregroundColor: Colors.white,
  ),
  cardColor: Colors.white,
  primaryColor: Colors.blue,
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.black87),
  ),
);

final ThemeData darkTheme = ThemeData(
  primarySwatch: Colors.blue,
  brightness: Brightness.dark,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.blueGrey,
    foregroundColor: Colors.white,
  ),
  scaffoldBackgroundColor: Colors.grey[900],
  listTileTheme: const ListTileThemeData(
    textColor: Colors.white,
  ),
  cardColor: Colors.grey[800],
  primaryColor: Colors.blueGrey,
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white70),
  ),
);