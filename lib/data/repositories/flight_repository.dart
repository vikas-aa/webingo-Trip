import 'package:flutter_application_1/data/models/flight_model.dart';
import 'package:flutter_application_1/data/sevices/flight_api_services.dart';

class FlightRepository {
  final FlightApiService _api;

  FlightRepository(this._api);

  Future<List<FlightModel>> searchFlights({
    required String from,
    required String to,
    required String date,
    required int passengers,
  }) async {
    final res = await _api.searchFlights(
      from: from,
      to: to,
      date: date,
      passengers: passengers,
    );

    // ✅ YOUR REAL API STRUCTURE:
    // res["data"] => Map
    // res["data"]["flights"] => List

    final dynamic data = res["data"];
    if (data is! Map) return [];

    final dynamic flightsRaw = data["flights"];
    if (flightsRaw is! List) return [];

    return flightsRaw.map((e) => FlightModel.fromApi(e)).toList();
  }

Future<FlightModel> getFlightDetails(int id) async {
  final res = await _api.getFlightDetails(id: id);

  final dynamic data = res["data"];

  if (data is Map) {
    // ✅ Correct: flight object is inside flight_details
    final dynamic flightJson = data["flight_details"];

    if (flightJson is Map<String, dynamic>) {
      return FlightModel.fromApi(flightJson);
    }

    if (flightJson is Map) {
      return FlightModel.fromApi(
        flightJson.map((k, v) => MapEntry(k.toString(), v)),
      );
    }
  }

  throw Exception("Invalid flight detail response");
}

}
