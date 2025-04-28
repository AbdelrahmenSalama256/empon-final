import 'package:dio/dio.dart';
import 'package:embone/core/constants/app_constant.dart';

class DioClient {
  final Dio _dio = Dio(BaseOptions(baseUrl: AppConstants.baseUrl));

  Future<Response> post(String endpoint, Map<String, dynamic> data) async {
    try {
      Response response = await _dio.post(
        endpoint,
        data: data,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to send request: $e');
    }
  }
}
