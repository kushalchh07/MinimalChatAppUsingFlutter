import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
final Color color;
  ChatBubble({super.key, required this.message,required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: color,
      ),
      child: Text(message, style: TextStyle(fontSize: 16, color: Colors.white)),
    );
  }
}
