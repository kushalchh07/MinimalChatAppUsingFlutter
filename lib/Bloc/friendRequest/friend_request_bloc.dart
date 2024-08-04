import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:chat_app/Bloc/friendRequest/friend_request_event.dart';
import 'package:chat_app/Bloc/friendRequest/friend_request_state.dart';
import 'package:chat_app/services/chat_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FriendRequestBloc extends Bloc<FriendRequestEvent, FriendRequestState> {
  final FirebaseFirestore firestore;
  StreamSubscription<QuerySnapshot>? _friendRequestListener;
  FriendRequestBloc(this.firestore) : super(FriendRequestInitial()) {
    on<SendFriendRequest>(_onSendFriendRequest);
    on<AcceptFriendRequest>(_onAcceptFriendRequest);
    on<RejectFriendRequest>(_onRejectFriendRequest);
    on<CancelFriendRequest>(_onCancelFriendRequest);
    on<CheckFriendRequestStatus>(_onCheckFriendRequestStatus);
    on<StartListeningForFriendRequests>(_onStartListeningForFriendRequests);
    on<LoadRequestedUsers>(_loadRequestedUsers);
  }

  void _onSendFriendRequest(
      SendFriendRequest event, Emitter<FriendRequestState> emit) async {
    emit(FriendRequestSending());
    try {
      await firestore
          .collection('users')
          .doc(event.toUserId)
          .collection('friendRequests')
          .doc(event.fromUserId)
          .set({
        'fromUserId': event.fromUserId,
        'toUserId': event.toUserId,
        'status': 'pending',
        'timestamp': FieldValue.serverTimestamp(),
      });

      await firestore
          .collection('users')
          .doc(event.fromUserId)
          .collection('friendRequests')
          .doc(event.toUserId)
          .set({
        'fromUserId': event.fromUserId,
        'toUserId': event.toUserId,
        'status': 'pending',
        'timestamp': FieldValue.serverTimestamp(),
      });
      log("Friend Request sent");
      emit(FriendRequestSent());
      emit(FriendRequestStatusLoaded(true));
    } catch (e) {
      emit(FriendRequestError(e.toString()));
      emit(FriendRequestStatusLoaded(false));
    }
  }

  void _onAcceptFriendRequest(
      AcceptFriendRequest event, Emitter<FriendRequestState> emit) async {
    emit(FriendRequestProcessing());
    try {
      // Update the status to accepted for both users' friendRequests subcollections
      await firestore
          .collection('users')
          .doc(event.userId)
          .collection('friendRequests')
          .doc(event.fromUserId)
          .update({
        'status': 'accepted',
        'timestamp': FieldValue.serverTimestamp(),
      });

      await firestore
          .collection('users')
          .doc(event.fromUserId)
          .collection('friendRequests')
          .doc(event.userId)
          .update({
        'status': 'accepted',
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Add each user to the other's friends collection
      await firestore.runTransaction((transaction) async {
        transaction.set(
            firestore
                .collection('users')
                .doc(event.userId)
                .collection('friends')
                .doc(event.fromUserId),
            {
              'timestamp': FieldValue.serverTimestamp(),
            });

        transaction.set(
            firestore
                .collection('users')
                .doc(event.fromUserId)
                .collection('friends')
                .doc(event.userId),
            {
              'timestamp': FieldValue.serverTimestamp(),
            });
      });

      emit(FriendRequestAccepted());
      // emit(FriendRequestStatusLoaded(true));
    } catch (e) {
      emit(FriendRequestError(e.toString()));
      // emit(FriendRequestStatusLoaded(false));
    }
  }

  void _onRejectFriendRequest(
      RejectFriendRequest event, Emitter<FriendRequestState> emit) async {
    emit(FriendRequestProcessing());
    try {
      // Update the status to rejected for both users' friendRequests subcollections
      await firestore
          .collection('users')
          .doc(event.userId)
          .collection('friendRequests')
          .doc(event.fromUserId)
          .update({
        'status': 'rejected',
        'timestamp': FieldValue.serverTimestamp(),
      });

      await firestore
          .collection('users')
          .doc(event.fromUserId)
          .collection('friendRequests')
          .doc(event.userId)
          .update({
        'status': 'rejected',
        'timestamp': FieldValue.serverTimestamp(),
      });

      emit(FriendRequestRejected());
      emit(FriendRequestStatusLoaded(false));
    } catch (e) {
      emit(FriendRequestError(e.toString()));
      emit(FriendRequestStatusLoaded(false));
    }
  }

  void _onCancelFriendRequest(
      CancelFriendRequest event, Emitter<FriendRequestState> emit) async {
    emit(FriendRequestSending());
    try {
      // await firestore.collection('users').doc(event.toUserId).update({
      //   'friendRequests.${event.fromUserId}': FieldValue.delete(),
      // });

      await firestore
          .collection('users')
          .doc(event.toUserId)
          .collection('friendRequests')
          .doc(event.fromUserId)
          .update({
        'status': 'cancelled',
        'timestamp': FieldValue.serverTimestamp(),
      });
      await firestore
          .collection('users')
          .doc(event.fromUserId)
          .collection('friendRequests')
          .doc(event.toUserId)
          .update({
        'status': 'cancelled',
        'timestamp': FieldValue.serverTimestamp(),
      });

      log("Friend Request cancelled");
      emit(FriendRequestCancelled());
      emit(FriendRequestStatusLoaded(false));
    } catch (e) {
      emit(FriendRequestError(e.toString()));
    }
  }

  void _onCheckFriendRequestStatus(
      CheckFriendRequestStatus event, Emitter<FriendRequestState> emit) async {
    log("CheckStatus function started");
    emit(FriendRequestInitial());
    try {
      // Fetch the friend request status
      DocumentSnapshot doc = await firestore
          .collection('users')
          .doc(event.friendId) // Target user
          .collection('friendRequests')
          .doc(event.userId) // Current user
          .get();

      log("Document snapshot: ${doc.toString()}");

      if (doc.exists) {
        log("Document exists");

        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        String status =
            data?['status'] ?? 'none'; // Default to 'none' if no status

        log("Retrieved status: '$status'");

        // Check the status and emit the appropriate state
        if (status.trim() == 'pending') {
          log("Status is 'pending'");
          emit(FriendRequestStatusLoaded(true));
        } else if (status.trim() == 'accepted') {
          log("Status is accepted");
          emit(AlreadyFriends());
        } else {
          log("Status is not 'pending'");
          emit(FriendRequestStatusLoaded(false));
        }
      } else {
        log("Document does not exist");
        // No document means no friend request exists
        emit(FriendRequestStatusLoaded(false));
      }
    } catch (e) {
      log("Error occurred: ${e.toString()}");
      emit(FriendRequestError(e.toString()));
    }
  }

  void _onStartListeningForFriendRequests(
      StartListeningForFriendRequests event, Emitter<FriendRequestState> emit) {
    _friendRequestListener = firestore
        .collection('users')
        .doc(event.userId) // Listening for friend requests to this user
        .collection('friendRequests')
        .snapshots()
        .listen((snapshot) {
      List<Map<String, dynamic>> friendRequests = [];
      for (var change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.added) {
          Map<String, dynamic>? data =
              change.doc.data() as Map<String, dynamic>?;
          String status = data?['status'] ?? 'none';
          if (status == 'pending') {
            // Add pending friend request to the list
            friendRequests.add({
              'fromUserId': data?['fromUserId'],
              'status': status,
              'timestamp': data?['timestamp'],
            });
          }
        }
      }
      // Emit the state with the updated list of friend requests
      if (emit.isDone) return;
      emit(FriendRequestNotification(true, friendRequests));
    });
  }

  FutureOr<void> _loadRequestedUsers(
      LoadRequestedUsers event, Emitter<FriendRequestState> emit) async {
    try {
      ChatService _chatService = ChatService();
      final usersStream =
          _chatService.getUsersStreamExcludingBlockedAndPending();
      final users = await usersStream.first;
      emit(RequestedUsersLoaded(users));
    } catch (e) {
      log("Error In loading requested users:" + e.toString());
      // emit(UsersError());
    }
  }

  @override
  Future<void> close() {
    _friendRequestListener?.cancel();
    return super.close();
  }
}
