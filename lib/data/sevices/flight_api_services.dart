import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';

class FlightApiService {
  final ApiClient _client;

  FlightApiService(this._client);

  /// POST /search
  Future<Map<String, dynamic>> searchFlights({
    required String from,
    required String to,
    required String date, // "YYYY-MM-DD"
    required int passengers,
    String sortBy = "price_asc",
    int page = 1,
    int limit = 10,
    List<Map<String, dynamic>>? filters,
  }) async {
    final body = <String, dynamic>{
      "from": from,
      "to": to,
      "date": date,
      "passengers": passengers,
      "sort_by": sortBy,
      "page": page,
      "limit": limit,
    };

    // Optional filters (API response me filters array dikh raha hai)
    if (filters != null && filters.isNotEmpty) {
      body["filters"] = filters;
    }

    return _client.post(ApiConstants.searchFlights, body: body);
  }

  /// POST /flight
  Future<Map<String, dynamic>> getFlightDetails({
    required int id,
  }) async {
    return _client.post(
      ApiConstants.flightDetails,
      body: {"id": id},
    );
  }

  /// POST /list (optional)
  Future<Map<String, dynamic>> getFlightList({
    String sortBy = "price_asc",
    int page = 1,
    int limit = 10,
    List<Map<String, dynamic>>? filters,
  }) async {
    final body = <String, dynamic>{
      "sort_by": sortBy,
      "page": page,
      "limit": limit,
    };

    if (filters != null && filters.isNotEmpty) {
      body["filters"] = filters;
    }

    return _client.post(ApiConstants.flightList, body: body);
  }
}
