import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UsersLoading()) {
    on<LoadUsers>(_onLoadUsers);
  }

  Future<void> _onLoadUsers(LoadUsers event, Emitter<UserState> emit) async {
    emit(UsersLoading());
    try {
      final QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('users').get();
      final users = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      emit(UsersLoaded(users));
    } catch (_) {
      emit(UsersError());
    }
  }
}
