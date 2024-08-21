import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

part 'image_picker_event.dart';
part 'image_picker_state.dart';

class ImagePickerBloc extends Bloc<ImagePickerEvent, ImagePickerState> {
  ImagePickerBloc() : super(ImagePickerInitial()) {
    on<GalleryEvent>(_galleryEvent);
    on<CameraEvent>(_cameraEvent);
  }

  FutureOr<void> _galleryEvent(
      GalleryEvent event, Emitter<ImagePickerState> emit) async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      emit(ImagePickedSuccess(image: imageTemp));
    } catch (e) {
      emit(ImagePickFailure());
    }
  }

  FutureOr<void> _cameraEvent(
      CameraEvent event, Emitter<ImagePickerState> emit) async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;
      final imageTemp = File(image.path);
      emit(ImagePickedSuccess(image: imageTemp));
    } catch (e) {
      emit(ImagePickFailure());
    }
  }
}
