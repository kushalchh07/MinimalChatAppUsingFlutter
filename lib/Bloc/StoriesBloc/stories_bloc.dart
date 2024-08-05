import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:chat_app/constants/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
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

  // This function handles the StoryUpload event, which is triggered when a user wants to upload a new story.
  // It takes in the StoryUpload event and the emitter object, which allows the bloc to emit new states.
  FutureOr<void> _storyUpload(
      StoryUpload event, Emitter<StoriesState> emit) async {
    emit(StoryUploading());
    try {
      // Get the currently authenticated user
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User is not authenticated');

      String userId = user.uid;
      int userid = generate4DigitRandomNumber();

      // Define the path and upload the file
      String fileName = 'stories_url/$userid.png';
      TaskSnapshot snapshot = await FirebaseStorage.instance
          .ref()
          .child(fileName)
          .putFile(event.image);

      // Get the download URL
      String downloadUrl = await snapshot.ref.getDownloadURL();

      // Create the story data
      Map<String, dynamic> storyData = {
        'url': downloadUrl,
        'timeStamp': DateTime.now(),
      };

      // Reference to the user's document in the 'stories' collection
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('stories').doc(userId);

      // Update the user document with the new story URL
      await userDocRef.set({
        'storiesUrl': FieldValue.arrayUnion([storyData]),
      }, SetOptions(merge: true));

      // Emit the appropriate event
      emit(StoryUploaded(downloadUrl));
    } catch (e) {
      // Log any errors that occur during the upload process
      log('Story upload failed: $e');
      emit(StoryUpLoadFailure(e.toString()));
    }
  }
}
