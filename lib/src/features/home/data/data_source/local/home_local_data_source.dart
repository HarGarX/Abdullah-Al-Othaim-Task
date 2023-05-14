import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:abdullah_al_othaim_task/src/core/constants/secure_storage_consts.dart';
import 'package:abdullah_al_othaim_task/src/core/errors/exceptions.dart';
import 'package:abdullah_al_othaim_task/src/features/home/data/models/fetch_products_response_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class HomeLocalDataSource {
  Future<FetchProductsResponseModel> fetchProducts();
  Future<void> cacheData({required FetchProductsResponseModel data});
}

class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  final FlutterSecureStorage flutterSecureStorage;
  HomeLocalDataSourceImpl({required this.flutterSecureStorage});
  @override
  Future<FetchProductsResponseModel> fetchProducts() async {
    try {
      final jsonString = await flutterSecureStorage.read(key: SecureStorageConstants.LOCAL_DATA);
      // if (jsonString != null) {
      // Future which is immediately completed
      return Future.value(FetchProductsResponseModel.fromJson(jsonDecode(jsonString!)));
      // } else {
      throw const EmptyCacheException(errorMessage: 'no data in cache');
      // }
    } on PathNotFoundException {
      rethrow;
    } on TimeoutException {
      rethrow;
    } on SocketException {
      rethrow;
    } catch (e) {
      throw CacheException(errorMessage: e.toString());
    }
  }

  @override
  Future<void> cacheData({required FetchProductsResponseModel data}) async {
    try {
      return await flutterSecureStorage.write(key: SecureStorageConstants.LOCAL_DATA, value: jsonEncode(data.toJson()));
    } on PathNotFoundException {
      rethrow;
    } on TimeoutException {
      rethrow;
    } on SocketException {
      rethrow;
    } catch (e) {
      throw CacheException(errorMessage: e.toString());
    }
  }
}
