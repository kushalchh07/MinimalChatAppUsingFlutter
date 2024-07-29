part of 'groupchat_bloc.dart';

sealed class GroupchatState extends Equatable {
  const GroupchatState();
  
  @override
  List<Object> get props => [];
}

final class GroupchatInitial extends GroupchatState {}
