abstract class FriendRequestState {}

class FriendRequestInitial extends FriendRequestState {}

class FriendRequestSending extends FriendRequestState {}

class FriendRequestSent extends FriendRequestState {}

class FriendRequestAccepted extends FriendRequestState {}

class FriendRequestRejected extends FriendRequestState {}

class FriendRequestError extends FriendRequestState {
  final String message;

  FriendRequestError(this.message);
}

class FriendRequestCancelled extends FriendRequestState {}
class FriendRequestStatusLoaded extends FriendRequestState {
  final bool isRequestSent;

  FriendRequestStatusLoaded(this.isRequestSent);

  @override
  List<Object> get props => [isRequestSent];
}