// ignore_for_file: empty_catches

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_app/constants/colors/colors.dart';
import 'package:chat_app/services/chat_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UsersLoading()) {
    on<LoadUsers>(_onLoadUsers);
    on<LoadBlockedUsers>(_onBlockedUsersLoad);
    on<UnBlockUserEvent>(_onUnBlockedUserEvent);
    on<BlockUserEvent>(_onBlockUserEvent);
  }
  ChatService _chatService = ChatService();
  Future<void> _onLoadUsers(LoadUsers event, Emitter<UserState> emit) async {
    emit(UsersLoading());
    try {
      // final QuerySnapshot querySnapshot =
      // await FirebaseFirestore.instance.collection('users').get();
      // final users = querySnapshot.docs
      //     .map((doc) => doc.data() as Map<String, dynamic>)
      //     .toList();
      final usersStream = _chatService.getUsersStreamExcludingBlocked();
      final users = await usersStream.first;
      emit(UsersLoaded(users));
    } catch (_) {
      emit(UsersError());
    }
  }

  FutureOr<void> _onBlockedUsersLoad(
      LoadBlockedUsers event, Emitter<UserState> emit) async {
    ChatService _chatService = ChatService();
    try {
      final blockedUsersStream =
          _chatService.getBlockedUsers(FirebaseAuth.instance.currentUser!.uid);
      final blockedUsers = await blockedUsersStream.first;

      emit(BlockedUsersLoaded(blockedUsers));
    } catch (_) {
      emit(UsersError());
    }
  }

  FutureOr<void> _onUnBlockedUserEvent(
      UnBlockUserEvent event, Emitter<UserState> emit) async {
    ChatService _chatService = ChatService();
    try {
      await _chatService.unBlockUser(event.blockedUserId).then((value) {
        if (value == "unblocked") {
          Fluttertoast.showToast(
              msg: "User UnBlocked",
              gravity: ToastGravity.BOTTOM,
              toastLength: Toast.LENGTH_SHORT,
              backgroundColor: successColor);
        }
      });

// emit(BlockedUsersLoaded([]));
    } catch (e) {
      print(e);
      emit(UsersError());
    }
  }

  FutureOr<void> _onBlockUserEvent(
      BlockUserEvent event, Emitter<UserState> emit) async {
    try {
      _chatService.blockUser(event.blockedUserId).then((value) {
        if (value == "blocked") {
          Fluttertoast.showToast(
              msg: "User Blocked",
              gravity: ToastGravity.BOTTOM,
              toastLength: Toast.LENGTH_SHORT,
              backgroundColor: successColor);
        }
      });
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
          msg: "Failed to block user",
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: errorColor);

      emit(UsersError());
    }
  }
}
