import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'group_message_event.dart';
part 'group_message_state.dart';

class GroupMessageBloc extends Bloc<GroupMessageEvent, GroupMessageState> {
  GroupMessageBloc() : super(GroupMessageInitial()) {
    on<GroupMessageEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
