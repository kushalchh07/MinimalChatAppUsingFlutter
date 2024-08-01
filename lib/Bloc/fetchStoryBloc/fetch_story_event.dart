part of 'fetch_story_bloc.dart';

sealed class FetchStoryEvent extends Equatable {
  const FetchStoryEvent();

  @override
  List<Object> get props => [];
}

class FetchStories extends FetchStoryEvent{
  // final String currentUserId;
// FetchStories(this.currentUserId);
  // const FetchStories(this.currentUserId);
}
