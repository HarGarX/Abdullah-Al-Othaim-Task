import 'package:abdullah_al_othaim_task/src/features/home/domain/use_cases/fetch_products_use_case.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({required FetchProductsUseCase fetchProductsUseCase})
      : _fetchProductsUseCase = fetchProductsUseCase,
        super(HomeInitial()) {
    on<HomeEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
  //Local Variables

  //Use Cases
  final FetchProductsUseCase _fetchProductsUseCase;

//Events Handlers
}
