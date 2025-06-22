import 'package:embone/core/constants/app_constant.dart';
import 'package:embone/core/network/local_network.dart';
import 'package:embone/core/services/service_locator.dart';

class GuestUserSession {
  /// Generate UUID if not exists and return it
  static Future<String?> getOrCreateGuestId() async {
    String? guestId =
        sl<CacheHelper>().getDataString(key: AppConstants.guestId);

    return guestId;
  }

  static Future<void> clearGuestId() async {
    await sl<CacheHelper>().removeData(key: AppConstants.guestId);
  }
}
