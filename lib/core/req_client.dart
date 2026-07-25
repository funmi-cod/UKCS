import 'package:dio/dio.dart';

class ReqClient {
  final Dio dio = Dio();

  ReqClient() {
    dio.options
      ..connectTimeout = const Duration(seconds: 20)
      ..receiveTimeout = const Duration(seconds: 20);
  }
  Future<Response> getWithoutAuthClient(String endpoint) async {
    return await dio.get(endpoint);
  }
}
