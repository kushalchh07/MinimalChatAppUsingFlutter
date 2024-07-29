part of 'stories_bloc.dart';

sealed class StoriesState extends Equatable {
  const StoriesState();
  
  @override
  List<Object> get props => [];
}

final class StoriesInitial extends StoriesState {}
