import 'package:hive_flutter/adapters.dart';
import 'package:lichi_test/domain/model/coment.dart';
import 'package:lichi_test/domain/model/user.dart';

part 'news.g.dart';

@HiveType(typeId: 1)
class NewsModel extends HiveObject {
  @HiveField(0)
  late int? id;
  @HiveField(1)
  final String? image;
  @HiveField(2)
  final String title;
  @HiveField(3)
  final String body;
  @HiveField(4)
  final List<CommentModel> comments;
  @HiveField(5)
  final List<dynamic> favorite;
  @HiveField(6)
  final DateTime date;



  NewsModel(
      {this.id,
      this.image,
      required this.title,
      required this.body,
      required this.comments,
      required this.favorite,
      required this.date});

}
