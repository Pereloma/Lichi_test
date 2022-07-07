import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/news/news_bloc.dart';
import '../../../domain/model/news.dart';
import '../news.dart';

class News extends StatelessWidget {
  final GestureTapCallback onTap;
  final Future<NewsModel> futureModel;

  const News({super.key, required this.futureModel, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: FutureBuilder<NewsModel>(
          future: futureModel,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ));
            }
            if(snapshot.data == null){
              return Text("Null");
            }
            NewsModel model = snapshot.data!;
            return Column(
              children: [
                if (model.image != null)
                  model.image!.startsWith("http")
                      ? Image.network(model.image!,
                      height: 128,
                      width: double.infinity,
                      fit: BoxFit.fitWidth)
                      : Image.file(File(model.image!),
                      height: 128,
                      width: double.infinity,
                      fit: BoxFit.fitWidth),
                Text(
                  model.title,
                  style: Theme.of(context).textTheme.headline6,
                  maxLines: 2,
                ),
                Text(model.body,
                    style: Theme.of(context).textTheme.bodyText1, maxLines: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Icon(Icons.comment),
                    Text(model.comments.length.toString()),
                    const SizedBox(width: 32),
                    const Icon(Icons.star_rate),
                    Text(model.favorite.length.toString()),
                  ],
                )
              ],
            );
          },
        ),
      ),
    );
  }
}