import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/models/flight_model.dart';

import '../core/network/api_exception.dart';
import '../data/repositories/flight_repository.dart';

class FlightDetailsProvider extends ChangeNotifier {
  final FlightRepository _repo;
  FlightDetailsProvider(this._repo);

  bool isLoading = false;
  String? error;

  FlightModel? flightDetails;

  Future<void> loadDetails(FlightModel flight) async {
    // If API id not available, just show passed flight
    if (flight.apiId == null) {
      flightDetails = flight;
      notifyListeners();
      return;
    }

    isLoading = true;
    error = null;
    flightDetails = null;
    notifyListeners();

    try {
      flightDetails = await _repo.getFlightDetails(flight.apiId!);
    } on ApiException catch (e) {
      error = e.message;
      flightDetails = flight; // fallback
    } catch (_) {
      error = "Something went wrong";
      flightDetails = flight; // fallback
    }

    isLoading = false;
    notifyListeners();
  }
}
