import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/news/news_bloc.dart';
import 'home.dart';

class CreateOrEditNewsPage extends StatelessWidget {
  const CreateOrEditNewsPage({Key? key}) : super(key: key);

  static Route getRout() {
    return MaterialPageRoute(
        builder: (context) => const CreateOrEditNewsPage());
  }

  @override
  Widget build(BuildContext context) {
    final ImagePicker _picker = ImagePicker();
    return Scaffold(
        floatingActionButton: BlocBuilder<NewsBloc, NewsState>(
          buildWhen: (previous, current) {
            if (current.runtimeType == CreateOrEditNews) {
              if (previous.runtimeType == CreateOrEditNews) {
                previous as CreateOrEditNews;
                current as CreateOrEditNews;
                return previous.status != current.status;
              }
              return true;
            }
            return false;
          },
          builder: (context, state) {
            state as CreateOrEditNews;
            return FloatingActionButton(
                backgroundColor: !state.status.isValidated ? Colors.grey : null,
                onPressed: !state.status.isValidated
                    ? null
                    : () {
                        context.read<NewsBloc>().add(SaveNews());
                        Navigator.pop(context);
                      },
                child: const Icon(Icons.add));
          },
        ),
        appBar: AppBar(
          leading: BlocBuilder<NewsBloc, NewsState>(
            buildWhen: (previous, current) =>
                current.runtimeType == CreateOrEditNews,
            builder: (context, state) {
              state as CreateOrEditNews;
              return IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back));
            },
          ),
          title: const Text("News"),
          actions: [
            IconButton(
                onPressed: () async {
                  final XFile? photo =
                      await _picker.pickImage(source: ImageSource.camera);
                  if (photo != null) {
                    // ignore: use_build_context_synchronously
                    context.read<NewsBloc>().add(NewsImageChanged(photo.path));
                  }
                },
                icon: const Icon(Icons.camera_alt)),
            IconButton(
                onPressed: () async {
                  final XFile? photo =
                      await _picker.pickImage(source: ImageSource.gallery);
                  if (photo != null) {
                    // ignore: use_build_context_synchronously
                    context.read<NewsBloc>().add(NewsImageChanged(photo.path));
                  }
                },
                icon: const Icon(Icons.browse_gallery))
          ],
        ),
        body: BlocBuilder<NewsBloc, NewsState>(
          buildWhen: (previous, current) {
            if (current.runtimeType == CreateOrEditNews) {
              if (previous.runtimeType == CreateOrEditNews) {
                previous as CreateOrEditNews;
                current as CreateOrEditNews;
                return previous.title != current.title ||
                    previous.body != current.body ||
                    previous.image != current.image;
              }
              return true;
            }
            return false;
          },
          builder: (context, state) {
            state as CreateOrEditNews;
            return Column(
              children: [
                if (state.image != null)
                  state.image!.startsWith("http")?
                      Image.network(state.image!,
                          height: 128,
                          width: double.infinity,
                          fit: BoxFit.fitWidth):
                  Image.file(File(state.image!),
                      height: 128,
                      width: double.infinity,
                      fit: BoxFit.fitWidth),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                      key: const Key('CreateEditForm_Title'),
                      controller: state.newEdit ?
                      (TextEditingController()..text = state.title.value) :
                      null,
                      onChanged: (title) =>
                          context.read<NewsBloc>().add(NewsTitleChanged(title)),
                      minLines: 2,
                      maxLines: 8,
                      decoration: InputDecoration(
                        filled: true,
                        labelText: 'Title',
                        errorText: state.title.invalid ? 'Invalid Title' : null,
                      )),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                        key: const Key('CreateEditForm_Body'),
                        controller: state.newEdit ?
                        (TextEditingController()..text = state.body.value) :
                        null,
                        onChanged: (body) =>
                            context.read<NewsBloc>().add(NewsBodyChanged(body)),
                        minLines: 256,
                        maxLines: 512,
                        decoration: InputDecoration(
                          filled: true,
                          focusColor: Colors.black,
                          labelText: 'Body',
                          errorText:
                              state.body.invalid ? 'Invalid body text' : null,
                        )),
                  ),
                ),
              ],
            );
          },
        ));
  }
}
