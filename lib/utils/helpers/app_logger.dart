import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

/// Application-wide logger that only logs in debug mode
class AppLogger {
  final String name;

  AppLogger(this.name);

  /// Log debug information
  void debug(String message, [Object? error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      developer.log(
        message,
        name: name,
        error: error,
        stackTrace: stackTrace,
        level: 500, // Debug level
      );
    }
  }

  /// Log informational messages
  void info(String message, [Object? error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      developer.log(
        message,
        name: name,
        error: error,
        stackTrace: stackTrace,
        level: 800, // Info level
      );
    }
  }

  /// Log warnings
  void warning(String message, [Object? error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      developer.log(
        message,
        name: name,
        error: error,
        stackTrace: stackTrace,
        level: 900, // Warning level
      );
    }
  }

  /// Log errors
  void error(String message, [Object? error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      developer.log(
        message,
        name: name,
        error: error,
        stackTrace: stackTrace,
        level: 1000, // Error level
      );
    }
  }

  /// Log with custom level
  void log(
    String message, {
    int level = 800,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (kDebugMode) {
      developer.log(
        message,
        name: name,
        level: level,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}
