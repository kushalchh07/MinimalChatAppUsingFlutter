import 'package:chat_app/Bloc/profileImagebloc/profile_image_bloc.dart';
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
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: appBackgroundColor,
        width: Get.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocBuilder<ProfileImageBloc, ProfileImageState>(
              builder: (context, state) {
                if (state is ProfileImagePicked) {
                  return Image.file(state.image, height: 150);
                }
                if (state is ProfileImageUploading) {
                  return CircularProgressIndicator();
                }
                if (state is ProfileImageLoadFailure) {
                  return Text(state.error);
                }
                return Container(
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
                );
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.read<ProfileImageBloc>().add(PickProfileImage());
              },
              child: Text('Pick Image'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                final state = context.read<ProfileImageBloc>().state;
                if (state is ProfileImagePicked) {
                  context
                      .read<ProfileImageBloc>()
                      .add(UploadProfileImage(state.image));
                }
              },
              child: Text('Upload Image'),
            ),
          ],
        ),
      ),
    );
  }
}
