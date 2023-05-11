import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../constants/error_consts.dart';
import '../constants/secure_storage_consts.dart';
import '../errors/exceptions.dart';
import '../service_locater.dart';

class ApiClient {
  final http.Client client;
  final String apiUrl = '';

  ApiClient(this.client);

  String readData(String name) => File('assets/data/$name').readAsStringSync();

  /// Return the header without the stored JWT Token.
  Future<Map<String, String>> _getHeaders() async {
    DateTime now = DateTime.now();
    String date = DateFormat('yyyy-MM-dd').format(now);
    Map<String, String> headers = <String, String>{
      "Cache-Control": "no-cache",
      "Content-Type": "application/json",
      "x-api-key": "",
      "x-request-date": date,
      "x-request-timestamp": "",
      "x-request-timezone": "",
    };
    return headers;
  }

  /// Return the header with the stored JWT Token.
  Future<Map<String, String>> _getHeadersWithAuth({required String tokenTypeStorageKey}) async {
    final secureStorage = locator<FlutterSecureStorage>();
    String? token = await secureStorage.read(key: tokenTypeStorageKey);
    log(tokenTypeStorageKey, name: "this is token name");
    log(token!, name: "this is token value");
    Map<String, String> headers = await _getHeaders();
    headers["Authorization"] = 'Bearer $token';
    return headers;
  }

  Future<dynamic> get(String endpoint,
      {bool withAuth = false, bool isItAccountAuth = false, bool forceRefreshCache = false}) async {
    try {
      Map<String, String> headers;
      if (withAuth) {
        headers = await _getHeadersWithAuth(
            tokenTypeStorageKey:
                isItAccountAuth == false ? SecureStorageConstants.ACCOUNT_TOKEN : SecureStorageConstants.TOKEN);
      } else {
        headers = await _getHeaders();
      }

      final response = await client.get(Uri.parse('$apiUrl$endpoint'), headers: headers);

      if (response.body.isNotEmpty) {
        if (response.statusCode != 200) {
          final responseBody = json.decode(response.body);
          if (responseBody == null) throw const ServerException(errorMessage: ErrorConst.UNKNOWN_ERROR);
          throw ServerException(errorMessage: responseBody['message']);
        }

        String body = jsonEncode(response.body);

        Map<String, dynamic> responseBody = jsonDecode(body);
        if (responseBody['code'] != null || responseBody['message'] != null) {
          log(responseBody['code'], name: "GET REQUEST HAD ERROR WITH CODE => POST => API CLIENT");
          log(responseBody['message'], name: "GET REQUEST HAD ERROR WITH CODE => POST => API CLIENT");
          throw ServerException(errorMessage: responseBody['message']);
        }

        return responseBody;
      }
      throw const ServerException(errorMessage: ErrorConst.UNKNOWN_ERROR);
    } on ServerException {
      rethrow;
    } on TimeoutException {
      rethrow;
    } on SocketException {
      throw const NoInternetException(
        errorMessage: ErrorConst.NO_INTERNET_MESSAGE,
      );
    } catch (e) {
      throw ServerException(errorMessage: e.toString());
    }
  }

  Future<dynamic> post(String endpoint, dynamic model,
      {bool withAuth = false, isItAccountAuth = false, bool forceRefreshCache = false}) async {
    try {
      Map<String, String> headers;
      if (withAuth) {
        headers = await _getHeadersWithAuth(
            tokenTypeStorageKey: isItAccountAuth ? SecureStorageConstants.ACCOUNT_TOKEN : SecureStorageConstants.TOKEN);
      } else {
        headers = await _getHeaders();
      }

      log("${Uri.parse('$apiUrl$endpoint')}", name: "POST REQUEST URI  => POST() => API CLIENT");
      log("${headers}", name: 'APICLINET => POST METHOD => HEADERS ');

      final response = await client
          .post(
            Uri.parse('$apiUrl$endpoint'),
            headers: headers,
            body: json.encode(
              model.toJson(),
            ),
          )
          .timeout(const Duration(seconds: 20));
      if (response.body.isNotEmpty) {
        if (response.statusCode != 200) {
          final responseBody = json.decode(response.body);
          if (responseBody == null) throw const ServerException(errorMessage: ErrorConst.UNKNOWN_ERROR);
          throw ServerException(errorMessage: responseBody['message']);
        }
        log("${response.statusCode}", name: "POST REQUEST  STATUS CODE => Post() => API CLIENT");
        // log("${response.body}" , name: "SUCCESS POST RESPONSE BODY => Post() => API CLIENT");
        Map<String, dynamic> responseBody = jsonDecode(jsonEncode(response.body));
        if (responseBody['code'] != null || responseBody['message'] != null) {
          log(responseBody['code'], name: "POST REQUEST HAD ERROR WITH CODE => POST => APICLIENT");
          log(responseBody['message'], name: "POST REQUEST HAD ERROR WITH CODE => POST => APICLIENT");
          throw ServerException(errorMessage: responseBody['message']);
        }

        return responseBody;
      }
      throw const ServerException(errorMessage: ErrorConst.UNKNOWN_ERROR);
    } on TimeoutException {
      rethrow;
    } on SocketException {
      throw const NoInternetException(errorMessage: ErrorConst.NO_INTERNET_MESSAGE);
    } catch (e) {
      throw ServerException(errorMessage: e.toString());
    }
  }

