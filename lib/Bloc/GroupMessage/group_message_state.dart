part of 'group_message_bloc.dart';

sealed class GroupMessageState extends Equatable {
  const GroupMessageState();
  
  @override
  List<Object> get props => [];
}

final class GroupMessageInitial extends GroupMessageState {}
