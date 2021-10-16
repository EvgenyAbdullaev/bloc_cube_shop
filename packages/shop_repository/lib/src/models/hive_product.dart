import 'package:hive/hive.dart';
part 'hive_product.g.dart';

@HiveType(typeId: 1)
class HiveProduct {
  HiveProduct({required this.id, required this.title, required this.url});

  @HiveField(0)
  int id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String url;

  @override
  String toString() {
    return '$id: $title';
  }
}