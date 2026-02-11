import 'package:flutter/material.dart';

class FlightModel {
  final String airlineName;
  final String flightId;

  final String logoText;
  final Color logoBg;
  final Color logoTextColor;

  final String departTime;
  final String arriveTime;

  final String departCode;
  final String arriveCode;

  final String departCity;
  final String arriveCity;

  final String duration;
  final int price;

  final String terminal;
  final String gate;
  final String flightClass;

  const FlightModel({
    required this.airlineName,
    required this.flightId,
    required this.logoText,
    required this.logoBg,
    required this.logoTextColor,
    required this.departTime,
    required this.arriveTime,
    required this.departCode,
    required this.arriveCode,
    required this.departCity,
    required this.arriveCity,
    required this.duration,
    required this.price,
    required this.terminal,
    required this.gate,
    required this.flightClass,
  });
}
