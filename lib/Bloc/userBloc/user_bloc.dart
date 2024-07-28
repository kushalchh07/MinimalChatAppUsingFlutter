// ignore_for_file: empty_catches

import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:chat_app/constants/Sharedpreferences/sharedpreferences.dart';
import 'package:chat_app/constants/colors/colors.dart';
import 'package:chat_app/services/auth_services.dart';
import 'package:chat_app/services/chat_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:get/get.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final ChatService _chatService;

  UserBloc(this._chatService) : super(UsersLoading()) {
    on<LoadUsers>(_onLoadUsers);
    on<LoadBlockedUsers>(_onBlockedUsersLoad);
    on<UnBlockUserEvent>(_onUnBlockedUserEvent);
    on<BlockUserEvent>(_onBlockUserEvent);
    on<LoadMyProfile>(_loadMyProfile);
    on<UpdateProfile>(_updateProfile);
    on<DeleteMyProfileWithEmail>(_deleteMyProfile);
    on<DeleteMyProfileWithGoogle>(_deleteMyProfileGoogle);
  }
  final AuthService _authService = AuthService();
  Future<void> _onLoadUsers(LoadUsers event, Emitter<UserState> emit) async {
    emit(UsersLoading());
    try {
      final usersStream = _chatService.getUsersStreamExcludingBlocked();
      final users = await usersStream.first;
      log(users.toString());
      emit(UsersLoaded(users));
    } catch (_) {
      emit(UsersError());
    }
  }

  Future<void> _onBlockedUsersLoad(
      LoadBlockedUsers event, Emitter<UserState> emit) async {
    try {
      emit(UsersLoading());
      final blockedUsersStream =
          _chatService.getBlockedUsers(FirebaseAuth.instance.currentUser!.uid);
      final blockedUsers = await blockedUsersStream.first;
      log(blockedUsers.toString());
      emit(BlockedUsersLoaded(blockedUsers));
    } catch (_) {
      emit(UsersError());
    }
  }

  Future<void> _onUnBlockedUserEvent(
      UnBlockUserEvent event, Emitter<UserState> emit) async {
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
      // Wait for LoadBlockedUsers event to complete
      await _onBlockedUsersLoad(LoadBlockedUsers(), emit);
    } catch (e) {
      print(e);
      emit(UsersError());
    }
  }

  Future<void> _onBlockUserEvent(
      BlockUserEvent event, Emitter<UserState> emit) async {
    try {
      await _chatService.blockUser(event.blockedUserId).then((value) {
        if (value == "blocked") {
          Fluttertoast.showToast(
              msg: "User Blocked",
              gravity: ToastGravity.BOTTOM,
              toastLength: Toast.LENGTH_SHORT,
              backgroundColor: successColor);
          emit(UserBlockedActionState(true));
        }
      });
      add(LoadUsers());
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
          msg: "Failed To Block",
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: errorColor);
      emit(UserBlockedActionState(false));
      emit(UsersError());
    }
  }

  Future<void> _loadMyProfile(
      LoadMyProfile event, Emitter<UserState> emit) async {
    try {
      AuthService _authService = AuthService();
      emit(MyProfileLoaded(
          await _authService.getUserDataFromFirebase(event.userId)));
    } catch (e) {}
  }

  FutureOr<void> _updateProfile(
      UpdateProfile event, Emitter<UserState> emit) async {
    try {
      await _authService.updateProfile(event.fname).then((value) {
        if (value == "updated") {
          saveName(event.fname);
          emit(UpdateProfileSuccess());
        }
      });
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
          msg: "Failed To Update",
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: errorColor);
    }
  }

  FutureOr<void> _deleteMyProfile(
      DeleteMyProfileWithEmail event, Emitter<UserState> emit) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null && user.email != null) {
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: event.password,
        );
        await user.reauthenticateWithCredential(credential);
        await user.delete();
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .delete();
        emit(DeleteProfileSuccess());
      }
    } catch (e) {
      print(e);
      emit(DeleteProfileFailed());
    }
  }

  FutureOr<void> _deleteMyProfileGoogle(
      DeleteMyProfileWithGoogle event, Emitter<UserState> emit) async {
    try {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        // The user canceled the sign-in
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User user = userCredential.user!;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .delete();
      await user.delete();
      emit(DeleteProfileSuccess());
    } catch (e) {
      log(e.toString());
      emit(DeleteProfileFailed());
    }
  }
}
