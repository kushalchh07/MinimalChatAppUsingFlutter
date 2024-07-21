import 'package:bloc/bloc.dart';
import 'package:chat_app/services/chat_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UsersLoading()) {
    on<LoadUsers>(_onLoadUsers);
  }
  ChatService _chatService = ChatService();
  Future<void> _onLoadUsers(LoadUsers event, Emitter<UserState> emit) async {
    emit(UsersLoading());
    try {
      final QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('users').get();
      final users = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      // final usersStream =  _chatService.getUsersStreamExcludingBlocked();
// Change the type of users to List<List<Map<String, dynamic>>>
// List<List<Map<String, dynamic>>> users = await usersStream.toList();
     emit(UsersLoaded(users));
    } catch (_) {
      emit(UsersError());
    }
  }
}
