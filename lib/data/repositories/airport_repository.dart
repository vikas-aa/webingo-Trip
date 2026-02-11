import 'package:flutter_application_1/data/sevices/airport_api_services.dart';

import '../models/airport_model.dart';


class AirportRepository {
  final AirportApiService _api;
  AirportRepository(this._api);

  Future<List<Map<String, dynamic>>> getDepartureAirports({
    String search = "",
  }) async {
    final res = await _api.getDepartureAirports(search: search);

    if (res["status"] != "success") {
      throw Exception(res["message"] ?? "Failed to load departure airports");
    }

    final data = res["data"];
    final airports = data?["airports"];

    if (airports is List) {
      return airports.map((e) => Map<String, dynamic>.from(e)).toList();
    }

    return [];
  }

  Future<List<Map<String, dynamic>>> getArrivalAirports({
    String search = "",
  }) async {
    final res = await _api.getArrivalAirports(search: search);

    if (res["status"] != "success") {
      throw Exception(res["message"] ?? "Failed to load arrival airports");
    }

    final data = res["data"];
    final airports = data?["airports"];

    if (airports is List) {
      return airports.map((e) => Map<String, dynamic>.from(e)).toList();
    }

    return [];
  }

  // Optional - agar tum AirportModel use kar rahe ho
  Future<List<AirportModel>> getFromAirports({String query = ""}) async {
    final list = await getDepartureAirports(search: query);
    return list.map((e) => AirportModel.fromApi(e)).toList();
  }

  Future<List<AirportModel>> getToAirports({String query = ""}) async {
    final list = await getArrivalAirports(search: query);
    return list.map((e) => AirportModel.fromApi(e)).toList();
  }
}
