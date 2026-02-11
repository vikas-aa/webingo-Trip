import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/trip_home_screen.dart';
void main() {
  runApp(const TripUIApp());
}

class TripUIApp extends StatelessWidget {
  const TripUIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Trip UI',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'SF Pro Display', // optional (iOS vibe)
      ),
      home: const TripHomeScreen(),
    );
  }
}