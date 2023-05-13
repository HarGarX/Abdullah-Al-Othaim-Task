part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();
}

class HomeInitialState extends HomeState {
  @override
  List<Object> get props => [];
}

class HomeLoadingState extends HomeState {
  @override
  List<Object> get props => [];
}

class HomeFailureState extends HomeState {
  final String errorMessage;
  const HomeFailureState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

class HomeSuccessState extends HomeState {
  final List<ProductEntity> productsList;
  const HomeSuccessState({required this.productsList});

  @override
  List<Object> get props => [productsList];
}
