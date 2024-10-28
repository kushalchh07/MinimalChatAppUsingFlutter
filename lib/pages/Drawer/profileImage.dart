import 'package:chat_app/Bloc/profileImagebloc/profile_image_bloc.dart';
import 'package:chat_app/pages/screen/base.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../Bloc/profileImagebloc/profile_image_event.dart';
import '../../Bloc/profileImagebloc/profile_image_state.dart';
import '../../constants/colors/colors.dart';

class ProfileImage extends StatefulWidget {
  const ProfileImage({super.key});

  @override
  State<ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: appBackgroundColor,
        width: Get.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocConsumer<ProfileImageBloc, ProfileImageState>(
              listener: (context, state) {
                if (state is ProfileImageUploaded) {
                  Get.offAll(() => Base());
                }
              },
              builder: (context, state) {
                if (state is ProfileImagePicked) {
                  return GestureDetector(
                    onTap: () {
                      context.read<ProfileImageBloc>().add(PickProfileImage());
                    },
                    child: Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(75),
                        ),
                        child: Image.file(
                          state.image,
                          // height: 150,

                          fit: BoxFit.cover,
                        )),
                  );
                }
                if (state is ProfileImageUploading) {
                  return CupertinoActivityIndicator();
                }
                if (state is ProfileImageLoadFailure) {
                  return Text(state.error);
                }
                return GestureDetector(
                  onTap: () {
                    context.read<ProfileImageBloc>().add(PickProfileImage());
                  },
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(75),
                    ),
                    child: Icon(
                      Icons.person,
                      size: 75,
                      color: Colors.grey[600],
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: greenColor,
                shape: StadiumBorder(),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                minimumSize: Size(200, 40),
                maximumSize: Size(200, 40),
                elevation: 0,
                textStyle: TextStyle(color: Colors.white),
                side: BorderSide(color: greenColor),
              ),
              onPressed: () {
                final state = context.read<ProfileImageBloc>().state;
                if (state is ProfileImagePicked) {
                  context
                      .read<ProfileImageBloc>()
                      .add(UploadProfileImage(state.image));
                }
              },
              child: Text(
                'Upload Image',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
