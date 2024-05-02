import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;

  ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.blue,
      ),
      child: Text(message, style: TextStyle(fontSize: 16, color: Colors.white)),
    );
  }
}
