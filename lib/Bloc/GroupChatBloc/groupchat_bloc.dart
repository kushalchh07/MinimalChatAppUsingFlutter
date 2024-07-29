import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'groupchat_event.dart';
part 'groupchat_state.dart';

class GroupchatBloc extends Bloc<GroupchatEvent, GroupchatState> {
  GroupchatBloc() : super(GroupchatInitial()) {
    on<GroupchatEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
