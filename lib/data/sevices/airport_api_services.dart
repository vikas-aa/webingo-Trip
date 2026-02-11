import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';

class AirportApiService {
  final ApiClient _client;

  AirportApiService(this._client);

  Future<Map<String, dynamic>> getDepartureAirports({
    String search = "",
    int page = 1,
    int limit = 20,
  }) {
    return _client.post(
      ApiConstants.departureAirports,
      body: {
        "search": search,
        "page": page,
        "limit": limit,
      },
    );
  }

  Future<Map<String, dynamic>> getArrivalAirports({
    String search = "",
    int page = 1,
    int limit = 20,
  }) {
    return _client.post(
      ApiConstants.arrivalAirports,
      body: {
        "search": search,
        "page": page,
        "limit": limit,
      },
    );
  }
}
