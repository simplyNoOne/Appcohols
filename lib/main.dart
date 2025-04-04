import 'package:appcohols/ui/views/drinks_list_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Appcohols',
      theme: ThemeData(
        colorScheme: ColorScheme(
            brightness: Brightness.light,
            surface: Color(0xFFF1DC92),
            onSurface: Color(0xFF1B1B1B),
            secondary: Color(0x33000000),
            onSecondary: Color(0xFF1B1B1B),
            error: Color(0xFF4E3F01),
            onError: Colors.white54,
            primary: Color(0xFFF4DE85),
            onPrimary: Colors.grey
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme(
            brightness: Brightness.dark,
            surface: Color(0xFF2B2204),
            onSurface: Color(0xFFD8D7D7),
            secondary: Color(0x33FAF9F9),
            onSecondary: Color(0xFFD8D7D7),
            error: Color(0xFFF4DE85),
            onError: Colors.white54,
            primary: Color(0xFF4E3F01),
            onPrimary: Colors.grey
        ),
        useMaterial3: true
      ),
      home: const DrinksListView(),
    );
  }
}

