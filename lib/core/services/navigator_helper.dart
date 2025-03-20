import 'package:flutter/material.dart';

class NavigationHelper {
  static Future<T?> navigateTo<T>(BuildContext context, String routeName,
      {Object? arguments}) {
    return Navigator.of(context).pushNamed(routeName, arguments: arguments);
  }

  static Future<T?> navigateToReplacement<T>(
      BuildContext context, String routeName,
      {Object? arguments}) {
    return Navigator.of(context)
        .pushReplacementNamed(routeName, arguments: arguments);
  }

  static Future<T?> navigateToAndRemoveUntil<T>(
      BuildContext context, String routeName,
      {Object? arguments, bool Function(Route<dynamic>)? predicate}) {
    return Navigator.of(context).pushNamedAndRemoveUntil(
      routeName,
      predicate ?? (route) => false,
      arguments: arguments,
    );
  }

  static void goBack<T>(BuildContext context, {T? result}) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop(result);
    }
  }

  static bool canGoBack(BuildContext context) {
    return Navigator.of(context).canPop();
  }
}
