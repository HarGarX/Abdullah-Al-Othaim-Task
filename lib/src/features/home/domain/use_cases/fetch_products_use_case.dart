import 'package:abdullah_al_othaim_task/src/core/errors/failures.dart';
import 'package:abdullah_al_othaim_task/src/core/use_cases/usecase.dart';
import 'package:abdullah_al_othaim_task/src/features/home/domain/entites/product_entity.dart';
import 'package:abdullah_al_othaim_task/src/features/home/domain/repository/home_repository.dart';
import 'package:dartz/dartz.dart';

class FetchProductsUseCase extends UseCase<List<ProductEntity>, NoParams> {
  final HomeRepository _homeRepository;
  FetchProductsUseCase({required HomeRepository homeRepository}) : _homeRepository = homeRepository;

  @override
  Future<Either<Failure, List<ProductEntity>>> call(NoParams params) async {
    return await _homeRepository.fetchProducts();
  }
}
