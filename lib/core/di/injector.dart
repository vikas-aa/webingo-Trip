import 'package:flutter_application_1/data/repositories/airport_repository.dart';
import 'package:flutter_application_1/data/sevices/airport_api_services.dart';
import 'package:flutter_application_1/data/sevices/flight_api_services.dart';

import '../../data/repositories/flight_repository.dart';

import '../network/api_client.dart';

class Injector {
  static final apiClient = ApiClient();
  static final flightApiService = FlightApiService(apiClient);
  static final flightRepository = FlightRepository(flightApiService);
   // Airport
  static final AirportApiService airportApiService = AirportApiService(apiClient);
  static final AirportRepository airportRepository = AirportRepository(airportApiService);
}
