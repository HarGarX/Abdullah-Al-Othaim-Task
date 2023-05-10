import 'package:abdullah_al_othaim_task/src/core/api_client/api_clinet.dart';

abstract class HomeRemoteDataSource {}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final ApiClient _apiClient;

  HomeRemoteDataSourceImpl({required ApiClient apiClient}) : _apiClient = apiClient;
}
