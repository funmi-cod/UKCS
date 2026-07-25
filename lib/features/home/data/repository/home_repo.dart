import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ukcs_app/core/req_client.dart';

final homeRepoProvider = Provider<HomeRepo>((ref) {
  return HomeRepo(ReqClient());
});

// handles the API calls
class HomeRepo {
  final ReqClient reqClient;

  HomeRepo(this.reqClient);

  Future<Response> locationPoints({required String postcode}) async {
    Response response = await reqClient.getWithoutAuthClient(
      "https://api.postcodes.io/postcodes/$postcode",
    );
    return response;
  }

  Future<Response> locationCrimeHistory({
    required double lat,
    required double long,
  }) async {
    Response response = await reqClient.getWithoutAuthClient(
      "https://data.police.uk/api/crimes-street/all-crime?lat=$lat&lng=$long",
    );
    return response;
  }
}
