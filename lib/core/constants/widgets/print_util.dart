import 'dart:convert';
import 'package:flutter/foundation.dart';

class PrintUtil {
  static const String _reset = '\x1B[0m';
  static const String _green = '\x1B[32m'; // Success ✅
  static const String _yellow = '\x1B[33m'; // Warning ⚠
  static const String _red = '\x1B[31m'; // Error ❌
  static const String _blue = '\x1B[34m'; // Info ℹ
  static const String _magenta = '\x1B[35m'; // Debug 🛠

  static void success(dynamic message) {
    _printMessage(message, _green, "SUCCESS ✅");
  }

  static void warning(dynamic message) {
    _printMessage(message, _yellow, "WARNING ⚠");
  }

  static void error(dynamic message) {
    _printMessage(message, _red, "ERROR ❌");
  }

  static void info(dynamic message) {
    _printMessage(message, _blue, "INFO ℹ");
  }

  static void debug(dynamic message) {
    _printMessage(message, _magenta, "DEBUG 🛠");
  }

  static void _printMessage(dynamic message, String color, String prefix) {
    if (message is Map || message is List) {
      message = jsonEncode(message); // Pretty print JSON
    }

    final logMessage = '$color[$prefix]: $message$_reset';

    if (kDebugMode) {
      print(logMessage);
    }
  }
}
