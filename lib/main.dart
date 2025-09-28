import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'package:google_fonts/google_fonts.dart'; // optional

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo (sqflite)',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        //textTheme: GoogleFonts.poppinsTextTheme(), // optional
      ),
      home: const HomeScreen(),
    );
  }
}
