import 'dart:convert';

import 'package:abdullah_al_othaim_task/src/core/errors/exceptions.dart';
import 'package:abdullah_al_othaim_task/src/core/errors/failures.dart';
import 'package:abdullah_al_othaim_task/src/core/platform/network_info.dart';
import 'package:abdullah_al_othaim_task/src/features/home/data/data_source/local/home_local_data_source.dart';
import 'package:abdullah_al_othaim_task/src/features/home/data/data_source/remote/home_remote_data_source.dart';
import 'package:abdullah_al_othaim_task/src/features/home/data/models/fetch_products_response_model.dart';
import 'package:abdullah_al_othaim_task/src/features/home/data/repository/home_repository_impl.dart';
import 'package:abdullah_al_othaim_task/src/features/home/domain/entites/product_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'home_repository_impl_test.mocks.dart';

@GenerateMocks([HomeRemoteDataSource, HomeLocalDataSource, NetworkInfo])
void main() {
  late final HomeRepositoryImpl repository;
  late final MockHomeRemoteDataSource mockRemoteDataSource;
  late final MockHomeLocalDataSource mockLocalDataSource;
  late final MockNetworkInfo mockNetworkInfo;

  // mockRemoteDataSource = MockHomeRemoteDataSource();
  // mockLocalDataSource = MockHomeLocalDataSource();
  // mockNetworkInfo = MockNetworkInfo();
  // repository = MockHomeRepositoryImpl(
  //     // remoteDataSource: mockRemoteDataSource,
  //     // localDataSource: mockLocalDataSource,
  //     // networkInfo: mockNetworkInfo,
  //     );
  setUpAll(() {
    mockRemoteDataSource = MockHomeRemoteDataSource();
    mockLocalDataSource = MockHomeLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = HomeRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });
  group('fetchProducts', () {
    // DATA FOR THE MOCKS AND ASSERTIONS
    // We'll use these three variables throughout all the tests

    final tFetchProductsResponseModel = FetchProductsResponseModel.fromJson(jsonDecode(fixture('data.json')));
    final tProductsList = productsEntityFromJson(jsonEncode(tFetchProductsResponseModel.toJson()['data']));

    test('should check if the device is online', () async {
      //arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      //act
      await repository.fetchProducts();
      //assert
      verify(mockNetworkInfo.isConnected);
    });
  });

  group('device is online', () {
    // This setUp applies only to the 'device is online' group
    setUp(() {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    });

    test(
      'should return remote data when the call to remote data source is successful',
      () async {
        final FetchProductsResponseModel tFetchProductsResponseModel =
            FetchProductsResponseModel.fromJson(jsonDecode(fixture('data.json')));
        final List<ProductEntity> tProductsList =
            productsEntityFromJson(jsonEncode(tFetchProductsResponseModel.toJson()['data']));
        //arrange
        when(mockRemoteDataSource.fetchProducts()).thenAnswer((_) async => tFetchProductsResponseModel);
        //act
        final result = (await repository.fetchProducts()).fold(
          (failure) => failure,
          (response) => response,
        );
        //assert
        verify(mockRemoteDataSource.fetchProducts());
        expect(result, equals(tProductsList));
      },
    );

    test(
      'should cache the data locally when the call to remote data source is successful',
      () async {
        final FetchProductsResponseModel tFetchProductsResponseModel =
            FetchProductsResponseModel.fromJson(jsonDecode(fixture('data.json')));
        final List<ProductEntity> tProductsList =
            productsEntityFromJson(jsonEncode(tFetchProductsResponseModel.toJson()['data']));
        // arrange
        when(mockRemoteDataSource.fetchProducts()).thenAnswer((_) async => tFetchProductsResponseModel);
        // act
        final result = (await repository.fetchProducts()).fold(
          (failure) => failure,
          (response) => response,
        );
        // assert
        verify(mockRemoteDataSource.fetchProducts());
        verify(mockLocalDataSource.cacheData(data: tFetchProductsResponseModel));
      },
    );

    test(
      'should return server failure when the call to remote data source is unsuccessful',
      () async {
        // arrange
        when(mockRemoteDataSource.fetchProducts()).thenThrow(const ServerException(errorMessage: 'error'));
        // act
        final result = (await repository.fetchProducts()).fold(
          (failure) => failure,
          (response) => response,
        );
        // assert
        verify(mockRemoteDataSource.fetchProducts());
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(const ServerException(errorMessage: 'error')));
      },
    );
  });

  group('device is offline', () {
    setUp(() {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
    });

    test(
      'should return last locally cached data when the cached data is present',
      () async {
        final FetchProductsResponseModel tFetchProductsResponseModel =
            FetchProductsResponseModel.fromJson(jsonDecode(fixture('data.json')));
        final List<ProductEntity> tProductsList =
            productsEntityFromJson(jsonEncode(tFetchProductsResponseModel.toJson()['data']));
        // arrange
        when(mockLocalDataSource.fetchProducts()).thenAnswer((_) async => tFetchProductsResponseModel);
        // act
        final result = (await repository.fetchProducts()).fold(
          (failure) => failure,
          (response) => response,
        );
        // assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.fetchProducts());
        expect(result, equals(tProductsList));
      },
    );

    test(
      'should return CacheFailure when there is no cached data present',
      () async {
        // arrange
        when(mockLocalDataSource.fetchProducts()).thenThrow(const CacheException(errorMessage: 'no data in cache'));
        // act
        final result = (await repository.fetchProducts()).fold(
          (failure) => failure,
          (response) => response,
        );
        // assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.fetchProducts());
        expect(result, equals(const CacheFailure(errorMessage: 'no data in cache')));
      },
    );
  });
}
