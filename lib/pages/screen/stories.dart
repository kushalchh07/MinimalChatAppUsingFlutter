// import 'dart:developer';

// import 'package:chat_app/Bloc/StoriesBloc/stories_bloc.dart';
// import 'package:chat_app/Bloc/fetchStoryBloc/fetch_story_bloc.dart';
// import 'package:chat_app/Bloc/fetchStoryBloc/fetch_story_state.dart';
// import 'package:chat_app/constants/colors/colors.dart';
// import 'package:chat_app/pages/screen/bigStoryScreen.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:get/get.dart';

// class Stories extends StatefulWidget {
//   const Stories({super.key});

//   @override
//   State<Stories> createState() => _StoriesState();
// }

// class _StoriesState extends State<Stories> {
//   @override
//   void initState() {
//     super.initState();
//     context.read<FetchStoryBloc>().add(FetchStories());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Stories"),
//         elevation: 0.2,
//         backgroundColor: appBackgroundColor,
//         actions: [
//           Image.asset(
//             "assets/images/chat.png",
//             height: 60,
//           ),
//         ],
//       ),
//       backgroundColor: appBackgroundColor,
//       body: BlocConsumer<FetchStoryBloc, FetchStoryState>(
//         listener: (context, state) {
//           if (state is StoryLoadFailure) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                   content: Text('Failed to load stories: ${state.message}')),
//             );
//           }
//           if (state is StoryUploaded) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text('Story uploaded successfully!')),
//             );
//           }
//         },
//         builder: (context, state) {
//           if (state is StoriesLoading) {
//             return Center(child: CupertinoActivityIndicator());
//           }
//           if (state is StoriesLoaded) {
//             final myStories = state.myStoriesUrls;
//             final otherUsersStories = state.otherUsersStories;
//             log("Mystoreis url " + myStories.toString());
//             log("OthersStoriesUrl" + otherUsersStories.toString());
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Display My Stories
//                 if (myStories.isNotEmpty)
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'My Stories',
//                           style: Theme.of(context).textTheme.titleLarge,
//                         ),
//                         SizedBox(height: 10),
//                         SizedBox(
//                           height: 220,
//                           child: ListView.builder(
//                             scrollDirection: Axis.horizontal,
//                             itemCount: myStories.length,
//                             itemBuilder: (context, index) {
//                               // Safely access the URL
//                               if (index < myStories.length) {
//                                 final url = myStories[index]['url'];
//                                 // Ensure url is a string
//                                 // log(url.toString());
//                                 if (url is String) {
//                                   return Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 4),
//                                     child: Card(
//                                       color: appSecondary,
//                                       elevation: 2.0,
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(15.0),
//                                       ),
//                                       child: InkWell(
//                                         onTap: () =>
//                                             Get.to(Bigstoryscreen(url: url)),
//                                         child: Container(
//                                           width: Get.width * 0.4,
//                                           height: 200,
//                                           decoration: BoxDecoration(
//                                             borderRadius:
//                                                 BorderRadius.circular(15),
//                                             image: DecorationImage(
//                                               image: NetworkImage(url),
//                                               fit: BoxFit.cover,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   );
//                                 }
//                               }
//                               return SizedBox.shrink();
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                 // Display Other Users' Stories
//                 if (otherUsersStories.isNotEmpty)
//                   Expanded(
//                     child: GridView.builder(
//                       padding: EdgeInsets.all(8),
//                       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: otherUsersStories.length < 2 ? 1 : 2,
//                         crossAxisSpacing: 10,
//                         mainAxisSpacing: 10,
//                         childAspectRatio: 1.0,
//                       ),
//                       itemCount: otherUsersStories.length,
//                       itemBuilder: (context, index) {
//                         // Safely access the story
//                         if (index < otherUsersStories.length) {
//                           // final story = otherUsersStories[index];
//                           // log("Story: $story");
//                           // final urlList =
//                           //     story['storiesUrl'] as List<dynamic>? ?? [];
//                           // log("urlList:" + urlList.toString());
//                           final story = otherUsersStories[index];
//                           log("Story: $story");

//                           final urlList =
//                               story['storiesUrl'] as List<dynamic>? ?? [];
//                           log("urlList: $urlList");

// // Extract URLs from the urlList
//                           final urls = urlList
//                               .map((urlMap) {
//                                 if (urlMap is Map<String, dynamic>) {
//                                   return urlMap['url'] as String;
//                                 }
//                                 return null;
//                               })
//                               .where((url) => url != null)
//                               .toList();

//                           log("Extracted URLs: $urls");
//                           // Ensure urlList is not empty and url is a string
//                           if (urls.isNotEmpty && urls[1] is String) {
//                             final url = urls[index] as String;
//                             log("url matra yo ho hai " + url);
//                             return Card(
//                               color: appSecondary,
//                               elevation: 2.0,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(15.0),
//                               ),
//                               child: InkWell(
//                                 onTap: () => Get.to(Bigstoryscreen(url: url)),
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(15),
//                                     image: DecorationImage(
//                                       image: NetworkImage(url),
//                                       fit: BoxFit.cover,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             );
//                           }
//                         }
//                         log("Shrink ma ho hai ma");
//                         // return SizedBox.shrink();
//                       },
//                     ),
//                   ),
//               ],
//             );
//           }
//           return Center(child: Text('No stories available.'));
//         },
//       ),
//       floatingActionButton: BlocBuilder<StoriesBloc, StoriesState>(
//         builder: (context, state) {
//           if (state is StoryPicked) {
//             return FloatingActionButton(
//               onPressed: () {
//                 context.read<StoriesBloc>().add(StoryUpload(state.image));
//                 Future.delayed(Duration(seconds: 4), () {
//                   context.read<FetchStoryBloc>().add(FetchStories());
//                 });
//               },
//               child: Text("Upload"),
//             );
//           }
//           return FloatingActionButton(
//             onPressed: () => _uploadStory(context),
//             child: Icon(Icons.add),
//           );
//         },
//       ),
//     );
//   }

