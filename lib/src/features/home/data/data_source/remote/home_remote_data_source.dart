import 'dart:convert';

import 'package:abdullah_al_othaim_task/src/core/api_client/api_clinet.dart';
import 'package:abdullah_al_othaim_task/src/core/errors/failures.dart';
import 'package:abdullah_al_othaim_task/src/features/home/data/models/fetch_products_response_model.dart';

abstract class HomeRemoteDataSource {
  Future<FetchProductsResponseModel> fetchProducts();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final ApiClient _apiClient;

  HomeRemoteDataSourceImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<FetchProductsResponseModel> fetchProducts() async {
    try {
      final rawData = _apiClient.readData('data.json');
      final data = FetchProductsResponseModel.fromJson(jsonDecode(rawData));
      return data;
    } catch (e) {
      throw ServerFailure(errorMessage: e.toString());
    }
  }
}
