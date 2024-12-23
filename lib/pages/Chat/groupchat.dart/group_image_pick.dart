// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:chat_app/Bloc/GroupChatBloc/groupchat_bloc.dart';
import 'package:chat_app/Bloc/GroupInfoBloc/group_info_bloc.dart';
import 'package:chat_app/Bloc/GroupInfoBloc/group_info_event.dart';
import 'package:chat_app/Bloc/GroupInfoBloc/group_info_state.dart';
import 'package:chat_app/pages/Chat/groupchat.dart/groupchat_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constants/colors/colors.dart';
import '../../Login&signUp/sign_uppage.dart';

class GroupImagePick extends StatefulWidget {
  final String groupName;
  final String groupId;

  GroupImagePick({super.key, required this.groupName, required this.groupId});

  @override
  State<GroupImagePick> createState() => _GroupImagePickState();
}

class _GroupImagePickState extends State<GroupImagePick> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GroupInfoBloc(
        firestore: FirebaseFirestore.instance,
        firebaseStorage: FirebaseStorage.instance,
      ),
      child: DefaultTabController(
        length: 2, // Number of tabs
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: appBackgroundColor,
            title: Text('Edit Group Info'),
            bottom: TabBar(
              tabs: [
                Tab(text: 'Group Name'),
                Tab(text: 'Group Image'),
              ],
            ),
          ),
          backgroundColor: appBackgroundColor,
          body: TabBarView(
            children: [
              _GroupNameEditor(groupId: widget.groupId),
              _GroupImageEditor(groupId: widget.groupId),
            ],
          ),
        ),
      ),
    );
  }
}

class _GroupNameEditor extends StatelessWidget {
  final String groupId;

  _GroupNameEditor({required this.groupId});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GroupInfoBloc, GroupInfoState>(
      listener: (context, state) {
        if (state is GroupNameUpdatedState) {
          Get.snackbar(
            "Success",
            "Group name updated successfully!",
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: Duration(seconds: 1),
          );
          // Navigator.pop(context);
          BlocProvider.of<GroupchatBloc>(context).add(GroupChatLoadEvent());

          Navigator.pop(context, true);
        }
      },
      builder: (context, state) {
        if (state is GroupInfoInitial) {
          context
              .read<GroupInfoBloc>()
              .add(GetGroupNameEvent(groupId: groupId));
          return Center(child: CupertinoActivityIndicator());
        } else if (state is GroupNameLoaded) {
          TextEditingController _controller =
              TextEditingController(text: state.groupName);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextFormField(
                  cursorColor: greenColor,
                  controller: _controller,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Name';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.go,
                  decoration: InputDecoration(
                    floatingLabelStyle:
                        TextStyle(color: primaryColor, fontSize: 13),
                    focusedBorder: customFocusBorder(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(color: primaryColor, width: 2),
                    ),
                    prefixIcon: Icon(
                      CupertinoIcons.person_3_fill,
                      color: greyColor,
                    ),
                    labelStyle:
                        GoogleFonts.inter(color: greyColor, fontSize: 13),
                    hintText: 'Password',
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  height: 45,
                  width: 250,
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                    color: greenColor,
                    onPressed: () {
                      context.read<GroupInfoBloc>().add(UpdateGroupNameEvent(
                            groupId: groupId,
                            groupName: _controller.text,
                          ));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Update',
                          style: GoogleFonts.inter(
                            textStyle: TextStyle(
                              color: whiteColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        } else if (state is GroupInfoLoadingState) {
          return Center(child: CupertinoActivityIndicator());
        } else if (state is GroupInfoErrorState) {
          return Center(child: Text('Error: ${state.message}'));
        }

        return SizedBox.shrink();
      },
    );
  }
}

class _GroupImageEditor extends StatelessWidget {
  final String groupId;

  _GroupImageEditor({required this.groupId});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GroupInfoBloc, GroupInfoState>(
      listener: (context, state) {
        if (state is ImageUpdatedState) {
          Get.snackbar(
            "Success",
            "Group image updated successfully!",
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: Duration(seconds: 3),
          );
          Navigator.pop(context);
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        if (state is ImagePickedState) {
          return Column(
            children: [
              Image.file(state.imageFile, height: 200, width: 200),
              SizedBox(height: 20),
              SizedBox(
                height: 45,
                width: 250,
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  color: greenColor,
                  onPressed: () {
                    context.read<GroupInfoBloc>().add(UpdateImageEvent(
                          imageFile: state.imageFile,
                          groupId: groupId,
                        ));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Upload Image',
                        style: GoogleFonts.inter(
                          textStyle: TextStyle(
                            color: whiteColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          );
        } else if (state is ImageUpdatingState) {
          return Center(child: CupertinoActivityIndicator());
        } else if (state is GroupInfoErrorState) {
          return Center(child: Text('Error: ${state.message}'));
        }

        return Center(
            child: SizedBox(
          height: 45,
          width: 250,
          child: MaterialButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            color: greenColor,
            onPressed: () {
              context.read<GroupInfoBloc>().add(PickImageEvent());
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Pick Image',
                  style: GoogleFonts.inter(
                    textStyle: TextStyle(
                      color: whiteColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
      },
    );
  }
}
