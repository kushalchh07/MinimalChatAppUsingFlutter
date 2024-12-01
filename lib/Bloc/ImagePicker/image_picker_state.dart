part of 'image_picker_bloc.dart';

@immutable
sealed class ImagePickerState {}

final class ImagePickerInitial extends ImagePickerState {}

final class ImagePickedSuccess extends ImagePickerState {
  File? image;

  ImagePickedSuccess({required this.image});
}

final class ImagePickFailure extends ImagePickerState {}

final class ImagePicking extends ImagePickerState {}
