import 'package:hive_flutter/adapters.dart';
import 'package:lichi_test/domain/model/news.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject{
  @HiveField(0)
  final int? id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final List newsID;

  UserModel({this.id, required this.name, required this.newsID});
}