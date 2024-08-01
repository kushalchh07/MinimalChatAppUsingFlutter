part of 'fetch_story_bloc.dart';

sealed class FetchStoryState extends Equatable {
  const FetchStoryState();
  
  @override
  List<Object> get props => [];
}

final class FetchStoryInitial extends FetchStoryState {}
final class StoryLoadFailure extends  FetchStoryState{
  final String message;

  const StoryLoadFailure(this.message);

  @override
  List<Object> get props => [message];
}

final class StoriesLoading extends FetchStoryState {}

final class StoriesLoaded extends FetchStoryState {
  final List<Map<String, dynamic>> stories;
final String mystories;
  const StoriesLoaded(this.stories,this.mystories);

  @override
  List<Object> get props => [stories];
}
