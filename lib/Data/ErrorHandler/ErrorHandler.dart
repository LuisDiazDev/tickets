enum ErrorLevel {
  info,
  warning,
  error,
}

class DomainError extends Error {
  final String message;
  final String? code;
  final String? details;
  final String? hint;
  final ErrorLevel level;

  DomainError(this.message,
      {this.code, this.details, this.hint, this.level = ErrorLevel.error});
}

abstract class ErrorHandler {
  void handle(Error error);
}
