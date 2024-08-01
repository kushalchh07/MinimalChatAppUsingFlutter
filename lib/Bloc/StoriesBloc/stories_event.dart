part of 'stories_bloc.dart';

sealed class StoriesEvent extends Equatable {
  const StoriesEvent();

  @override
  List<Object> get props => [];
}

class StoryPick extends StoriesEvent {}

class StoryUpload extends StoriesEvent {
  final File image;

  StoryUpload(this.image);

  @override
  List<Object> get props => [image];
}


