import 'package:equatable/equatable.dart';
import 'dart:io';

abstract class GroupInfoEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class PickImageEvent extends GroupInfoEvent {}

class UpdateImageEvent extends GroupInfoEvent {
  final File imageFile;
  final String groupId;

  UpdateImageEvent({required this.imageFile, required this.groupId});

  @override
  List<Object> get props => [imageFile, groupId];
}

class GetGroupNameEvent extends GroupInfoEvent {
  final String groupId;

  GetGroupNameEvent({required this.groupId});

  @override
  List<Object> get props => [groupId];
}

class UpdateGroupNameEvent extends GroupInfoEvent {
  final String groupId;
  final String groupName;

  UpdateGroupNameEvent({required this.groupId, required this.groupName});

  @override
  List<Object> get props => [groupId, groupName];
}
