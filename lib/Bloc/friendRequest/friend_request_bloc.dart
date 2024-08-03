import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:chat_app/Bloc/friendRequest/friend_request_event.dart';
import 'package:chat_app/Bloc/friendRequest/friend_request_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FriendRequestBloc extends Bloc<FriendRequestEvent, FriendRequestState> {
  final FirebaseFirestore firestore;

  FriendRequestBloc(this.firestore) : super(FriendRequestInitial()) {
    on<SendFriendRequest>(_onSendFriendRequest);
    on<AcceptFriendRequest>(_onAcceptFriendRequest);
    on<RejectFriendRequest>(_onRejectFriendRequest);
    on<CancelFriendRequest>(_onCancelFriendRequest);
    on<CheckFriendRequestStatus>(_onCheckFriendRequestStatus);
  }

  void _onSendFriendRequest(
      SendFriendRequest event, Emitter<FriendRequestState> emit) async {
    emit(FriendRequestSending());
    try {
      String path =
          'users/${event.toUserId}/friendRequests/${event.fromUserId}';
      log("Creating/updating document at path: $path");

      await firestore.doc(path).set({
        'status': 'pending',
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Verify document creation
      DocumentSnapshot doc = await firestore.doc(path).get();
      if (doc.exists) {
        log("Document created successfully: ${doc.data()}");
      } else {
        log("Failed to create document or document not found after creation");
      }

      emit(FriendRequestSent());
      emit(FriendRequestStatusLoaded(true));
    } catch (e) {
      log("Error sending friend request: ${e.toString()}");
      emit(FriendRequestError(e.toString()));
      emit(FriendRequestStatusLoaded(false));
    }
  }

  void _onAcceptFriendRequest(
      AcceptFriendRequest event, Emitter<FriendRequestState> emit) async {
    try {
      DocumentSnapshot userDoc =
          await firestore.collection('users').doc(event.userId).get();
      if (userDoc.exists) {
        String fromUserId = event.fromUserId;

        await firestore.runTransaction((transaction) async {
          // Add each user to the other's friends collection
          transaction.update(firestore.collection('users').doc(event.userId), {
            'friends.$fromUserId': {
              'timestamp': FieldValue.serverTimestamp(),
            },
            'friendRequests.$fromUserId': FieldValue.delete(),
          });

          transaction.update(firestore.collection('users').doc(fromUserId), {
            'friends.${event.userId}': {
              'timestamp': FieldValue.serverTimestamp(),
            },
          });
        });

        emit(FriendRequestAccepted());
      } else {
        emit(FriendRequestError('User not found'));
      }
    } catch (e) {
      emit(FriendRequestError(e.toString()));
    }
  }

  void _onRejectFriendRequest(
      RejectFriendRequest event, Emitter<FriendRequestState> emit) async {
    try {
      await firestore.collection('users').doc(event.userId).update({
        'friendRequests.${event.fromUserId}': FieldValue.delete(),
      });
      emit(FriendRequestRejected());
    } catch (e) {
      emit(FriendRequestError(e.toString()));
    }
  }

  void _onCancelFriendRequest(
      CancelFriendRequest event, Emitter<FriendRequestState> emit) async {
    emit(FriendRequestSending());
    try {
      await firestore.collection('users').doc(event.toUserId).update({
        'friendRequests.${event.fromUserId}': FieldValue.delete(),
      });
      log("Friend Request cancelled");
      emit(FriendRequestCancelled());
    } catch (e) {
      emit(FriendRequestError(e.toString()));
    }
  }

  void _onCheckFriendRequestStatus(
      CheckFriendRequestStatus event, Emitter<FriendRequestState> emit) async {
    log("CheckStatus function started");

    try {
      String path = 'users/${event.friendId}/friendRequests/${event.userId}';
      log("Fetching document from path: $path");

      DocumentSnapshot doc = await firestore.doc(path).get();

      log("Document snapshot: ${doc.toString()}");

      if (doc.exists) {
        log("Document exists");

        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        String status =
            data?['status'] ?? 'none'; // Default to 'none' if no status

        log("Retrieved status: '$status'");

        if (status.trim() == 'pending') {
          log("Status is 'pending'");
          emit(FriendRequestStatusLoaded(true));
        } else {
          log("Status is not 'pending'");
          emit(FriendRequestStatusLoaded(false));
        }
      } else {
        log("Document does not exist");
        emit(FriendRequestStatusLoaded(false));
      }
    } catch (e) {
      log("Error occurred: ${e.toString()}");
      emit(FriendRequestError(e.toString()));
    }
  }
}
