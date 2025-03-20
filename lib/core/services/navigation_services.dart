import 'package:flutter/material.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  // Safe navigation methods that check for null
  static Future<dynamic>? navigateTo(String routeName, {Object? arguments}) {
    if (navigatorKey.currentState != null) {
      return navigatorKey.currentState!
          .pushNamed(routeName, arguments: arguments);
    }
    return null;
  }

  static Future<dynamic>? navigateToReplacement(String routeName,
      {Object? arguments}) {
    if (navigatorKey.currentState != null) {
      return navigatorKey.currentState!
          .pushReplacementNamed(routeName, arguments: arguments);
    }
    return null;
  }

  static Future<dynamic>? navigateToAndRemoveUntil(String routeName,
      {Object? arguments, bool Function(Route<dynamic>)? predicate}) {
    if (navigatorKey.currentState != null) {
      return navigatorKey.currentState!.pushNamedAndRemoveUntil(
        routeName,
        predicate ?? (route) => false,
        arguments: arguments,
      );
    }
    return null;
  }

  static void goBack({dynamic result}) {
    if (navigatorKey.currentState != null &&
        navigatorKey.currentState!.canPop()) {
      navigatorKey.currentState!.pop(result);
    }
  }

  static bool canGoBack() {
    return navigatorKey.currentState != null &&
        navigatorKey.currentState!.canPop();
  }
}
// // Example of navigating with arguments
// NavigationService.navigateTo(
//   AppRoutes.registerFirstName,
//   arguments: {
//     'email': _emailController.text,
//     'password': _passwordController.text,
//   },
// );

// // Example of navigating and removing all previous routes
// NavigationService.navigateToAndRemoveUntil(
//   AppRoutes.login,
// );

// // Example of going back
// NavigationService.goBack();