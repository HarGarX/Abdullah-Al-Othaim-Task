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

class ServerException extends AppException {
  final String errorMessage;
  const ServerException({required this.errorMessage}) : super(errorMessage: errorMessage);
  @override
  List<Object?> get props => [errorMessage];
}

class CacheException extends AppException {
  final String errorMessage;
  const CacheException({required this.errorMessage}) : super(errorMessage: errorMessage);
  @override
  List<Object?> get props => [errorMessage];
}
