import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  final String content;
  final bool isUser;

  const ChatMessage({Key? key, required this.content, this.isUser = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: 8,
        ).add(
          isUser
              ? const EdgeInsets.only(left: 80)
              : const EdgeInsets.only(right: 80),
        ),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color:
              isUser ? const Color.fromRGBO(239, 180, 7, 1) : Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          content,
          style: TextStyle(
              color: isUser ? Colors.white : Colors.black, fontSize: 16),
        ),
      ),
    );
  }
}
