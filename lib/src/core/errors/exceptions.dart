import 'package:equatable/equatable.dart';

class AppException extends Equatable implements Exception {
  final String errorMessage;

  const AppException({required this.errorMessage});

  @override
  String toString() {
    return errorMessage;
  }

  @override
  List<Object?> get props => [];
}

/// Exception thrown when the  user does not have an internet connection
class NoInternetException extends AppException {
  final String errorMessage;
  const NoInternetException({required this.errorMessage}) : super(errorMessage: errorMessage);
  @override
  List<Object?> get props => [errorMessage];
}

/// Exception thrown when there is an error thrown from the server
class ServerException extends AppException {
  final String errorMessage;
  const ServerException({required this.errorMessage}) : super(errorMessage: errorMessage);
  @override
  List<Object?> get props => [errorMessage];

  @override
  String toString() {
    return errorMessage;
  }
}

class ErrorReadingDataException extends AppException {
  final String errorMessage;
  const ErrorReadingDataException({required this.errorMessage}) : super(errorMessage: errorMessage);
  @override
  List<Object?> get props => [errorMessage];

  @override
  String toString() {
    return errorMessage;
  }
}

class UnknownException extends AppException {
  final String errorMessage;
  const UnknownException({required this.errorMessage}) : super(errorMessage: errorMessage);
  @override
  List<Object?> get props => [errorMessage];
}
