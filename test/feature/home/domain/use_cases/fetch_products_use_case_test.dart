import 'package:abdullah_al_othaim_task/src/core/use_cases/usecase.dart';
import 'package:abdullah_al_othaim_task/src/features/home/domain/entites/product_entity.dart';
import 'package:abdullah_al_othaim_task/src/features/home/domain/repository/home_repository.dart';
import 'package:abdullah_al_othaim_task/src/features/home/domain/use_cases/fetch_products_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'fetch_products_use_case_test.mocks.dart';

// class MockHomeRepository extends Mock implements HomeRepository {}

@GenerateMocks([HomeRepository])
void main() {
  FetchProductsUseCase useCase;
  MockHomeRepository mockHomeRepository;

  // setUp(() {
  mockHomeRepository = MockHomeRepository();
  useCase = FetchProductsUseCase(homeRepository: mockHomeRepository);
  // });
  final tParams = NoParams();
  final tProductsList = [
    ProductEntity(sku: 1, desc: 'description', regularPrice: 10.0, salePrice: 8.0, imageUrl: 'image/url'),
    ProductEntity(sku: 2, desc: 'description2', regularPrice: 20.0, salePrice: 16.0, imageUrl: 'image2/url'),
  ];

  test('should get products List from the home repository', () async {
    when(mockHomeRepository.fetchProducts()).thenAnswer((_) async => Right(tProductsList));
    final result = await useCase(tParams);

    expect(result, Right(tProductsList));
    verify(mockHomeRepository.fetchProducts());
    verifyNoMoreInteractions(mockHomeRepository);
  });
}
