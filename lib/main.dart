import 'dart:convert';
import 'dart:developer';

import 'package:first_app/cubit/post_cubit.dart';
import 'package:first_app/data_dummy.dart';
import 'package:first_app/models/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PostCubit()..init(),
      child: MaterialApp(
        home: DataBloc(),
      ),
    );
  }
}

class DataBloc extends StatelessWidget {
  const DataBloc({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<PostCubit, PostState>(
        builder: (context, state) {
          if (state is PostLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is PostError) {
            return Center(
              child: Text(state.message),
            );
          }
          if (state is PostLoaded) {
            return ListView.builder(
              itemCount: state.posts.length,
              itemBuilder: (context, index) {
                final post = state.posts[index];
                return ListTile(
                  title: Text(post.title!),
                  subtitle: Text(post.body!),
                );
              },
            );
          }
          return Container();
        },
      ),
    );
  }
}

class DataNull extends StatelessWidget {
  const DataNull({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: dataDummy.length,
        itemBuilder: (context, index) {
          final data = dataDummy[index];
          return ListTile(
              title: Text(data.title!),
              subtitle:
                  data.body != null ? Text(data.body!) : Text('DATANYA null'));
        },
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<List<Post>>(
            future: getPosts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              }
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final post = snapshot.data![index];
                      return ListTile(
                        title: Text(post.title!),
                        subtitle: Text(post.body!),
                      );
                    },
                  );
                }
              }
              return Container();
            }));
  }
}

Future<List<Post>> getPosts() async {
  try {
    final url = Uri.parse('https://jsonplaceholder.typicode.com/posts');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final dataApi = jsonDecode(response.body);
      List<Post> datas = [];
      for (var json in dataApi) {
        datas.add(Post.fromJson(json));
        log('$json');
      }
      return datas;
    }
    throw Exception();
  } catch (e) {
    log('$e');
    throw Exception();
  }
}
