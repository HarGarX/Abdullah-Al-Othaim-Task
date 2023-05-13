import 'package:abdullah_al_othaim_task/src/core/use_cases/usecase.dart';
import 'package:abdullah_al_othaim_task/src/features/home/domain/entites/product_entity.dart';
import 'package:abdullah_al_othaim_task/src/features/home/domain/use_cases/fetch_products_use_case.dart';
import 'package:abdullah_al_othaim_task/src/features/home/domain/use_cases/update_data_in_local_use_case.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(
      {required FetchProductsUseCase fetchProductsUseCase, required UpdateDataInLocalUseCase updateDataInLocalUseCase})
      : _fetchProductsUseCase = fetchProductsUseCase,
        _updateDataInLocalUseCase = updateDataInLocalUseCase,
        super(HomeInitialState()) {
    on<FetchHomeDataEvent>(_handleFetchHomeDataEvent);
    on<UpdateLocalDataEvent>(_handleUpdateLocalDataEvent);
  }
  //Local Variables
  List<ProductEntity> localProductsList = [];
  //Use Cases
  final FetchProductsUseCase _fetchProductsUseCase;
  final UpdateDataInLocalUseCase _updateDataInLocalUseCase;

//Events Handlers
  Future<void> _handleFetchHomeDataEvent(FetchHomeDataEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoadingState());
    final eitherFailureOrProductsList = await _fetchProductsUseCase(NoParams());
    eitherFailureOrProductsList.fold((failure) {
      emit(HomeFailureState(errorMessage: failure.errorMessage));
    }, (productsList) {
      localProductsList = productsList;
      emit(HomeSuccessState(productsList: productsList));
    });
  }

  Future<void> _handleUpdateLocalDataEvent(UpdateLocalDataEvent event, Emitter<HomeState> emit) async {
    // emit(HomeUpdateDataSuccessfullyState());
    final eitherFailureOrProductsList = await _updateDataInLocalUseCase(NoParams());
    eitherFailureOrProductsList.fold((failure) {
      emit(HomeFailureState(errorMessage: failure.errorMessage));
    }, (updatedProductsList) {
      if (localProductsList == updatedProductsList) {
        emit(HomeSuccessState(productsList: localProductsList));
      } else {
        localProductsList = updatedProductsList;
        emit(HomeSuccessState(productsList: localProductsList));
      }
    });
  }
}
