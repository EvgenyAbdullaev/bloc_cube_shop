import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shop_api/shop_api.dart';

class LoadListRequestFailure implements Exception {}
class LoadListNotFoundFailure implements Exception {}

class ShopApiClient {
  ShopApiClient({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  static const _baseUrl = 'jsonplaceholder.typicode.com';
  static const _apiPath = '/photos';
  static const _loadLimit = 20;

  int get loadingLimit => _loadLimit;

  final http.Client _httpClient;

  /// Load from fake json gen
  Future<List<Product>> loadList([int start = 0]) async {
    final shopListRequest = Uri.https(
      _baseUrl,
      _apiPath,
      <String, String>{'_start': '$start', '_limit': '$_loadLimit'},
    );
    final shopListResponse = await _httpClient.get(shopListRequest);

    if (shopListResponse.statusCode != 200) {
      throw LoadListRequestFailure();
    }

    final listJson = jsonDecode(
      shopListResponse.body,
    ) as List;

    if (listJson.isEmpty) {
      throw LoadListNotFoundFailure();
    }

    return listJson.map((dynamic json) {
      return Product(
        id: json['id'] as int,
        title: json['title'] as String,
        url: json['url'] as String,
      );
    }).toList();
  }
}