// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/Bloc/userBloc/user_bloc.dart';
import 'package:chat_app/Bloc/userBloc/user_event.dart';
import 'package:chat_app/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Bloc/userBloc/user_state.dart';
import '../../../constants/colors/colors.dart';

class SeeMembers extends StatefulWidget {
  const SeeMembers({super.key, required this.groupId});
  final String groupId;

  @override
  State<SeeMembers> createState() => _SeeMembersState();
}

class _SeeMembersState extends State<SeeMembers> {
  @override
  void initState() {
    super.initState();
    log("See Members bhitra Init ma: ${widget.groupId}");
    BlocProvider.of<UserBloc>(context).add(LoadMembers(widget.groupId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('See Members'),
        backgroundColor: appBackgroundColor,
      ),
      backgroundColor: appBackgroundColor,
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is LoadMembersLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is LoadMembersSuccess) {
            final members = state.members;
            if (members.isEmpty) {
              return Center(
                child: Text("No members found."),
              );
            }
            return ListView.builder(
              itemCount: members.length,
              itemBuilder: (context, index) {
                final user = members[index];
                return _buildUserListItem(context, user);
              },
            );
          } else if (state is LoadMembersError) {
            return Center(
              child: Text(state.message),
            );
          }
          return Container();
        },
      ),
    );
  }
}

Widget _buildUserListItem(BuildContext context, Map<String, dynamic> user) {
  return Padding(
    padding: const EdgeInsets.only(top: 8.0, right: 4, left: 4),
    child: GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          color: appSecondary,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          minLeadingWidth: Checkbox.width,
          leading: Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.transparent,
              ),
            ),
            child: user['profileImageUrl'] == null ||
                    user['profileImageUrl'].isEmpty
                ? Container(
                    decoration: BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        getFirstandLastNameInitals(
                            user['name'] ?? ''.toUpperCase()),
                        style: TextStyle(color: whiteColor, fontSize: 20),
                      ),
                    ),
                  )
                : CachedNetworkImage(
                    imageBuilder: (context, imageProvider) {
                      return Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                    imageUrl: user['profileImageUrl'],
                    placeholder: (context, url) => Image.asset(
                      'assets/images/no-image.png',
                      fit: BoxFit.cover,
                      height: 60,
                      width: 60,
                    ),
                    errorWidget: (context, url, error) => Image.asset(
                      'assets/images/no-image.png',
                      height: 60,
                      width: 60,
                      fit: BoxFit.cover,
                    ),
                    fit: BoxFit.cover,
                  ),
          ),
          title: Text(
            user['name'] ?? 'No name',
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
          subtitle: Text(
            "Hello I am New Here.",
            style: TextStyle(fontFamily: 'poppins', fontSize: 16),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          dense: true,
          tileColor: Colors.grey[200],
        ),
      ),
    ),
  );
}