//   void _uploadStory(BuildContext context) {
//     BlocProvider.of<StoriesBloc>(context).add(StoryPick());
//   }
// }
import 'dart:developer';

import 'package:chat_app/Bloc/StoriesBloc/stories_bloc.dart';
import 'package:chat_app/Bloc/fetchStoryBloc/fetch_story_bloc.dart';
import 'package:chat_app/Bloc/fetchStoryBloc/fetch_story_state.dart';
import 'package:chat_app/constants/colors/colors.dart';
import 'package:chat_app/pages/screen/bigStoryScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class Stories extends StatefulWidget {
  const Stories({super.key});

  @override
  State<Stories> createState() => _StoriesState();
}

class _StoriesState extends State<Stories> {
  @override
  void initState() {
    super.initState();
    // context.read<FetchStoryBloc>().add(FetchStories());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Stories"),
        elevation: 0.2,
        backgroundColor: appBackgroundColor,
        actions: [
          Image.asset(
            "assets/images/chat.png",
            height: 60,
          ),
        ],
      ),
      backgroundColor: appBackgroundColor,
      body: BlocConsumer<FetchStoryBloc, FetchStoryState>(
        listener: (context, state) {
          if (state is StoryLoadFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('Failed to load stories: ${state.message}')),
            );
          }
          if (state is StoryUploaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Story uploaded successfully!')),
            );
          }
        },
        builder: (context, state) {
          if (state is FetchStoryInitial) {
            context.read<FetchStoryBloc>().add(FetchStories());
          }
          if (state is StoriesLoading) {
            return Center(child: CupertinoActivityIndicator());
          }
          if (state is StoriesLoaded) {
            final myStories = state.myStoriesUrls;
            final otherUsersStories = state.otherUsersStories;
            // log("Mystoreis url " + myStories.toString());
            // log("OthersStoriesUrl" + otherUsersStories.toString());
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display My Stories
                if (myStories.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'My Stories',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          height: 220,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: myStories.length,
                            itemBuilder: (context, index) {
                              // Safely access the URL
                              if (index < myStories.length) {
                                final url = myStories[index]['url'];
                                // Ensure url is a string
                                // log(url.toString());
                                if (url is String) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    child: Card(
                                      color: appSecondary,
                                      elevation: 2.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      child: InkWell(
                                        onTap: () =>
                                            Get.to(Bigstoryscreen(url: url)),
                                        child: Container(
                                          width: Get.width * 0.4,
                                          height: 200,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            image: DecorationImage(
                                              image: NetworkImage(url),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              }
                              return SizedBox.shrink();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                // Display Other Users' Stories
                if (otherUsersStories.isNotEmpty)
                  SizedBox(
                    height: 220,
                    child: GridView.builder(
                      padding: EdgeInsets.all(8),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 1.0,
                        mainAxisExtent: 220,
                      ),
                      itemCount: otherUsersStories.length,
                      itemBuilder: (context, index) {
                        // Safely access the story
                        if (index < otherUsersStories.length) {
                          final story = otherUsersStories[index];
                          // log("Story: $story");

                          final urlList =
                              story['storiesUrl'] as List<dynamic>? ?? [];
                          // log("urlList: $urlList");

                          // Extract URLs from the urlList
                          final urls = urlList
                              .map((urlMap) {
                                if (urlMap is Map<String, dynamic>) {
                                  return urlMap['url'] as String?;
                                }
                                return null;
                              })
                              .where((url) => url != null)
                              .cast<String>()
                              .toList();

                          // log("Extracted URLs: $urls");
                          // Ensure urlList is not empty and url is a string
                          if (urls.isNotEmpty && urls.length > index) {
                            final ur = urls[0];
                            // log("url matra yo ho hai " + ur);
                            return Card(
                              color: appSecondary,
                              elevation: 2.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: InkWell(
                                onTap: () => Get.to(Bigstoryscreen(url: ur)),
                                child: Container(
                                  height: 220,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    image: DecorationImage(
                                      image: NetworkImage(ur),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                        }
                        return SizedBox.shrink();
                      },
                    ),
                  ),
              ],
            );
          }
          return Center(child: Text('No stories available.'));
        },
      ),
      floatingActionButton: BlocBuilder<StoriesBloc, StoriesState>(
        builder: (context, state) {
          if (state is StoryUploading) {
            return CupertinoActivityIndicator();
          }
          if (state is StoryPicked) {
            return FloatingActionButton(
              onPressed: () {
                context.read<StoriesBloc>().add(StoryUpload(state.image));
                Future.delayed(Duration(seconds: 4), () {
                  context.read<FetchStoryBloc>().add(FetchStories());
                });
              },
              child: Text("Upload"),
            );
          }
          return FloatingActionButton(
            onPressed: () => _uploadStory(context),
            child: Icon(Icons.add),
          );
        },
      ),
    );
  }

  void _uploadStory(BuildContext context) {
    BlocProvider.of<StoriesBloc>(context).add(StoryPick());
  }
}
