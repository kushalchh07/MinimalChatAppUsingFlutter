import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:chat_app/Bloc/friendRequest/friend_request_event.dart';
import 'package:chat_app/Bloc/friendRequest/friend_request_state.dart';
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
      emit(FriendRequestNotification(true, friendRequests));
    });
  }

  @override
  Future<void> close() {
    _friendRequestListener?.cancel();
    return super.close();
  }
}
