import 'package:hive_flutter/adapters.dart';
import 'package:lichi_test/domain/model/user.dart';

part 'coment.g.dart';

@HiveType(typeId: 2)
class CommentModel extends HiveObject{
  @HiveField(0)
  final int? id;
  @HiveField(1)
  final UserModel user;
  @HiveField(2)
  final String comment;

  CommentModel({this.id, required this.user, required this.comment});
}