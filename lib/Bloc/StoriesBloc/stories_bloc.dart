import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:chat_app/constants/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

part 'stories_event.dart';
part 'stories_state.dart';

class StoriesBloc extends Bloc<StoriesEvent, StoriesState> {
  StoriesBloc() : super(StoriesInitial()) {
    on<StoryPick>(_storyPick);
    on<StoryUpload>(_storyUpload);
    // on<FetchStories>(_fetchStories);
  }

  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FutureOr<void> _storyPick(StoryPick event, Emitter<StoriesState> emit) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    log(pickedFile.toString());
    log(pickedFile!.path);
    if (pickedFile != null) {
      emit(StoryPicked(File(pickedFile.path)));
      // add(FetchStories());
    } else {
      emit(StoryUpLoadFailure('No image selected.'));
    }
  }

  FutureOr<void> _storyUpload(
      StoryUpload event, Emitter<StoriesState> emit) async {
    emit(StoryUploading());
    try {
      User? user = FirebaseAuth.instance.currentUser;
      String userId = user!.uid;
      int userid = generate4DigitRandomNumber();
      log(userId);
      String fileName = 'stories_url/$userid.png';
      log(fileName);
      TaskSnapshot snapshot =
          await _storage.ref().child(fileName).putFile(event.image);
      String downloadUrl = await snapshot.ref.getDownloadURL();

      log('Download URL: $downloadUrl');
      await _firestore.collection('stories').doc(userId).set({
        'storiesUrl': downloadUrl,
        'userId': userId,
        'timeStamp': FieldValue.serverTimestamp()
      });
      log(user.uid);

      emit(StoryUploaded(downloadUrl));
    } catch (e) {
      emit(StoryUpLoadFailure(e.toString()));
    }
  }
}
