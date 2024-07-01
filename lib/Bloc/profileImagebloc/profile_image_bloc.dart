import 'dart:io';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'profile_image_event.dart';
import 'profile_image_state.dart';

class ProfileImageBloc extends Bloc<ProfileImageEvent, ProfileImageState> {
  final FirebaseStorage _storage;
  final FirebaseFirestore _firestore;
  final ImagePicker _picker;

  ProfileImageBloc(this._storage, this._firestore, this._picker)
      : super(ProfileImageInitial()) {
    on<PickProfileImage>(_onPickProfileImage);
    on<UploadProfileImage>(_onUploadProfileImage);
    on<LoadProfileImages>(_onLoadProfileImages);
  }

  Future<void> _onPickProfileImage(
      PickProfileImage event, Emitter<ProfileImageState> emit) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      emit(ProfileImagePicked(File(pickedFile.path)));
    } else {
      emit(ProfileImageLoadFailure('No image selected.'));
    }
  }

  Future<void> _onUploadProfileImage(
      UploadProfileImage event, Emitter<ProfileImageState> emit) async {
    emit(ProfileImageUploading());
    try {
      User? user = FirebaseAuth.instance.currentUser!;
      String userId = user.uid; // Replace with the actual user ID
      String fileName = 'profile_images/$userId.png';
      TaskSnapshot snapshot =
          await _storage.ref().child(fileName).putFile(event.image);
      String downloadUrl = await snapshot.ref.getDownloadURL();
      await _firestore
          .collection('users')
          .doc(userId)
          .update({'profileImageUrl': downloadUrl});
      log(user.uid);
      emit(ProfileImageUploaded());
      add(LoadProfileImages()); // Trigger loading of images after upload
    } catch (e) {
      emit(ProfileImageLoadFailure(e.toString()));
    }
  }

  Future<void> _onLoadProfileImages(
      LoadProfileImages event, Emitter<ProfileImageState> emit) async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('users').get();
      List<String> profileImageUrls = querySnapshot.docs
          .map((doc) => doc['profileImageUrl'] as String)
          .toList();
      emit(ProfileImagesLoaded(profileImageUrls));
    } catch (e) {
      emit(ProfileImageLoadFailure(e.toString()));
    }
  }
}
