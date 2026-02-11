import 'package:flutter/material.dart';
import '../core/network/api_exception.dart';
import '../data/models/flight_model.dart';
import '../data/repositories/flight_repository.dart';

class FlightProvider extends ChangeNotifier {
  final FlightRepository _repo;
  FlightProvider(this._repo);

  bool isLoading = false;
  String? error;

  List<FlightModel> flights = [];

  // for UI filter
  int activeFilter = 0;

  Future<void> searchFlights({
    required String fromCity,
    required String toCity,
    required DateTime date,
    required int people,
  }) async {
    isLoading = true;
    error = null;
    flights = [];
    notifyListeners();

    try {
      final dateStr =
          "${date.year.toString().padLeft(4, "0")}-${date.month.toString().padLeft(2, "0")}-${date.day.toString().padLeft(2, "0")}";

      flights = await _repo.searchFlights(
        from: _extractAirportCode(fromCity),
        to: _extractAirportCode(toCity),
        date: dateStr,
        passengers: people,
      );
    } on ApiException catch (e) {
      error = e.message;
    } catch (_) {
      error = "Something went wrong";
    }

    isLoading = false;
    notifyListeners();
  }

  void setActiveFilter(int index) {
    activeFilter = index;
    notifyListeners();
  }

  List<FlightModel> get filteredFlights {
    final list = [...flights];

    // UI filters same as your code
    if (activeFilter == 0) {
      list.sort((a, b) => a.price.compareTo(b.price));
    } else if (activeFilter == 1) {
      // Preferred airlines logic (example)
      return list.where((e) => e.airlineName.toLowerCase().contains("cit")).toList();
    }

    return list;
  }

  // "Jakarta (CGK)" -> CGK
  String _extractAirportCode(String city) {
    final match = RegExp(r"\((.*?)\)").firstMatch(city);
    return match?.group(1) ?? city;
  }
}
