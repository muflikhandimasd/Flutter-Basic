part of 'post_cubit.dart';

abstract class PostState {}

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostError extends PostState {
  final String message;

  PostError(this.message);
}

class PostLoaded extends PostState {
  final List<Post> posts;
  PostLoaded(this.posts);
}
