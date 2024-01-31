
import 'package:sentry_flutter/sentry_flutter.dart';

import 'error_handler.dart';

abstract class SentryErrorHandler implements ErrorHandler {

  @override
  void handle(Error error) {
    if (error is! DomainError) {
      Sentry.captureException(error, stackTrace: StackTrace.current);
      return;
    }
    _handleDomainError(error);
  }

  void _handleDomainError(DomainError error) {
    var level = _mapSentryLevel(error.level);
    Hint hint = Hint();
    Sentry.captureEvent(
      SentryEvent(
        level: level,
        message: SentryMessage(error.message),
        extra: {
          'code': error.code,
          'details': error.details,
          'hint': error.hint,
        },
      ),
      hint: hint,
    );
  }

  SentryLevel _mapSentryLevel(ErrorLevel level) {
    switch (level) {
      case ErrorLevel.info:
        return SentryLevel.info;
      case ErrorLevel.warning:
        return SentryLevel.warning;
      case ErrorLevel.error:
        return SentryLevel.error;
    }
  }

}
