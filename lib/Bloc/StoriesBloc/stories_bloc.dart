import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'stories_event.dart';
part 'stories_state.dart';

class StoriesBloc extends Bloc<StoriesEvent, StoriesState> {
  StoriesBloc() : super(StoriesInitial()) {
    on<StoriesEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
