import 'package:dio/dio.dart';
import 'package:embone/core/constants/app_constant.dart';
import 'package:embone/core/database/api/end_points.dart';
import 'package:embone/core/network/local_network.dart';
import 'package:embone/core/services/service_locator.dart';

class ApiInterceptors extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    String? token = sl<CacheHelper>().getDataString(key: ApiKey.token);

    options.headers[ApiKey.authorization] =
        token != null ? 'Bearer $token' : null;
    options.headers["lang"] =
        sl<CacheHelper>().getCachedLanguage() == "ar" ? "ar" : "en";

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.realUri.toString().contains(EndPoints.userLogin) ||
        response.realUri.toString().contains(EndPoints.userConfirmCode)) {
      RegExp regex = RegExp(r'maxliss_session=([^;]*)');
      Match? match =
          regex.firstMatch(response.headers["Set-Cookie"].toString());

      String? sessionValue = match?.group(1);
      sl<CacheHelper>().setData(AppConstants.cookie, sessionValue ?? "");
    }
    super.onResponse(response, handler);
  }
}
