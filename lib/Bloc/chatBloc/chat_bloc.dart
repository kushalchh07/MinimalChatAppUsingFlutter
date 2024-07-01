import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final FirebaseFirestore _firestore;

  ChatBloc(this._firestore) : super(ChatInitial()) {
    on<SendMessage>(_onSendMessage);
    on<LoadMessages>(_onLoadMessages);
  }

  void _onSendMessage(SendMessage event, Emitter<ChatState> emit) async {
    try {
      await _firestore.collection('messages').add({
        'message': event.message,
        'userId': event.userId,
        'timestamp': FieldValue.serverTimestamp(),
      });
      emit(MessageSent());
      add(LoadMessages());
    } catch (e) {
      emit(MessageFailure(e.toString()));
    }
  }

  void _onLoadMessages(LoadMessages event, Emitter<ChatState> emit) async {
    try {
      final messagesSnapshot = await _firestore
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .get();

      final messages = messagesSnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      emit(MessagesLoaded(messages));
    } catch (e) {
      emit(MessageFailure(e.toString()));
    }
  }
}
