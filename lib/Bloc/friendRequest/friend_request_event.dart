abstract class FriendRequestEvent {}

class SendFriendRequest extends FriendRequestEvent {
  final String fromUserId;
  final String toUserId;

  SendFriendRequest(this.fromUserId, this.toUserId);
}

class AcceptFriendRequest extends FriendRequestEvent {
  final String userId;
  final String fromUserId;

  AcceptFriendRequest(this.userId, this.fromUserId);
}

class RejectFriendRequest extends FriendRequestEvent {
  final String userId;
  final String fromUserId;

  RejectFriendRequest(this.userId, this.fromUserId);
}

class CancelFriendRequest extends FriendRequestEvent {
  final String fromUserId;
  final String toUserId;

  CancelFriendRequest(this.fromUserId, this.toUserId);

  @override
  List<Object> get props => [fromUserId, toUserId];
}

class CheckFriendRequestStatus extends FriendRequestEvent {
  final String userId;
  final String friendId;

  CheckFriendRequestStatus(this.userId, this.friendId);

  @override
  List<Object> get props => [userId, friendId];
}
class StartListeningForFriendRequests extends FriendRequestEvent{

  final String userId;

  StartListeningForFriendRequests(this.userId);
}
