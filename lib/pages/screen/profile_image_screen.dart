// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:chat_app/Bloc/profileImagebloc/profile_image_bloc.dart';
import 'package:chat_app/Bloc/profileImagebloc/profile_image_event.dart';
import 'package:chat_app/Bloc/profileImagebloc/profile_image_state.dart';
import 'package:chat_app/constants/colors/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class ProfileImageScreen extends StatefulWidget {
  const ProfileImageScreen({super.key});

  @override
  State<ProfileImageScreen> createState() => _ProfileImageScreenState();
}

class _ProfileImageScreenState extends State<ProfileImageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile Image"),
        centerTitle: true,
        backgroundColor: appBackgroundColor,
      ),
      body: Container(
        color: appBackgroundColor,
        height: Get.height,
        width: Get.width,
        child: Column(
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
                return Container();
              },
            ),
            ElevatedButton(
              onPressed: () {
                context.read<ProfileImageBloc>().add(PickProfileImage());
              },
              child: Text('Pick Image'),
            ),
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
            Expanded(
              child: BlocBuilder<ProfileImageBloc, ProfileImageState>(
                builder: (context, state) {
                  if (state is ProfileImagesLoaded) {
                    return ListView.builder(
                      itemCount: state.profileImageUrls.length,
                      itemBuilder: (context, index) {
                        return Image.network(state.profileImageUrls[index]);
                      },
                    );
                  }
                  if (state is ProfileImageLoadFailure) {
                    return Center(child: Text('Error: ${state.error}'));
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
