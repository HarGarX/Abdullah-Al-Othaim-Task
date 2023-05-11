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
  const NoInternetException({required super.errorMessage});
}

class ServerException extends AppException {
  const ServerException({required super.errorMessage});
}

class CacheException extends AppException {
  const CacheException({required super.errorMessage});
}
