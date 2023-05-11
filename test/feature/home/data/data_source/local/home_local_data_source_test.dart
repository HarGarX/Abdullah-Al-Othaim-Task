import 'dart:convert';

import 'package:abdullah_al_othaim_task/src/core/errors/exceptions.dart';
import 'package:abdullah_al_othaim_task/src/features/home/data/data_source/local/home_local_data_source.dart';
import 'package:abdullah_al_othaim_task/src/features/home/data/models/fetch_products_response_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../../fixtures/fixture_reader.dart';
import 'home_local_data_source_test.mocks.dart';

@GenerateMocks([FlutterSecureStorage])
void main() {
  late final HomeLocalDataSourceImpl dataSource;
  late final MockFlutterSecureStorage mockLocalStorage;

  setUpAll(() {
    mockLocalStorage = MockFlutterSecureStorage();
    dataSource = HomeLocalDataSourceImpl(flutterSecureStorage: mockLocalStorage);
  });

  group('getDataFromLocalStorage', () {
    final tFetchProductsResponseModel = FetchProductsResponseModel.fromJson(jsonDecode(fixture('data.json')));

    test(
      'should return NumberTrivia from SharedPreferences when there is one in the cache',
      () async {
        // arrange
        when(mockLocalStorage.read(key: 'local-data')).thenAnswer((_) => Future.value(fixture('data.json')));
        // act
        final result = await dataSource.fetchProducts();
        // assert
        verify(mockLocalStorage.read(key: 'local-data'));
        expect(result, equals(tFetchProductsResponseModel));
      },
    );

    test('should throw a CacheException when there is not a cached value', () {
      // arrange
      when(mockLocalStorage.read(key: 'local-data')).thenAnswer((_) => Future.value(null));
      // act
      final call = dataSource.fetchProducts();
      // assert

      expect(() => call, throwsA(TypeMatcher<CacheException>()));
    });
  });

  group('setDataToLocalStorage', () {
    final tFetchProductsResponseModel = FetchProductsResponseModel.fromJson(jsonDecode(fixture('data.json')));

    test('should call Flutter secure storage to cache the data', () {
      // act
      dataSource.cacheData(data: tFetchProductsResponseModel);
      // assert
      final expectedJsonString = json.encode(tFetchProductsResponseModel.toJson());
      verify(mockLocalStorage.write(
        key: 'local-data',
        value: expectedJsonString,
      ));
    });
  });
}
