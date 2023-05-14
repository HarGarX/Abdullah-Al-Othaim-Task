import 'package:abdullah_al_othaim_task/src/core/platform/network_info.dart';
import 'package:abdullah_al_othaim_task/src/features/home/data/data_source/local/home_local_data_source.dart';
import 'package:abdullah_al_othaim_task/src/features/home/data/data_source/remote/home_remote_data_source.dart';
import 'package:abdullah_al_othaim_task/src/features/home/data/repository/home_repository_impl.dart';
import 'package:abdullah_al_othaim_task/src/features/home/domain/repository/home_repository.dart';
import 'package:abdullah_al_othaim_task/src/features/home/domain/use_cases/fetch_products_use_case.dart';
import 'package:abdullah_al_othaim_task/src/features/home/domain/use_cases/update_data_in_local_use_case.dart';
import 'package:abdullah_al_othaim_task/src/features/home/presentation/bloc/home_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';

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
    () => HomeBloc(
      fetchProductsUseCase: locator(),
      updateDataInLocalUseCase: locator(),
    ),
  );

  ///
  /// Use Cases
  ///
  locator.registerFactory<FetchProductsUseCase>(
    () => FetchProductsUseCase(
      homeRepository: locator(),
    ),
  );
  locator.registerFactory<UpdateDataInLocalUseCase>(
    () => UpdateDataInLocalUseCase(
      homeRepository: locator(),
    ),
  );

  ///
  /// Repositories
  ///
  locator.registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl(
        remoteDataSource: locator(),
        localDataSource: locator(),
        networkInfo: locator(),
        flutterSecureStorage: locator(),
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
    () => HomeLocalDataSourceImpl(
      flutterSecureStorage: locator(),
    ),
  );

  //TODO: add the network info impl.
  locator.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(locator()));

  locator.registerLazySingleton<http.Client>(() => http.Client());
  locator.registerLazySingleton<ApiClient>(() => ApiClient(locator()));

  //! External
  locator.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );
  locator.registerLazySingleton<InternetConnectionChecker>(() => InternetConnectionChecker());
}
