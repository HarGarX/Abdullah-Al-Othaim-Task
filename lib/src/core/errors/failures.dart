import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String errorMessage;

  const Failure({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];

  @override
  bool get stringify => true;
}

class NoInternetFailure extends Failure {
  const NoInternetFailure({required super.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}

class ServerFailure extends Failure {
  final String errorMessage;

  const ServerFailure({required this.errorMessage}) : super(errorMessage: errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class TimeoutFailure extends Failure {
  final String errorMessage;
  const TimeoutFailure({required this.errorMessage}) : super(errorMessage: errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class ReadingDataFailure extends Failure {
  final String errorMessage;
  const ReadingDataFailure({required this.errorMessage}) : super(errorMessage: errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class UnknownFailure extends Failure {
  final String errorMessage;

  const UnknownFailure({required this.errorMessage}) : super(errorMessage: errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
