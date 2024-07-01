import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class ProfileImageEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class PickProfileImage extends ProfileImageEvent {}

class UploadProfileImage extends ProfileImageEvent {
  final File image;

  UploadProfileImage(this.image);

  @override
  List<Object?> get props => [image];
}

class LoadProfileImages extends ProfileImageEvent {}
