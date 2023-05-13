import 'package:abdullah_al_othaim_task/src/core/errors/failures.dart';
import 'package:abdullah_al_othaim_task/src/features/home/domain/entites/product_entity.dart';
import 'package:dartz/dartz.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<ProductEntity>>> fetchProducts();
  Future<Either<Failure, List<ProductEntity>>> updateLocalData();
}
