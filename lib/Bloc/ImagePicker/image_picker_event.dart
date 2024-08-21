part of 'image_picker_bloc.dart';

@immutable
sealed class ImagePickerEvent {}
class GalleryEvent extends ImagePickerEvent {}
class CameraEvent extends ImagePickerEvent {}