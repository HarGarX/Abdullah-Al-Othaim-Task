import 'package:abdullah_al_othaim_task/src/core/use_cases/usecase.dart';
import 'package:abdullah_al_othaim_task/src/features/home/domain/entites/product_entity.dart';
import 'package:abdullah_al_othaim_task/src/features/home/domain/repository/home_repository.dart';
import 'package:abdullah_al_othaim_task/src/features/home/domain/use_cases/update_data_in_local_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'fetch_products_use_case_test.mocks.dart';

@GenerateMocks([HomeRepository])
void main() {
  UpdateDataInLocalUseCase useCase;
  MockHomeRepository mockHomeRepository;

  // setUp(() {
  mockHomeRepository = MockHomeRepository();
  useCase = UpdateDataInLocalUseCase(homeRepository: mockHomeRepository);
  // });
  final tParams = NoParams();
  final tProductsList = [
    ProductEntity(sku: 1, desc: 'description', regularPrice: 10.0, salePrice: 8.0, imageUrl: 'image/url'),
    ProductEntity(sku: 2, desc: 'description2', regularPrice: 20.0, salePrice: 16.0, imageUrl: 'image2/url'),
  ];

  test('should update products List from the home repository', () async {
    when(mockHomeRepository.updateLocalData()).thenAnswer((_) async => Right(tProductsList));
    final result = await useCase(tParams);

    expect(result, Right(tProductsList));
    verify(mockHomeRepository.updateLocalData());
    verifyNoMoreInteractions(mockHomeRepository);
  });
}
