import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'fetch_story_state.dart';

part 'fetch_story_event.dart';

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
      if (user == null) throw Exception('User not authenticated');

      String currentUserId = user.uid;

      // Fetch blocked users
      final blockedUsersSnapshot = await _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('BlockedUsers')
          .get();

      List<String> blockedUsers =
          blockedUsersSnapshot.docs.map((doc) => doc.id).toList();
      log('BlockedUsers: $blockedUsers');
      // Fetch current user's stories URLs
      DocumentSnapshot<Map<String, dynamic>> userDoc =
          await _firestore.collection('stories').doc(currentUserId).get();

      List<dynamic> myStoriesUrls = userDoc.data()?['storiesUrl'] ?? [];
      log('My Stories URLs: $myStoriesUrls');

      // Fetch all stories
      final storiesSnapshot = await _firestore.collection('stories').get();
      log('Total stories fetched: ${storiesSnapshot.docs.length}');

      // Filter out the current user's and blocked users' stories
      List<Map<String, dynamic>> otherUsersStories = storiesSnapshot.docs
          .where((doc) {
            String userId = doc.id;
            return userId != currentUserId && !blockedUsers.contains(userId);
          })
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      log('Other users\' stories (after filtering): $otherUsersStories');

      emit(StoriesLoaded(myStoriesUrls, otherUsersStories));
    } catch (e) {
      emit(StoryLoadFailure(e.toString()));
    }
  }
}
