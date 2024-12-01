import 'package:equatable/equatable.dart';

// part of 'fetch_story_bloc.dart';

sealed class FetchStoryState extends Equatable {
  const FetchStoryState();
  
  @override
  List<Object> get props => [];
}

final class FetchStoryInitial extends FetchStoryState {}

final class StoryLoadFailure extends FetchStoryState {
  final String message;

  const StoryLoadFailure(this.message);

  @override
  List<Object> get props => [message];
}

final class StoriesLoading extends FetchStoryState {}

final class StoriesLoaded extends FetchStoryState {
  final List<dynamic> myStoriesUrls; // List to hold current user's stories URLs
  final List<Map<String, dynamic>> otherUsersStories; // List to hold other users' stories

  const StoriesLoaded(this.myStoriesUrls, this.otherUsersStories);

  @override
  List<Object> get props => [myStoriesUrls, otherUsersStories];
}
