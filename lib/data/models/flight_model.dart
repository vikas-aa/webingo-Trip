import 'package:flutter/material.dart';

class FlightModel {
  final int? apiId;

  final String airlineName;
  final String flightId;

  final String logoText;
  final Color logoBg;
  final Color logoTextColor;

  final String departTime;
  final String arriveTime;

  final String departCode;
  final String departCity;

  final String arriveCode;
  final String arriveCity;

  final String duration;
  final int price;

  final String terminal;
  final String gate;
  final String flightClass;

  const FlightModel({
    required this.apiId,
    required this.airlineName,
    required this.flightId,
    required this.logoText,
    required this.logoBg,
    required this.logoTextColor,
    required this.departTime,
    required this.arriveTime,
    required this.departCode,
    required this.departCity,
    required this.arriveCode,
    required this.arriveCity,
    required this.duration,
    required this.price,
    required this.terminal,
    required this.gate,
    required this.flightClass,
  });

  factory FlightModel.fromApi(Map<String, dynamic> json) {
    final airlineName = (json["airline_name"] ?? "").toString();
    final flightNumber = (json["flight_number"] ?? "").toString();

    final departure = (json["departure"] is Map) ? json["departure"] as Map : {};
    final arrival = (json["arrival"] is Map) ? json["arrival"] as Map : {};

    final priceMap = (json["price"] is Map) ? json["price"] as Map : {};

    final amount = priceMap["amount"];
    final priceInt = amount is int ? amount : int.tryParse(amount.toString()) ?? 0;

    final id = json["id"];
    final apiId = id is int ? id : int.tryParse(id.toString());

    // Simple color mapping by airline
    Color bg = const Color(0xFFEAF1FF);
    Color textColor = const Color(0xFF2B67FF);

    if (airlineName.toLowerCase().contains("spice")) {
      bg = const Color(0xFFFFE8E8);
      textColor = const Color(0xFFCC2E2E);
    } else if (airlineName.toLowerCase().contains("indigo")) {
      bg = const Color(0xFFEAF1FF);
      textColor = const Color(0xFF2B67FF);
    } else if (airlineName.toLowerCase().contains("air india")) {
      bg = const Color(0xFFE7F7EE);
      textColor = const Color(0xFF0D8B57);
    }

    return FlightModel(
      apiId: apiId,
      airlineName: airlineName.isEmpty ? "Unknown Airline" : airlineName,
      flightId: flightNumber.isEmpty ? "N/A" : flightNumber,

      logoText: airlineName.isEmpty ? "Air" : airlineName.split(" ").first,
      logoBg: bg,
      logoTextColor: textColor,

      departTime: (departure["time"] ?? "").toString().substring(0, 5),
      arriveTime: (arrival["time"] ?? "").toString().substring(0, 5),

      departCode: (departure["airport_code"] ?? "").toString(),
      departCity: "(${(departure["city"] ?? "").toString()})",

      arriveCode: (arrival["airport_code"] ?? "").toString(),
      arriveCity: "(${(arrival["city"] ?? "").toString()})",

      duration: (json["duration"] ?? "").toString(),
      price: priceInt,

      // API me terminal/gate/class nahi hai
      terminal: "—",
      gate: "—",
      flightClass: "Economy",
    );
  }
}
