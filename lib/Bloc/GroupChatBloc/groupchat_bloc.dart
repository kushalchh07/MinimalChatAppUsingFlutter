// ignore_for_file: empty_catches

import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:chat_app/model/groupchat_model.dart';
import 'package:chat_app/services/chat_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/route_manager.dart';

import '../../pages/screen/base.dart';

part 'groupchat_event.dart';
part 'groupchat_state.dart';

class GroupchatBloc extends Bloc<GroupchatEvent, GroupchatState> {
  GroupchatBloc() : super(GroupchatInitial()) {
    on<CreateGroupChatEvent>(_groupchatCreate);
    on<GroupChatLoadEvent>(_groupchatLoad);
    on<GroupChatDeleteEvent>(_groupchatDelete);
    on<ChatRoomSelect>(_chatRoomSelect);
    on<AddMembersToChatRoomEvent>(_addMembersToChatRoom);
    on<RemoveMembersFromChatRoomEvent>(_removeMembersFromChatRoom);
  }
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  ChatService _chatService = ChatService();
  FutureOr<void> _groupchatCreate(
      CreateGroupChatEvent event, Emitter<GroupchatState> emit) async {
    log('Creating chat room with name: ${event.chatRoomName}');
    emit(CreateGroupChatLoading());

    try {
      final chatRoomRef = _firestore.collection('chatRooms').doc();
      log('Chat room reference created: ${chatRoomRef.id}');
      log('adminId:' + currentUserId);
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
        adminId: currentUserId,
      )));
    } catch (e) {
      log('Error creating chat room: $e');
      emit(CreateChatRoomFailure(e.toString()));
    }
  }

  FutureOr<void> _groupchatLoad(
      GroupChatLoadEvent event, Emitter<GroupchatState> emit) async {
    try {
      emit(ChatRoomLoading());
      // log('Loading chat rooms from Firestore...');

      // Get the current user's ID
      String currentUserId = FirebaseAuth.instance.currentUser!.uid;
      // log('Current user ID: $currentUserId');

      // Query Firestore for chat rooms
      // log('Querying Firestore for chat rooms...');
      final querySnapshot = await _firestore.collection('chatRooms').get();
      // log('Successfully loaded chat rooms from Firestore');

      // Filter chat rooms where the current user is a member
      log('Filtering chat rooms where the current user is a member...');
      final chatRooms = querySnapshot.docs
          .map((doc) => ChatRoom.fromMap(doc.data()))
          .where((chatRoom) {
        final isMember = chatRoom.memberIds.contains(currentUserId);
        // log('Is ${chatRoom.id} a member of the chat room? $isMember');
        return isMember;
      }).toList();

      // log('Chat rooms loaded: $chatRooms');
      emit(ChatRoomsLoaded(chatRooms));
    } catch (e) {
      log('Error loading chat rooms from Firestore: $e');
      emit(ChatRoomLoadFailure(e.toString()));
    }
  }

  FutureOr<void> _groupchatDelete(
      GroupChatDeleteEvent event, Emitter<GroupchatState> emit) async {
    try {
      log('Deleting chat room with id: ${event.chatRoomId}');
      await _firestore.collection('chatRooms').doc(event.chatRoomId).delete();
      log('Chat room deleted from Firestore');
      emit(GroupchatDeleteSuccess());
      Get.off(()=>Base(indexNum: 1,));
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
              deleted: false,
              adminId: ''); // Return null to satisfy the return type
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

  FutureOr<void> _addMembersToChatRoom(
      AddMembersToChatRoomEvent event, Emitter<GroupchatState> emit) async {
    // Logging start of the function
    log('Add Members to Chat Room function started');
    emit(MembersAdding());
    // Logging the chat room id and member ids
    log('Chat Room ID: ${event.chatRoomId}');
    log('Member IDs: ${event.memberIds}');

    try {
      // Logging the start of the addMembersToChatRoom function
      log('Called addMembersToChatRoom function');

      // Call the addMembersToChatRoom function
      await _chatService.addMembersToChatRoom(
        chatRoomId: event.chatRoomId,
        memberIds: event.memberIds,
      );

      // Logging the successful addition of members
      log('Members added successfully');

      // Emit the AddMembersSuccess state

      emit(AddMembersSuccess());
      if (state is AddMembersSuccess) {
        add(GroupChatLoadEvent());
      }
    } catch (error) {
      // Logging the error occurred while adding members
      log('Error occurred while adding members: $error');

      // Emit the AddMembersFailure state with the error message
      emit(AddMembersFailure(error.toString()));
    }

    // Logging the end of the function
    log('Add Members to Chat Room function ended');
  }
}

FutureOr<void> _removeMembersFromChatRoom(
    RemoveMembersFromChatRoomEvent event, Emitter<GroupchatState> emit) async {}
