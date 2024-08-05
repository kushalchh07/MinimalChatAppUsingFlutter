// ignore_for_file: empty_catches

import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:chat_app/model/groupchat_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

part 'groupchat_event.dart';
part 'groupchat_state.dart';

class GroupchatBloc extends Bloc<GroupchatEvent, GroupchatState> {
  GroupchatBloc() : super(GroupchatInitial()) {
    on<CreateGroupChatEvent>(_groupchatCreate);
    on<GroupChatLoadEvent>(_groupchatLoad);
    on<GroupChatDeleteEvent>(_groupchatDelete);
    on<ChatRoomSelect>(_chatRoomSelect);
  }
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  FutureOr<void> _groupchatCreate(
      CreateGroupChatEvent event, Emitter<GroupchatState> emit) async {
    log('Creating chat room with name: ${event.chatRoomName}');
    emit(CreateGroupChatLoading());

    try {
      final chatRoomRef = _firestore.collection('chatRooms').doc();
      log('Chat room reference created: ${chatRoomRef.id}');
      await chatRoomRef.set({
        'id': chatRoomRef.id,
        'name': event.chatRoomName,
        'memberIds': event.memberIds,
        'isGroup': true,
        'deleted': false,
        'createdAt': FieldValue.serverTimestamp(),
        'groupImageUrl': '',
        'adminId': currentUserId,
      });
      log('Chat room created in Firestore');
      emit(ChatRoomCreated(ChatRoom(
        id: chatRoomRef.id,
        memberIds: event.memberIds,
        isGroup: true,
        deleted: false,
        name: event.chatRoomName,
        createdAt: Timestamp.now(),
        groupImageUrl: '',
      )));
    } catch (e) {
      log('Error creating chat room: $e');
      emit(CreateChatRoomFailure(e.toString()));
    }
  }

  FutureOr<void> _groupchatLoad(
      GroupChatLoadEvent event, Emitter<GroupchatState> emit) async {
    try {
      // Log the start of the load process
      log('Start loading chat rooms from Firestore');

      // Emit loading state
      emit(ChatRoomLoading());

      // Perform the Firestore query
      final querySnapshot = await _firestore.collection('chatRooms').get();

      // Log successful data retrieval
      log('Successfully retrieved chat rooms from Firestore');

      // Map the documents to ChatRoom objects
      final chatRooms = querySnapshot.docs.map((doc) {
        log('Processing document: ${doc.id}');
        return ChatRoom.fromMap(doc.data());
      }).toList();

      // Log the number of chat rooms loaded and their details
      log('Number of chat rooms loaded: ${chatRooms.length}');
      log('Chat rooms loaded: ${chatRooms.map((room) => room.toString()).join(', ')}');

      // Emit the loaded chat rooms
      emit(ChatRoomsLoaded(chatRooms));
    } catch (e, stackTrace) {
      // Log the error with stack trace
      log('Error loading chat rooms from Firestore: $e',
          error: e, stackTrace: stackTrace);
      print('Error loading chat rooms: $e');
      emit(ChatRoomLoadFailure(e.toString()));
    }
  }

  FutureOr<void> _groupchatDelete(
      GroupChatDeleteEvent event, Emitter<GroupchatState> emit) async {
    try {
      log('Deleting chat room with id: ${event.chatRoomId}');
      await _firestore.collection('chatRooms').doc(event.chatRoomId).delete();
      log('Chat room deleted from Firestore');
    } catch (e) {
      log('Error deleting chat room: $e');
      print(e);
    }
  }

  FutureOr<void> _chatRoomSelect(
      ChatRoomSelect event, Emitter<GroupchatState> emit) async {
    try {
      log('Selecting chat room with id: ${event.chatRoomId}');
      final currentState = state;
      if (currentState is ChatRoomsLoaded) {
        final chatRoom = currentState.chatRooms.firstWhere(
            (chatRoom) => chatRoom.id == event.chatRoomId, orElse: () {
          log('Chat room not found');
          emit(GroupChatSelectError('Chat room not found'));
          return ChatRoom(
              id: '',
              name: 'Not Found',
              groupImageUrl: '',
              memberIds: [],
              isGroup: false,
              createdAt: null,
              deleted: false); // Return null to satisfy the return type
        });
        if (chatRoom != null) {
          log('Chat room selected: $chatRoom');
          emit(ChatRoomSelected(chatRoom));
        }
      } else {
        log('Chat rooms not loaded');
        emit(GroupChatSelectError('Chat rooms not loaded'));
      }
    } catch (e) {
      log('Error selecting chat room: $e');
      emit(GroupChatSelectError('Error selecting chat room'));
    }
  }
}
