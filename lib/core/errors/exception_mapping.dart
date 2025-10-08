import 'package:dio/dio.dart';
import 'failure.dart';

Failure mapException(Object error, [StackTrace? stack]) {
  if (error is DioException) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return NetworkFailure(message: 'Network timeout', cause: error);
      case DioExceptionType.badResponse:
        return ApiFailure(
          message: 'API error ${error.response?.statusCode}',
          cause: error,
          statusCode: error.response?.statusCode,
        );
      case DioExceptionType.connectionError:
      case DioExceptionType.unknown:
        return NetworkFailure(message: 'Network error', cause: error);
      case DioExceptionType.cancel:
        return UnknownFailure(message: 'Request cancelled', cause: error);
      case DioExceptionType.badCertificate:
        return NetworkFailure(message: 'Bad SSL certificate', cause: error);
    }
  } else if (error is FormatException) {
    return ParsingFailure(message: 'Data parsing failed', cause: error);
  }
  return UnknownFailure(message: 'Unexpected error', cause: error);
}

