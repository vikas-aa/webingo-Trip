class AirportModel {
  final String airportCode;
  final String city;
  final int flightCount;

  const AirportModel({
    required this.airportCode,
    required this.city,
    required this.flightCount,
  });

  factory AirportModel.fromApi(Map<String, dynamic> json) {
    return AirportModel(
      airportCode: (json["airport_code"] ?? "").toString(),
      city: (json["city"] ?? "").toString(),
      flightCount: int.tryParse((json["flight_count"] ?? "0").toString()) ?? 0,
    );
  }

  String get displayName => "$city ($airportCode)";
}
