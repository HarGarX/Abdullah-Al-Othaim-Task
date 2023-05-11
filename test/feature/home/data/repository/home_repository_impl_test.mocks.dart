// Mocks generated by Mockito 5.4.0 from annotations
// in abdullah_al_othaim_task/test/feature/home/data/repository/home_repository_impl_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:abdullah_al_othaim_task/src/core/platform/network_info.dart'
    as _i6;
import 'package:abdullah_al_othaim_task/src/features/home/data/data_source/local/home_local_data_source.dart'
    as _i5;
import 'package:abdullah_al_othaim_task/src/features/home/data/data_source/remote/home_remote_data_source.dart'
    as _i3;
import 'package:abdullah_al_othaim_task/src/features/home/data/models/fetch_products_response_model.dart'
    as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeFetchProductsResponseModel_0 extends _i1.SmartFake
    implements _i2.FetchProductsResponseModel {
  _FakeFetchProductsResponseModel_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [HomeRemoteDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockHomeRemoteDataSource extends _i1.Mock
    implements _i3.HomeRemoteDataSource {
  MockHomeRemoteDataSource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.FetchProductsResponseModel> fetchProducts() =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchProducts,
          [],
        ),
        returnValue: _i4.Future<_i2.FetchProductsResponseModel>.value(
            _FakeFetchProductsResponseModel_0(
          this,
          Invocation.method(
            #fetchProducts,
            [],
          ),
        )),
      ) as _i4.Future<_i2.FetchProductsResponseModel>);
}

/// A class which mocks [HomeLocalDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockHomeLocalDataSource extends _i1.Mock
    implements _i5.HomeLocalDataSource {
  MockHomeLocalDataSource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.FetchProductsResponseModel> fetchProducts() =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchProducts,
          [],
        ),
        returnValue: _i4.Future<_i2.FetchProductsResponseModel>.value(
            _FakeFetchProductsResponseModel_0(
          this,
          Invocation.method(
            #fetchProducts,
            [],
          ),
        )),
      ) as _i4.Future<_i2.FetchProductsResponseModel>);
  @override
  _i4.Future<void> cacheData({required _i2.FetchProductsResponseModel? data}) =>
      (super.noSuchMethod(
        Invocation.method(
          #cacheData,
          [],
          {#data: data},
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
}

/// A class which mocks [NetworkInfo].
///
/// See the documentation for Mockito's code generation for more information.
class MockNetworkInfo extends _i1.Mock implements _i6.NetworkInfo {
  MockNetworkInfo() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<bool> get isConnected => (super.noSuchMethod(
        Invocation.getter(#isConnected),
        returnValue: _i4.Future<bool>.value(false),
      ) as _i4.Future<bool>);
}