// ignore_for_file: empty_catches

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:chat_app/services/chat_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final FirebaseFirestore _firestore;
  final ImagePicker _picker;
  final ChatService _chatService;
  final FirebaseStorage _storage;
  ChatBloc(this._firestore)
      : _picker = ImagePicker(),
        _chatService = ChatService(),
        _storage = FirebaseStorage.instance,
        super(ChatInitial()) {
    on<SendMessage>(_onSendMessage);
    on<LoadMessages>(_onLoadMessages);
    on<ImagePickedEvent>(_imagePickedEvent);
    on<ImageSendEvent>(_sendImage);
    on<ImageCancelEvent>(_imageCancelEvent);
  }

  void _onSendMessage(SendMessage event, Emitter<ChatState> emit) async {
    try {
      await _firestore.collection('messages').add({
        'message': event.message,
        'userId': event.userId,
        'timestamp': FieldValue.serverTimestamp(),
      });
      emit(MessageSent());
      add(LoadMessages());
    } catch (e) {
      emit(MessageFailure(e.toString()));
    }
  }

  void _onLoadMessages(LoadMessages event, Emitter<ChatState> emit) async {
    try {
      final messagesSnapshot = await _firestore
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .get();

      final messages = messagesSnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      emit(MessagesLoaded(messages));
    } catch (e) {
      emit(MessageFailure(e.toString()));
    }
  }

  FutureOr<void> _imagePickedEvent(
      ImagePickedEvent event, Emitter<ChatState> emit) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    log(pickedFile.toString());
    log(pickedFile!.path);
    if (pickedFile != null) {
      emit(ImagePicked(File(pickedFile.path)));
    } else {
      emit(ImageLoadFailure('No image selected.'));
    }
  }

  FutureOr<void> _sendImage(
      ImageSendEvent event, Emitter<ChatState> emit) async {
    try {
      emit(ImageSendingEvent());
      User? user = FirebaseAuth.instance.currentUser!;
      String userId = user.uid;
      String fileName = 'profile_images/$userId.png';
      log(fileName);
      TaskSnapshot snapshot =
          await _storage.ref().child(fileName).putFile(event.image);
      String downloadUrl = await snapshot.ref.getDownloadURL();

      log('Download URL: $downloadUrl');
      await _chatService.sendMessage(event.userId, downloadUrl, true);
      add(ImageCancelEvent());
    } catch (e) {
      log(e.toString());
      emit(ImageLoadFailure(e.toString()));
    }
  }

  FutureOr<void> _imageCancelEvent(
      ImageCancelEvent event, Emitter<ChatState> emit) async {
    emit(ImageCancelImage());
  }
}
