import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:abdullah_al_othaim_task/src/core/api_client/api_clinet.dart';
import 'package:abdullah_al_othaim_task/src/core/errors/exceptions.dart';
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
      final rawData = await _apiClient.readData('assets/data.json');
      final data = FetchProductsResponseModel.fromJson(jsonDecode(rawData));

      // if (data.data!.isNotEmpty) {
      return data;
      // }
      // throw const ServerException(errorMessage: 'server error');
    } on PathNotFoundException {
      rethrow;
    } on TimeoutException {
      rethrow;
    } on SocketException {
      rethrow;
    } catch (e) {
      throw ServerException(errorMessage: e.toString());
    }
  }
}
