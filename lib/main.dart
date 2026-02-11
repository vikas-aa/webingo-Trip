import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/di/injector.dart';
import 'providers/flight_provider.dart';
import 'providers/flight_details_provider.dart';
import 'providers/airport_provider.dart';
import 'screens/trip_home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => FlightProvider(Injector.flightRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => FlightDetailsProvider(Injector.flightRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => AirportProvider(Injector.airportRepository),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Flight Booking",
        home: const TripHomeScreen(),
      ),
    );
  }
}
