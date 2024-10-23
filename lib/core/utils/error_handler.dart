import 'dart:async';

class ErrorHandler {
  static void handleError(Function callback) {
    try {
      callback();
    } catch (e, stackTrace) {
      print('Error occurred: $e');
      print('Stack trace: $stackTrace');
      // Tambahkan logging service disini jika diperlukan
    }
  }

  static Future<void> handleFutureError(Future Function() callback) async {
    try {
      await callback();
    } catch (e, stackTrace) {
      print('Error occurred: $e');
      print('Stack trace: $stackTrace');
      // Tambahkan logging service disini jika diperlukan
    }
  }

  static R? runWithTry<R>(R Function() callback, {R? defaultValue}) {
    try {
      return callback();
    } catch (e, stackTrace) {
      print('Error occurred: $e');
      print('Stack trace: $stackTrace');
      return defaultValue;
    }
  }
}