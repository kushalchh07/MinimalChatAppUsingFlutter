part of 'stories_bloc.dart';

sealed class StoriesState extends Equatable {
  const StoriesState();

  @override
  List<Object> get props => [];
}

final class StoriesInitial extends StoriesState {}

final class StoryPicked extends StoriesState {
  final File image;

  StoryPicked(this.image);

  @override
  List<Object> get props => [image];
}

final class StoryUploading extends StoriesState {}
final class StoryUploaded extends StoriesState {
  final String storyUrls;

  StoryUploaded(this.storyUrls);

  @override
  List<Object> get props => [storyUrls];
}

final class StoryUpLoadFailure extends StoriesState {
  final String message;

  const StoryUpLoadFailure(this.message);

  @override
  List<Object> get props => [message];
}

