// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:chat_app/Bloc/StoriesBloc/stories_bloc.dart';
import 'package:chat_app/Bloc/fetchStoryBloc/fetch_story_bloc.dart';
import 'package:chat_app/constants/colors/colors.dart';
import 'package:chat_app/pages/screen/bigStoryScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

    context.read<FetchStoryBloc>().add(FetchStories());
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
        // TODO: implement listener
      }, builder: (context, state) {
        if (state is StoriesLoading) {
          return Center(child: CupertinoActivityIndicator());
        }
        if (state is StoriesLoaded) {
          final stories = state.stories;
          final storyUrl = state.mystories;
          log(storyUrl);
          return Column(
            children: [
              Row(
                children: [
                  const SizedBox(
                    width: 4,
                  ),
                  BlocConsumer<StoriesBloc, StoriesState>(
                    listener: (context, state) {
                      // TODO: implement listener
                    },
                    builder: (context, state) {
                      if (state is StoryPicked) {
                        return Stack(
                          children: [
                            Card(
                              color: appSecondary,
                              elevation: 2.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: InkWell(
                                onTap: () => _uploadStory(context),
                                child: Container(
                                  width: Get.width * 0.46,
                                  height: 200,
                                  alignment: Alignment.center,
                                  child: Image.file(
                                    state.image,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 160,
                              left: 35,
                              child: ElevatedButton(
                                onPressed: () async {
                                  context
                                      .read<StoriesBloc>()
                                      .add(StoryUpload(state.image));
                                  context
                                      .read<FetchStoryBloc>()
                                      .add(FetchStories());
                                },
                                child: Text("Upload Story"),
                              ),
                            )
                          ],
                        );
                      }
                      return Card(
                        color: appSecondary,
                        elevation: 2.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: InkWell(
                          onTap: () => _uploadStory(context),
                          child: Container(
                            width: Get.width * 0.46,
                            height: 200,
                            alignment: Alignment.center,
                            child: Text(
                              'Upload Story',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    width: 2,
                  ),
                  Card(
                    color: appSecondary,
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: InkWell(
                      onTap: () => Get.to(Bigstoryscreen(
                        url: storyUrl,
                      )),
                      child: Container(
                        width: Get.width * 0.46,
                        height: 200,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)),
                        alignment: Alignment.center,
                        child: Image.network(
                          storyUrl,
                          fit: BoxFit.cover,
                          width: Get.width * 0.45,
                          height: 198,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: stories.length < 2
                        ? 2
                        : 2, // number of columns in the grid
                    crossAxisSpacing: 10, // horizontal space between items
                    mainAxisSpacing: 10, // vertical space between items
                    childAspectRatio:
                        1.0, // aspect ratio between child width and height
                  ),
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    final story = stories[index];
                    return Card(
                      color: appSecondary,
                      elevation: 2.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: InkWell(
                        onTap: () => Get.to(Bigstoryscreen(
                          url: story['storiesUrl'] ?? '',
                        )),
                        child: Container(
                          width: Get.width * 0.46,
                          height: 200,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)),
                          alignment: Alignment.center,
                          child: Image.network(
                            story['storiesUrl'] ?? '',
                            fit: BoxFit.cover,
                            width: Get.width * 0.44,
                            height: 196,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                // child: GridView.builder(
                //   itemCount: stories.length,
                //   itemBuilder: (context, index) {
                //     final story = stories[index];
                //     return Card(
                //       color: appSecondary,
                //       elevation: 2.0,
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(15.0),
                //       ),
                //       child: InkWell(
                //         onTap: () => Get.to(Bigstoryscreen(
                //           url: story['storiesUrl'],
                //         )),
                //         child: Container(
                //           width: Get.width * 0.46,
                //           height: 200,
                //           decoration: BoxDecoration(
                //               borderRadius: BorderRadius.circular(20)),
                //           alignment: Alignment.center,
                //           child: Image.network(
                //             story['storiesUrl'],
                //             fit: BoxFit.cover,
                //             width: Get.width * 0.45,
                //             height: 198,
                //           ),
                //         ),
                //       ),
                //     );
                //     // ListTile(
                //     //   title: Text('Story by ${story['userId']}'),
                //     //   subtitle: Image.network(story['storiesUrl']),
                //     //   onTap: () => Get.to(Bigstoryscreen(
                //     //     url: story['storiesUrl'],
                //     //   )),
                //     // );
                //   },
                // ),
              ),
            ],
          );
        }
        return Container();
      }),
    );
  }

  _uploadStory(BuildContext context) {
    BlocProvider.of<StoriesBloc>(context).add(StoryPick());
  }
}
