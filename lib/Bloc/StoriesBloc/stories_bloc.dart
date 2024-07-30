import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

part 'stories_event.dart';
part 'stories_state.dart';

class StoriesBloc extends Bloc<StoriesEvent, StoriesState> {
  StoriesBloc() : super(StoriesInitial()) {
    on<StoryPick>(_storyPick);
    on<StoryUpload>(_storyUpload);
  }
  final ImagePicker _picker = ImagePicker();
  FutureOr<void> _storyPick(StoryPick event, Emitter<StoriesState> emit) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    log(pickedFile.toString());
    log(pickedFile!.path);
    if (pickedFile != null) {
      emit(StoryPicked(File(pickedFile.path)));
    } else {
      emit(StoryUpLoadFailure());
    }
  }

  FutureOr<void> _storyUpload(StoryUpload event, Emitter<StoriesState> emit) {}
}
