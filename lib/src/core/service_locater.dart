import 'package:abdullah_al_othaim_task/src/core/hive/hive_services.dart';
import 'package:abdullah_al_othaim_task/src/features/home/data/data_source/local/home_local_data_source.dart';
import 'package:abdullah_al_othaim_task/src/features/home/data/data_source/remote/home_remote_data_source.dart';
import 'package:abdullah_al_othaim_task/src/features/home/data/repository/home_repository_impl.dart';
import 'package:abdullah_al_othaim_task/src/features/home/domain/repository/home_repository.dart';
import 'package:abdullah_al_othaim_task/src/features/home/domain/use_cases/fetch_products_use_case.dart';
import 'package:abdullah_al_othaim_task/src/features/home/presentation/bloc/home_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'api_client/api_clinet.dart';

GetIt locator = GetIt.instance;

Future<void> setUpLocator() async {
  ///********************** Home Feature Starts **********************///
  ///
  /// Blocs
  ///
  /*
  * Home Bloc
  */
  locator.registerFactory<HomeBloc>(
    () => HomeBloc(fetchProductsUseCase: locator()),
  );

  ///
  /// Use Cases
  ///
  locator.registerFactory<FetchProductsUseCase>(
    () => FetchProductsUseCase(
      homeRepository: locator(),
    ),
  );

  ///
  /// Repositories
  ///
  locator.registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl(
        remoteDataSource: locator(),
        localDataSource: locator(),
      ));

  ///
  /// Data Sources [Remote & Local]
  ///
  locator.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(
      apiClient: locator(),
    ),
  );
  locator.registerLazySingleton<HomeLocalDataSource>(
    () => HomeLocalDataSourceImpl(),
  );

  locator.registerLazySingleton<http.Client>(() => http.Client());
  locator.registerLazySingleton<ApiClient>(() => ApiClient(locator()));

  //! External
  locator.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );
  locator.registerLazySingleton<HiveService>(() => HiveService());
}
