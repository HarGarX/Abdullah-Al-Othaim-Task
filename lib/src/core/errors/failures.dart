import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String errorMessage;

  const Failure({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class NoInternetFailure extends Failure {
  const NoInternetFailure({required super.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class ServerFailure extends Failure {
  const ServerFailure({required super.errorMessage});
}

class CacheFailure extends Failure {
  const CacheFailure({required super.errorMessage});
}

class TimeoutFailure extends Failure {
  const TimeoutFailure({required super.errorMessage});
}

class ReadingDataFailure extends Failure {
  const ReadingDataFailure({required super.errorMessage});
}

class UnknownFailure extends Failure {
  const UnknownFailure({required super.errorMessage});
}
