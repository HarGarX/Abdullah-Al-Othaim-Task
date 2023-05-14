import 'dart:convert';

import 'package:abdullah_al_othaim_task/src/core/constants/secure_storage_consts.dart';
import 'package:abdullah_al_othaim_task/src/core/errors/exceptions.dart';
import 'package:abdullah_al_othaim_task/src/core/errors/failures.dart';
import 'package:abdullah_al_othaim_task/src/core/platform/network_info.dart';
import 'package:abdullah_al_othaim_task/src/features/home/data/data_source/local/home_local_data_source.dart';
import 'package:abdullah_al_othaim_task/src/features/home/data/data_source/remote/home_remote_data_source.dart';
import 'package:abdullah_al_othaim_task/src/features/home/data/models/fetch_products_response_model.dart';
import 'package:abdullah_al_othaim_task/src/features/home/data/repository/home_repository_impl.dart';
import 'package:abdullah_al_othaim_task/src/features/home/domain/entites/product_entity.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'home_repository_impl_test.mocks.dart';

@GenerateMocks([HomeRemoteDataSource, HomeLocalDataSource, NetworkInfo, FlutterSecureStorage])
void main() {
  late HomeRepositoryImpl repository;
  late MockHomeRemoteDataSource mockHomeRemoteDataSource;
  late MockHomeLocalDataSource mockHomeLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;
  late MockFlutterSecureStorage mockFlutterSecureStorage;

  final tFetchProductsResponseModel = FetchProductsResponseModel.fromJson(jsonDecode(fixture('data.json')));
  final List<ProductEntity> tProductsList =
      productsEntityFromJson(jsonEncode(tFetchProductsResponseModel.toJson()['data']));
  mockHomeRemoteDataSource = MockHomeRemoteDataSource();
  mockHomeLocalDataSource = MockHomeLocalDataSource();
  mockNetworkInfo = MockNetworkInfo();
  mockFlutterSecureStorage = MockFlutterSecureStorage();
  repository = HomeRepositoryImpl(
    remoteDataSource: mockHomeRemoteDataSource,
    localDataSource: mockHomeLocalDataSource,
    networkInfo: mockNetworkInfo,
    flutterSecureStorage: mockFlutterSecureStorage,
  );

  test('should check if the device is online', () async {
    //arrange
    when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    when(mockHomeRemoteDataSource.fetchProducts()).thenAnswer((_) async => Future.value(tFetchProductsResponseModel));
    when(mockFlutterSecureStorage.read(key: SecureStorageConstants.NOT_FIRST_FETCH))
        .thenAnswer((realInvocation) async => 'false');
    when(mockFlutterSecureStorage.write(key: SecureStorageConstants.NOT_FIRST_FETCH, value: 'true'))
        .thenAnswer((realInvocation) async => null);
    //act
    await repository.fetchProducts();
    //assert
    verify(mockNetworkInfo.isConnected);
  });

  group('device is online', () {
    test(
      'should return remote data when the call to remote data source is successful',
      () async {
        //arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(mockHomeRemoteDataSource.fetchProducts())
            .thenAnswer((_) async => Future.value(tFetchProductsResponseModel));
        when(mockHomeLocalDataSource.cacheData(data: tFetchProductsResponseModel)).thenAnswer((_) async => {});
        when(mockFlutterSecureStorage.read(key: SecureStorageConstants.NOT_FIRST_FETCH))
            .thenAnswer((_) async => 'false');
        when(mockFlutterSecureStorage.write(key: SecureStorageConstants.NOT_FIRST_FETCH, value: 'true'))
            .thenAnswer((_) async => null);
        //act
        final result = (await repository.fetchProducts()).fold(
          (failure) => failure,
          (response) => response,
        );
        //assert
        verify(mockHomeRemoteDataSource.fetchProducts());
        expect(result, equals(tProductsList));
        reset(mockHomeRemoteDataSource);
        reset(mockHomeLocalDataSource);
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
        when(mockHomeRemoteDataSource.fetchProducts()).thenAnswer((_) async => tFetchProductsResponseModel);
        // act
        final result = (await repository.fetchProducts()).fold(
          (failure) => failure,
          (response) => response,
        );
        // assert
        verify(mockHomeRemoteDataSource.fetchProducts());
        verify(mockHomeLocalDataSource.cacheData(data: tFetchProductsResponseModel));
        reset(mockHomeRemoteDataSource);
        reset(mockHomeLocalDataSource);
      },
    );

    test(
      'should return server failure when the call to remote data source is unsuccessful',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(mockFlutterSecureStorage.read(key: SecureStorageConstants.NOT_FIRST_FETCH))
            .thenAnswer((_) async => 'false');
        when(mockHomeRemoteDataSource.fetchProducts())
            .thenAnswer((_) async => throw const ServerException(errorMessage: 'server error'));
        // act
        final result = (await repository.fetchProducts()).fold(
          (failure) => failure,
          (response) => response,
        );
        // assert
        verify(mockHomeRemoteDataSource.fetchProducts());
        verifyZeroInteractions(mockHomeLocalDataSource);
        expect(result, ServerFailure(errorMessage: 'server error'));
        reset(mockHomeRemoteDataSource);
        reset(mockHomeLocalDataSource);
      },
    );
  });

  group('device is offline', () {
    test(
      'should return last locally cached data when the cached data is present',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        when(mockFlutterSecureStorage.read(key: SecureStorageConstants.NOT_FIRST_FETCH))
            .thenAnswer((realInvocation) async => 'true');
        when(mockHomeLocalDataSource.fetchProducts()).thenAnswer((_) async => tFetchProductsResponseModel);
        // act
        final result = (await repository.fetchProducts()).fold(
          (failure) => failure,
          (response) => response,
        );
        // assert
        verifyZeroInteractions(mockHomeRemoteDataSource);
        verify(mockHomeLocalDataSource.fetchProducts());
        expect(result, equals(tProductsList));
        reset(mockHomeRemoteDataSource);
        reset(mockHomeLocalDataSource);
      },
    );

    test(
      'should return CacheFailure when there is no cached data present',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        when(mockFlutterSecureStorage.read(key: SecureStorageConstants.NOT_FIRST_FETCH))
            .thenAnswer((realInvocation) async => 'true');
        when(mockHomeLocalDataSource.fetchProducts())
            .thenAnswer((_) async => throw const CacheException(errorMessage: 'no data in cache'));
        // act
        final result = (await repository.fetchProducts()).fold(
          (failure) => failure,
          (response) => response,
        );
        // assert
        verifyZeroInteractions(mockHomeRemoteDataSource);
        verify(mockHomeLocalDataSource.fetchProducts());
        expect(result, const CacheFailure(errorMessage: 'no data in cache'));
        reset(mockHomeRemoteDataSource);
        reset(mockHomeLocalDataSource);
      },
    );
  });
}
