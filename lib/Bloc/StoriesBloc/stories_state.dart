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

  
}
final class StoryUploading extends StoriesState{}
final class StoryUploaded extends StoriesState {}
final class StoryUpLoadFailure extends StoriesState{}

final class StoryLoadFailure extends StoriesState {
  final String message;

  const StoryLoadFailure(this.message);

  @override
  List<Object> get props => [message];
}

final class StoriesLoading extends StoriesState {}

final class StoriesLoaded extends StoriesState {}
