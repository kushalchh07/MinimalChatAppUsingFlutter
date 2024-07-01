import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class ProfileImageState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProfileImageInitial extends ProfileImageState {}

class ProfileImagePicked extends ProfileImageState {
  final File image;

  ProfileImagePicked(this.image);

  @override
  List<Object?> get props => [image];
}

class ProfileImageUploading extends ProfileImageState {}

class ProfileImageUploaded extends ProfileImageState {}

class ProfileImageLoadFailure extends ProfileImageState {
  final String error;

  ProfileImageLoadFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class ProfileImagesLoaded extends ProfileImageState {
  final List<String> profileImageUrls;

  ProfileImagesLoaded(this.profileImageUrls);

  @override
  List<Object?> get props => [profileImageUrls];
}
