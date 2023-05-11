import 'dart:convert';

import 'package:abdullah_al_othaim_task/src/features/home/data/models/fetch_products_response_model.dart';
import 'package:abdullah_al_othaim_task/src/features/home/domain/entites/product_entity.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tFetchProductsResponseModel = FetchProductsResponseModel.fromJson(jsonDecode(fixture('data.json')));
  final tProductModelResponse = tFetchProductsResponseModel.data!;
  group('fromJson', () {
    test(
      'should return a valid model when the JSON data is received',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap = jsonDecode(fixture('data.json'));
        // act
        final result = FetchProductsResponseModel.fromJson(jsonMap);
        // assert
        expect(result, isA<FetchProductsResponseModel>());
      },
    );
  });
  group('toJson', () {
    test(
      'should return a JSON map containing the proper data',
      () async {
        // act
        final result = tFetchProductsResponseModel.toJson();
        // assert
        final expectedJsonMap = {
          "categoryDesc": "Lorem Ipsum",
          "total": 12,
          "imagePlaceholder": "./assets/img/placeholder.jpg",
          "data": [
            {"sku": 1, "desc": "product 1", "regularPrice": 5.99, "salePrice": 3, "imageUrl": "./assets/img/01.jpg"},
            {"sku": 2, "desc": "product 2", "regularPrice": 15.78, "salePrice": 0, "imageUrl": "./assets/img/02.jpg"},
            {
              "sku": 3,
              "desc": "product 3",
              "regularPrice": 52.95,
              "salePrice": 25.5,
              "imageUrl": "./assets/img/03.jpg"
            },
            {"sku": 4, "desc": "product 4", "regularPrice": 300, "salePrice": 0, "imageUrl": "./assets/img/04.jpg"},
            {"sku": 5, "desc": "product 5", "regularPrice": 80.5, "salePrice": 0, "imageUrl": "./assets/img/05.jpg"},
            {"sku": 6, "desc": "product 6", "regularPrice": 60.3, "salePrice": 0, "imageUrl": "./assets/img/06.jpg"},
            {"sku": 7, "desc": "product 7", "regularPrice": 500.5, "salePrice": 0, "imageUrl": "./assets/img/07.jpg"},
            {"sku": 7, "desc": "product 8", "regularPrice": 500.5, "salePrice": 0, "imageUrl": "./assets/img/08.jpg"},
            {"sku": 7, "desc": "product 9", "regularPrice": 500.5, "salePrice": 0, "imageUrl": "./assets/img/09.jpg"},
            {"sku": 7, "desc": "product 10", "regularPrice": 500.5, "salePrice": 0, "imageUrl": "./assets/img/10.jpg"},
            {"sku": 7, "desc": "product 11", "regularPrice": 500.5, "salePrice": 0, "imageUrl": "./assets/img/11.jpg"},
            {"sku": 7, "desc": "product 12", "regularPrice": 500.5, "salePrice": 0, "imageUrl": "./assets/img/12.jpg"}
          ]
        };
        expect(result, expectedJsonMap);
      },
    );
  });
  group('validateProduct', () {
    test(
      'the product on the fetch products List response should be a subclass of Product entity',
      () async {
        // assert
        expect(tProductModelResponse, isA<List<ProductEntity>>());
      },
    );
    for (var product in tProductModelResponse) {
      test(
        'each product prises are formated correctly',
        () async {
          // assert

          final result = product;
          expect(result.salePrice, isA<num>());
          expect(result.regularPrice, isA<num>());

          // expect(tProductModelResponse, isA<List<ProductEntity>>());
        },
      );
    }
  });
}
