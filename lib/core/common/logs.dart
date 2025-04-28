import 'dart:convert';
import 'package:flutter/foundation.dart';

// Reset:   \x1B[0m
// Black:   \x1B[30m
// White:   \x1B[37m
// Red:     \x1B[31m
// Green:   \x1B[32m
// Yellow:  \x1B[33m
// Blue:    \x1B[34m
// Cyan:    \x1B[36m
class Print {
  // ANSI codes for colors
  static const String ansiRESET = '\x1B[0m';
  static const String ansiRED = '\x1B[31m';
  static const String ansiGREEN = '\x1B[32m';
  static const String ansiYELLOW = '\x1B[33m';
  static const String ansiBLUE = '\x1B[34m';
  static const String ansiPURPLE = '\x1B[35m';
  static const String ansiCYAN = '\x1B[36m';
  static const String ansiWHITE = '\x1B[37m';

  // Print success message (green)
  static void success(dynamic message) {
    String formattedMessage = _formatMessage(message, ansiGREEN);
    if (kDebugMode) {
      print("✅✅$formattedMessage");
    }
  }

  // Print fail message (red)
  static void error(dynamic message) {
    String formattedMessage = _formatMessage(message, ansiRED);
    if (kDebugMode) {
      print('❌❌$formattedMessage');
    }
  }

  // Print warning message (yellow)
  static void warning(dynamic message) {
    String formattedMessage = _formatMessage(message, ansiYELLOW);
    if (kDebugMode) {
      print('☢️☢️$formattedMessage');
    }
  }

  // Print info message (blue)
  static void info(dynamic message) {
    String formattedMessage = _formatMessage(message, ansiBLUE);
    if (kDebugMode) {
      print('🔵🔵$formattedMessage');
    }
  }

  // Print important message (purple)
  static void important(dynamic message) {
    String formattedMessage = _formatMessage(message, ansiPURPLE);
    if (kDebugMode) {
      print('💡 💡$formattedMessage');
    }
  }

  // Helper method to format the message
  static String _formatMessage(dynamic message, String color) {
    try {
      if (message is Map || message is List) {
        // var jsonObject = jsonDecode(message);
        String formattedJson =
            const JsonEncoder.withIndent('  ').convert(message);
        // Split the formatted JSON string into lines
        List<String> lines = formattedJson.split('\n');

        // Apply the ANSI color code to each line
        return lines.map((line) => '$color$line$ansiRESET').join('\n');
      } else {
        return '$color$message$ansiRESET';
      }
    } catch (e) {
      // If message is not a valid JSON, return it as plain text with color
      return '$color$message$ansiRESET';
    }
  }
}
