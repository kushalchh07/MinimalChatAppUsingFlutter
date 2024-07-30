import 'package:chat_app/Bloc/StoriesBloc/stories_bloc.dart';
import 'package:chat_app/constants/colors/colors.dart';
import 'package:flutter/foundation.dart';
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
      body: Container(
        child: Column(
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
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 160,
                            left: 35,
                            child: ElevatedButton(
                                onPressed: () {}, child: Text("Upload Story")),
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
                // Card(
                //   color: appSecondary,
                //   elevation: 2.0,
                //   shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(15.0),
                //   ),
                //   child: InkWell(
                //     onTap: () => _uploadStory(context),
                //     child: Container(
                //       width: Get.width * 0.46,
                //       height: 200,
                //       alignment: Alignment.center,
                //       child: Text(
                //         'Upload Story',
                //         style: TextStyle(
                //             fontSize: 20, fontWeight: FontWeight.bold),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            )
          ],
        ),
      ),
    );
  }

  _uploadStory(BuildContext context) {
    BlocProvider.of<StoriesBloc>(context).add(StoryPick());
  }
}
