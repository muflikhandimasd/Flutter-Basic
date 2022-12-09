import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:first_app/models/post.dart';

import 'package:http/http.dart' as http;
part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  PostCubit() : super(PostInitial());

  void init() {
    getPost();
  }

  void getPost() async {
    emit(PostLoading());
    try {
      final url = Uri.parse('https://jsonplaceholder.typicode.com/posts');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final dataApi = jsonDecode(response.body);
        List<Post> datas = [];
        for (var json in dataApi) {
          datas.add(Post.fromJson(json));
        }
        emit(PostLoaded(datas));
      } else {
        emit(PostError('Error response'));
      }
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }
}
