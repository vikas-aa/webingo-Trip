import 'package:flutter/material.dart';
import '../data/models/airport_model.dart';
import '../data/repositories/airport_repository.dart';

class AirportProvider extends ChangeNotifier {
  final AirportRepository _repo;

  AirportProvider(this._repo);

  bool isLoading = false;
  String? error;

  List<AirportModel> fromAirports = [];
  List<AirportModel> toAirports = [];

  // Home screen dropdown ke liye
  List<Map<String, dynamic>> departureAirports = [];
  List<Map<String, dynamic>> arrivalAirports = [];

  Future<void> loadDepartureAirports({String search = ""}) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      departureAirports = await _repo.getDepartureAirports(search: search);
    } catch (e) {
      error = e.toString();
      departureAirports = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadArrivalAirports({String search = ""}) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      arrivalAirports = await _repo.getArrivalAirports(search: search);
    } catch (e) {
      error = e.toString();
      arrivalAirports = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Optional (search screens)
  Future<void> searchFromAirports(String query) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      fromAirports = await _repo.getFromAirports(query: query);
    } catch (e) {
      error = e.toString();
      fromAirports = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchToAirports(String query) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      toAirports = await _repo.getToAirports(query: query);
    } catch (e) {
      error = e.toString();
      toAirports = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
