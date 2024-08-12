import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'group_info_event.dart';
import 'group_info_state.dart';

class GroupInfoBloc extends Bloc<GroupInfoEvent, GroupInfoState> {
  final FirebaseFirestore firestore;
  final FirebaseStorage firebaseStorage;

  GroupInfoBloc({required this.firestore, required this.firebaseStorage})
      : super(GroupInfoInitial()) {
    on<PickImageEvent>((event, emit) async {
      try {
        final picker = ImagePicker();
        final pickedFile = await picker.pickImage(source: ImageSource.gallery);

        if (pickedFile != null) {
          emit(ImagePickedState(imageFile: File(pickedFile.path)));
        } else {
          emit(GroupInfoErrorState(message: "No image selected"));
        }
      } catch (e) {
        emit(GroupInfoErrorState(message: e.toString()));
      }
    });

    on<UpdateImageEvent>((event, emit) async {
      emit(GroupInfoLoadingState());
      try {
        final storageRef =
            firebaseStorage.ref().child('group_images/${event.groupId}');
        await storageRef.putFile(event.imageFile);
        String downloadUrl = await storageRef.getDownloadURL();

        await firestore.collection('chatRooms').doc(event.groupId).update({
          'groupImageUrl': downloadUrl,
        });

        emit(ImageUpdatedState());
      } catch (e) {
        emit(GroupInfoErrorState(message: e.toString()));
      }
    });

    on<GetGroupNameEvent>((event, emit) async {
      emit(GroupInfoLoadingState());
      try {
        DocumentSnapshot snapshot =
            await firestore.collection('chatRooms').doc(event.groupId).get();
        String groupName = snapshot['name'];
        emit(GroupNameLoaded(groupName: groupName));
      } catch (e) {
        emit(GroupInfoErrorState(message: e.toString()));
      }
    });

    on<UpdateGroupNameEvent>((event, emit) async {
      emit(GroupInfoLoadingState());
      try {
        await firestore.collection('chatRooms').doc(event.groupId).update({
          'name': event.groupName,
        });
        DocumentSnapshot snapshot =
            await firestore.collection('chatRooms').doc(event.groupId).get();
        String groupName = (snapshot.data() as Map<String, dynamic>)['name'];
        emit(GroupNameUpdatedState(
          groupName: groupName,
        ));
      } catch (e) {
        emit(GroupInfoErrorState(message: e.toString()));
      }
    });
  }
}
