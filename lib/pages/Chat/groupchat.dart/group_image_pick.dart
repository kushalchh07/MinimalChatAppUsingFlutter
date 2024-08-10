import 'package:flutter/cupertino.dart';

class GroupImagePick extends StatefulWidget {
   GroupImagePick({super.key, required this.groupName, required this.groupId});
String groupName;
String groupId;
  @override
  State<GroupImagePick> createState() => _GroupImagePickState();
}

class _GroupImagePickState extends State<GroupImagePick> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}