import 'package:flutter/material.dart';

class AppSize extends StatelessWidget {
  final context;
  const AppSize({super.key, required this.context});

  height() {
    return MediaQuery.of(context).size.height;
  }

  width() {
    return MediaQuery.of(context).size.width;
  }

  boldText() => height() * 0.025;

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}



// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:your_app/blocs/create_chat_room/create_chat_room_bloc.dart';
// import 'package:your_app/blocs/create_chat_room/create_chat_room_event.dart';
// import 'package:your_app/blocs/create_chat_room/create_chat_room_state.dart';
// import 'package:your_app/blocs/user/user_bloc.dart';
// import 'package:your_app/blocs/user/user_event.dart';
// import 'package:your_app/blocs/user/user_state.dart';
// import 'package:your_app/models/user_model.dart';

// class CreateChatRoomScreen extends StatefulWidget {
//   @override
//   _CreateChatRoomScreenState createState() => _CreateChatRoomScreenState();
// }

// class _CreateChatRoomScreenState extends State<CreateChatRoomScreen> {
//   final TextEditingController _chatRoomNameController = TextEditingController();
//   final List<String> _selectedMemberIds = [];

//   @override
//   void initState() {
//     super.initState();
//     context.read<UserBloc>().add(LoadUsers());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Create Group Chat Room'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _chatRoomNameController,
//               decoration: InputDecoration(
//                 labelText: 'Chat Room Name',
//               ),
//             ),
            
//             ElevatedButton(
//               onPressed: () {
//                 context.read<CreateChatRoomBloc>().add(
//                   CreateChatRoomRequested(
//                     _chatRoomNameController.text,
//                     _selectedMemberIds,
//                   ),
//                 );
//               },
//               child: Text('Create'),
//             ),
//             BlocBuilder<CreateChatRoomBloc, CreateChatRoomState>(
//               builder: (context, state) {
//                 if (state is CreateChatRoomLoading) {
//                   return CircularProgressIndicator();
//                 } else if (state is CreateChatRoomSuccess) {
//                   return Text('Chat Room Created Successfully!');
//                 } else if (state is CreateChatRoomFailure) {
//                   return Text('Failed to create chat room: ${state.error}');
//                 } else {
//                   return Container();
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

