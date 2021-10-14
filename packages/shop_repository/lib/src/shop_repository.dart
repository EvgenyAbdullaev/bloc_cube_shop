import 'package:shop_api/shop_api.dart';
import 'package:shop_repository/shop_repository.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:math' as math;

class ShopRepository {
  ShopRepository({ShopApiClient? shopApiClient})
      : _shopApiClient = shopApiClient ?? ShopApiClient();

  final ShopApiClient _shopApiClient;

  late final Box _storage;
  late final Box _settings;

  int _maxLoadedID = 0;
  int get maxLoadedIDTest => _maxLoadedID;    //temp var, del on production

  void init() async {
    var dir = await getApplicationDocumentsDirectory();
    print('path: ${dir.path}');

    Hive
      ..init(dir.path)
      ..registerAdapter(HiveProductAdapter());

    _storage = await Hive.openBox<HiveProduct>(_storageBox);
    _settings = await Hive.openBox(_settingsBox);
    _maxLoadedID = await _settings.get(_maxIDKey) ?? 0;
  }

  Iterable<HiveProduct> get data {
    if (_storage.isNotEmpty) {
      return _storage.values as Iterable<HiveProduct>;
    } else {
      return [];
    }
  }

  void loadData() async {
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
  }

  void genRandomElem() {
    int idRand = math.Random().nextInt(_defaultProducts.length-1);
    HiveProduct randElem = _defaultProducts[idRand];
    _storage.add(randElem);
  }

  void delElem(int id) {
    _storage.deleteAt(id);
  }

  static const _settingsBox = 'settingsBox';
  static const _maxIDKey = 'maxIDKey';
  static const _storageBox = 'storageBox';

  final List<HiveProduct> _defaultProducts = [
    HiveProduct(id: 5001, title: 'rand-1',
        url: 'https://via.placeholder.com/600/000000'),
    HiveProduct(id: 5002, title: 'rand-2',
        url: 'https://via.placeholder.com/600/000000'),
    HiveProduct(id: 5003, title: 'rand-3',
        url: 'https://via.placeholder.com/600/000000'),
    HiveProduct(id: 5004, title: 'rand-4',
        url: 'https://via.placeholder.com/600/000000'),
    HiveProduct(id: 5005, title: 'rand-5',
        url: 'https://via.placeholder.com/600/000000')
  ];
}