import 'dart:math' as math;

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'package:shop_api/shop_api.dart';
import 'package:shop_repository/shop_repository.dart';

class ShopRepository {
  ShopRepository({ShopApiClient? shopApiClient})
      : _shopApiClient = shopApiClient ?? ShopApiClient();

  final ShopApiClient _shopApiClient;

  late final Box _storage;
  late final Box _settings;

  int _maxLoadedID = 0;
  int get maxLoadedIDTest => _maxLoadedID;    //temp var, del on production

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> init() async {
    var dir = await getApplicationDocumentsDirectory();

    Hive
      ..init(dir.path)
      ..registerAdapter(HiveProductAdapter());

    _storage = await Hive.openBox<HiveProduct>(_storageBox);
    _settings = await Hive.openBox(_settingsBox);
    _maxLoadedID = await _settings.get(_maxIDKey) ?? 0;

    return Future.value();
  }

  Iterable<HiveProduct> get data {
    if (_storage.isNotEmpty) {
      return _storage.values as Iterable<HiveProduct>;
    } else {
      return [];
    }
  }

  Future<void> loadData() async {
    if (_isLoading) return Future.value();

    _isLoading = true;

    final netList = await _shopApiClient.loadList(_maxLoadedID);
    netList.forEach((element) {
      _storage.add(HiveProduct(
        id: element.id,
        title: element.title,
        url: element.url)
      );
    });

    _maxLoadedID += _shopApiClient.loadingLimit;
    _settings.put(_maxIDKey, _maxLoadedID);

    _isLoading = false;

    return Future.value();
  }

  Future<void> genRandomElem() async {
    int idRand = math.Random().nextInt(_defaultProducts.length-1);
    HiveProduct randElem = _defaultProducts[idRand];
    await _storage.add(randElem);
    return Future.value();
  }

  Future<void> delElem(int id) async {
    await _storage.deleteAt(id);
    return Future.value();
  }

  static const _settingsBox = 'settingsBox';
  static const _maxIDKey = 'maxIDKey';
  static const _storageBox = 'storageBox';

  final List<HiveProduct> _defaultProducts = [
    HiveProduct(id: 5001, title: 'rand-1',
        url: 'https://via.placeholder.com/600/ffffff'),
    HiveProduct(id: 5002, title: 'rand-2',
        url: 'https://via.placeholder.com/600/ffffff'),
    HiveProduct(id: 5003, title: 'rand-3',
        url: 'https://via.placeholder.com/600/ffffff'),
    HiveProduct(id: 5004, title: 'rand-4',
        url: 'https://via.placeholder.com/600/ffffff'),
    HiveProduct(id: 5005, title: 'rand-5',
        url: 'https://via.placeholder.com/600/ffffff')
  ];
}