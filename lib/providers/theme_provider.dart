import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  static const Color _primary = Color(0xFF2e3440);
  static final MaterialColor _primaryTheme = MaterialColor(_primary.value, {
    50: _primary.withOpacity(0.1),
    100: _primary.withOpacity(0.2),
    200: _primary.withOpacity(0.3),
    300: _primary.withOpacity(0.4),
    400: _primary.withOpacity(0.5),
    500: _primary,
    600: _primary.withOpacity(0.7),
    700: _primary.withOpacity(0.8),
    800: _primary.withOpacity(0.9),
    900: _primary.withOpacity(0.95),
  });

  final _theme = ThemeData(
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: _primaryTheme,
    ),
    scaffoldBackgroundColor: _primary,
    appBarTheme: const AppBarTheme(
        backgroundColor: _primary, foregroundColor: Colors.white), 
  cardColor: Colors.white);

  ThemeData get theme => _theme;
}
