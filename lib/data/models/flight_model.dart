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

  // ✅ Safe time formatter
  static String _safeTime(dynamic value) {
    final s = (value ?? "").toString().trim();

    // If empty or invalid
    if (s.isEmpty) return "--:--";

    // If time is like "02:00:00" => take "02:00"
    if (s.length >= 5) return s.substring(0, 5);

    // If time is shorter than 5, just return it
    return s;
  }

  // ✅ Safe string
  static String _safeString(dynamic value, {String fallback = ""}) {
    final s = (value ?? "").toString().trim();
    return s.isEmpty ? fallback : s;
  }

  // ✅ Safe int
  static int _safeInt(dynamic value, {int fallback = 0}) {
    if (value is int) return value;
    return int.tryParse((value ?? "").toString()) ?? fallback;
  }

  factory FlightModel.fromApi(Map<String, dynamic> json) {
    final airlineName = _safeString(json["airline_name"], fallback: "Unknown Airline");
    final flightNumber = _safeString(json["flight_number"], fallback: "N/A");

    final departure = (json["departure"] is Map) ? (json["departure"] as Map) : {};
    final arrival = (json["arrival"] is Map) ? (json["arrival"] as Map) : {};

    final priceMap = (json["price"] is Map) ? (json["price"] as Map) : {};
    final priceInt = _safeInt(priceMap["amount"], fallback: 0);

    final apiId = _safeInt(json["id"], fallback: 0);
    final finalApiId = apiId == 0 ? null : apiId;

    // ✅ Color mapping
    Color bg = const Color(0xFFEAF1FF);
    Color textColor = const Color(0xFF2B67FF);

    final lower = airlineName.toLowerCase();

    if (lower.contains("spice")) {
      bg = const Color(0xFFFFE8E8);
      textColor = const Color(0xFFCC2E2E);
    } else if (lower.contains("indigo")) {
      bg = const Color(0xFFEAF1FF);
      textColor = const Color(0xFF2B67FF);
    } else if (lower.contains("air india")) {
      bg = const Color(0xFFE7F7EE);
      textColor = const Color(0xFF0D8B57);
    }

    // ✅ Logo text safe
    String logoText = "Air";
    if (airlineName.trim().isNotEmpty) {
      final parts = airlineName.trim().split(" ");
      logoText = parts.isNotEmpty ? parts.first : "Air";
    }

    return FlightModel(
      apiId: finalApiId,
      airlineName: airlineName,
      flightId: flightNumber,

      logoText: logoText,
      logoBg: bg,
      logoTextColor: textColor,

      // ✅ FIXED HERE
      departTime: _safeTime(departure["time"]),
      arriveTime: _safeTime(arrival["time"]),

      departCode: _safeString(departure["airport_code"], fallback: "---"),
      departCity: "(${_safeString(departure["city"], fallback: "Unknown")})",

      arriveCode: _safeString(arrival["airport_code"], fallback: "---"),
      arriveCity: "(${_safeString(arrival["city"], fallback: "Unknown")})",

      duration: _safeString(json["duration"], fallback: "--"),
      price: priceInt,

      // API me terminal/gate/class nahi hai
     terminal: _safeString(json["terminal"], fallback: "—"),
gate: _safeString(json["gate"], fallback: "—"),
flightClass: _safeString(json["class"], fallback: "Economy"),

    );
  }
}
