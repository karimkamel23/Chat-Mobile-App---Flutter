import 'package:chatapp/themes/theme_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  final Timestamp timestamp;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    DateTime datetime = timestamp.toDate();
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: isCurrentUser
                  ? (isDarkMode ? Colors.green.shade600 : Colors.green.shade500)
                  : (isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  message,
                  style: TextStyle(
                      color: isCurrentUser
                          ? Colors.white
                          : (isDarkMode ? Colors.white : Colors.black)),
                ),
                Text(
                  DateFormat('hh:mm a').format(datetime),
                  style: const TextStyle(fontSize: 9),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                DateFormat('dd-MM').format(datetime),
                style: const TextStyle(fontSize: 9),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
