import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'fetch_story_event.dart';
part 'fetch_story_state.dart';

class FetchStoryBloc extends Bloc<FetchStoryEvent, FetchStoryState> {
  FetchStoryBloc() : super(FetchStoryInitial()) {
    on<FetchStories>(_fetchStories);
  }
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FutureOr<void> _fetchStories(
      FetchStories event, Emitter<FetchStoryState> emit) async {
    emit(StoriesLoading());
    try {
      User? user = FirebaseAuth.instance.currentUser;
      String currentUserId = user!.uid;

      // Fetch blocked users
      final blockedUsersSnapshot = await _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('BlockedUsers')
          .get();

      List<String> blockedUsers =
          blockedUsersSnapshot.docs.map((doc) => doc.id).toList();

      // Fetch all stories excluding the current user and blocked users
      final storiesSnapshot = await _firestore
          .collection('stories')
          .where('userId', isNotEqualTo: currentUserId)
          .get();


      final  mystories = await _firestore
          .collection('stories')
          .doc(currentUserId)
          .collection('storiesUrl')
          .get();

          DocumentSnapshot<Map<String, dynamic>> userDoc =
          await _firestore.collection('stories').doc(currentUserId).get();

          
        // String? name = userDoc.data()?['name'];
        String imageUrl = userDoc.data()?['storiesUrl'];
      
      
      List<Map<String, dynamic>> stories = storiesSnapshot.docs.map((doc) {
        return doc.data();
      }).where((story) {
        return !blockedUsers.contains(story['userId']);
      }).toList();
      // String myStoriesData = mystories.docs.map((doc) => doc.data()).toString();
      emit(StoriesLoaded(stories, imageUrl));
    } catch (e) {
      emit(StoryLoadFailure(e.toString()));
    }
  }
}
