import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class GroupInfoState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GroupInfoInitial extends GroupInfoState {}

class GroupNameLoaded extends GroupInfoState {
  final String groupName;

  GroupNameLoaded({required this.groupName});

  @override
  List<Object?> get props => [groupName];
}

class ImagePickedState extends GroupInfoState {
  final File imageFile;

  ImagePickedState({required this.imageFile});

  @override
  List<Object?> get props => [imageFile];
}
class ImageUpdatingState extends GroupInfoState {}
class ImageUpdatedState extends GroupInfoState {}

class GroupNameUpdatedState extends GroupInfoState {}
class GroupInfoLoadingState extends GroupInfoState {}
class GroupInfoErrorState extends GroupInfoState {
  final String message;

  GroupInfoErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}
