abstract class FriendRequestState {}

class FriendRequestInitial extends FriendRequestState {}

class FriendRequestSending extends FriendRequestState {}

class FriendRequestSent extends FriendRequestState {}

class FriendRequestProcessing extends FriendRequestState {}

class FriendRequestAccepted extends FriendRequestState {}

class FriendRequestRejected extends FriendRequestState {}

class AlreadyFriends extends FriendRequestState {}

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

class FriendRequestNotification extends FriendRequestState {
  final bool hasPendingRequest; // Indicates if there's a pending request
  final List<Map<String, dynamic>> friendRequests; // List of friend requests

  FriendRequestNotification(this.hasPendingRequest,
      [this.friendRequests = const []]);
}

class RequestedUsersLoaded extends FriendRequestState {
  final List<Map<String, dynamic>> requestedUsers;

  RequestedUsersLoaded(this.requestedUsers);

  @override
  List<Object> get props => [requestedUsers];
}
