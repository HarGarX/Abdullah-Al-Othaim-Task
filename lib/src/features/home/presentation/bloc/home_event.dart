part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

class FetchHomeDataEvent extends HomeEvent {
  const FetchHomeDataEvent();

  @override
  List<Object?> get props => [];
}

class UpdateLocalDataEvent extends HomeEvent {
  const UpdateLocalDataEvent();

  @override
  List<Object?> get props => [];
}