  Future<dynamic> delete(String endpoint, {bool withAuth = false, isItAccountAuth = false}) async {
    try {
      Map<String, String> headers;
      if (withAuth) {
        headers = await _getHeadersWithAuth(
            tokenTypeStorageKey: isItAccountAuth ? SecureStorageConstants.ACCOUNT_TOKEN : SecureStorageConstants.TOKEN);
      } else {
        headers = await _getHeaders();
      }

      log("${Uri.parse('$endpoint')}", name: "DELETE REQUEST URL  => DELETE() => API CLIENT");

      final response = await client
          .delete(
            Uri.parse('$apiUrl$endpoint'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 20));
      if (response.body.isNotEmpty) {
        if (response.statusCode != 200) {
          final responseBody = (response.body);
          if (responseBody == null) throw const ServerException(errorMessage: ErrorConst.UNKNOWN_ERROR);
          throw ServerException(errorMessage: jsonDecode(responseBody)['message']);
        }
        log("${response.statusCode}", name: "DELETE REQUEST  STATUS CODE => Post() => API CLIENT");
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        if (responseBody['code'] != null || responseBody['message'] != null) {
          log(responseBody['code'], name: "DELETE REQUEST HAD ERROR WITH CODE => DELETE => APICLIENT");
          log(responseBody['message'], name: "DELETE REQUEST HAD ERROR WITH CODE => DELETE => APICLIENT");
          throw ServerException(errorMessage: responseBody['message']);
        }

        return responseBody;
      }
      throw const ServerException(errorMessage: ErrorConst.UNKNOWN_ERROR);
    } on TimeoutException {
      rethrow;
    } on SocketException {
      throw const NoInternetException(errorMessage: ErrorConst.NO_INTERNET_MESSAGE);
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> put(String endpoint, dynamic model, {bool withAuth = false, isItAccountAuth = false}) async {
    try {
      Map<String, String> headers;
      if (withAuth) {
        headers = await _getHeadersWithAuth(
            tokenTypeStorageKey: isItAccountAuth ? SecureStorageConstants.ACCOUNT_TOKEN : SecureStorageConstants.TOKEN);
      } else {
        headers = await _getHeaders();
      }

      final response = await client
          .put(
            Uri.parse('$apiUrl$endpoint'),
            headers: headers,
            body: json.encode(
              model.toJson(),
            ),
          )
          .timeout(const Duration(seconds: 20));
      if (response.body.isNotEmpty) {
        if (response.statusCode != 200) {
          final responseBody = json.decode(response.body);
          if (responseBody == null) throw const ServerException(errorMessage: ErrorConst.UNKNOWN_ERROR);
          throw ServerException(errorMessage: responseBody['message']);
        }

        Map<String, dynamic> responseBody = jsonDecode(response.body);
        if (responseBody['code'] != null || responseBody['message'] != null) {
          throw ServerException(errorMessage: responseBody['message']);
        }

        return responseBody;
      }
      throw const ServerException(errorMessage: ErrorConst.UNKNOWN_ERROR);
    } on TimeoutException {
      rethrow;
    } on SocketException {
      throw const NoInternetException(errorMessage: ErrorConst.NO_INTERNET_MESSAGE);
    } catch (e) {
      throw ServerException(errorMessage: e.toString());
    }
  }
}
