import 'dart:async';
import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';

import 'package:abdullah_al_othaim_task/src/core/constants/secure_storage_consts.dart';
import 'package:abdullah_al_othaim_task/src/core/errors/exceptions.dart';
import 'package:abdullah_al_othaim_task/src/core/errors/failures.dart';
import 'package:abdullah_al_othaim_task/src/core/platform/network_info.dart';
import 'package:abdullah_al_othaim_task/src/core/service_locater.dart';
import 'package:abdullah_al_othaim_task/src/features/home/data/data_source/local/home_local_data_source.dart';
import 'package:abdullah_al_othaim_task/src/features/home/data/data_source/remote/home_remote_data_source.dart';
import 'package:abdullah_al_othaim_task/src/features/home/data/models/fetch_products_response_model.dart';
import 'package:abdullah_al_othaim_task/src/features/home/domain/entites/product_entity.dart';
import 'package:abdullah_al_othaim_task/src/features/home/domain/repository/home_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource _remoteDataSource;
  final HomeLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  HomeRepositoryImpl({
    required HomeRemoteDataSource remoteDataSource,
    required HomeLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, List<ProductEntity>>> fetchProducts() async {
    final bool isConnected = await _networkInfo.isConnected;
    final secureStorage = locator<FlutterSecureStorage>();
    final String? notFirstFetch = await secureStorage.read(key: SecureStorageConstants.NOT_FIRST_FETCH);
    final bool isItNotFirstFetch = notFirstFetch == 'true' ? true : false;
    if (isConnected == true && isItNotFirstFetch == false) {
      dev.log("its connected");
      try {
        final FetchProductsResponseModel rawData = await _remoteDataSource.fetchProducts();
        await _localDataSource.cacheData(data: rawData);
        await secureStorage.write(key: SecureStorageConstants.NOT_FIRST_FETCH, value: 'true');
        final data = rawData.data;
        final List<ProductEntity> productsList = productsEntityFromJson(jsonEncode(data));
        return Right(productsList);
      } on PathNotFoundException {
        return const Left(ServerFailure(errorMessage: 'Local Data file not found'));
      } on TimeoutException {
        return const Left(TimeoutFailure(errorMessage: 'Time out waiting response from server. '));
      } on ServerException catch (e) {
        return Left(ServerFailure(errorMessage: e.toString()));
      } on SocketException {
        return const Left(NoInternetFailure(errorMessage: 'No Internet Connectivity'));
      }
    } else {
      dev.log("its not connected");

      try {
        final rawData = await _localDataSource.fetchProducts();
        final data = rawData.data;
        final List<ProductEntity> productsList = productsEntityFromJson(jsonEncode(data));
        return Right(productsList);
      } on CacheException {
        return const Left(CacheFailure(errorMessage: 'no data in cache'));
      }
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> updateLocalData() async {
    final bool isConnected = await _networkInfo.isConnected;

    if (isConnected == true) {
      dev.log("its connected from update data");
      try {
        final FetchProductsResponseModel rawData = await _remoteDataSource.fetchProducts();
        await _localDataSource.cacheData(data: rawData);
        final data = rawData.data;
        final List<ProductEntity> productsList = productsEntityFromJson(jsonEncode(data));
        return Right(productsList);
      } on PathNotFoundException {
        return const Left(ServerFailure(errorMessage: 'Local Data file not found'));
      } on TimeoutException {
        return const Left(TimeoutFailure(errorMessage: 'Time out waiting response from server. '));
      } on ServerException catch (e) {
        return Left(ServerFailure(errorMessage: e.toString()));
      } on SocketException {
        return const Left(NoInternetFailure(errorMessage: 'No Internet Connectivity'));
      }
    } else {
      dev.log("its not connected from update data");
      return const Left(CacheFailure(errorMessage: 'error updating local data '));
    }
  }
}

/*
Expected: Right<dynamic, List<ProductEntity>>:<Right([ProductEntity(1, product 1, 5.99, 3.0, ./assets/img/01.jpg), ProductEntity(2, product 2, 15.78, 0.0, ./assets/img/02.jpg), ProductEntity(3, product 3, 52.95, 25.5, ./assets/img/03.jpg), ProductEntity(4, product 4, 300.0, 0.0, ./assets/img/04.jpg), ProductEntity(5, product 5, 80.5, 0.0, ./assets/img/05.jpg), ProductEntity(6, product 6, 60.3, 0.0, ./assets/img/06.jpg), ProductEntity(7, product 7, 500.5, 0.0, ./assets/img/07.jpg), ProductEntity(7, product 8, 500.5, 0.0, ./assets/img/08.jpg), ProductEntity(7, product 9, 500.5, 0.0, ./assets/img/09.jpg), ProductEntity(7, product 10, 500.5, 0.0, ./assets/img/10.jpg), ProductEntity(7, product 11, 500.5, 0.0, ./assets/img/11.jpg), ProductEntity(7, product 12, 500.5, 0.0, ./assets/img/12.jpg)])>
Actual: Right<Failure, List<ProductEntity>>:<Right([ProductEntity(1, product 1, 5.99, 3.0, ./assets/img/01.jpg), ProductEntity(2, product 2, 15.78, 0.0, ./assets/img/02.jpg), ProductEntity(3, product 3, 52.95, 25.5, ./assets/img/03.jpg), ProductEntity(4, product 4, 300.0, 0.0, ./assets/img/04.jpg), ProductEntity(5, product 5, 80.5, 0.0, ./assets/img/05.jpg), ProductEntity(6, product 6, 60.3, 0.0, ./assets/img/06.jpg), ProductEntity(7, product 7, 500.5, 0.0, ./assets/img/07.jpg), ProductEntity(7, product 8, 500.5, 0.0, ./assets/img/08.jpg), ProductEntity(7, product 9, 500.5, 0.0, ./assets/img/09.jpg), ProductEntity(7, product 10, 500.5, 0.0, ./assets/img/10.jpg), ProductEntity(7, product 11, 500.5, 0.0, ./assets/img/11.jpg), ProductEntity(7, product 12, 500.5, 0.0, ./assets/img/12.jpg)])>
 */
