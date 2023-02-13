import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String msg;
  final bool isMe;
 // final Key key;
  final String username;
  final String image_url;
  MessageBubble(this.msg, this.isMe, this.username,this.image_url,
      //{required this.key,}
      );
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Column(
          children: [
            Text(username), 
            Row(
              children: [
                CircleAvatar(radius: 20,
                backgroundImage: NetworkImage(image_url),),
                Container(
                  decoration: BoxDecoration(
                    color: isMe ? Theme.of(context).primaryColor : Colors.indigo,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(12),
                      topRight: const Radius.circular(12),
                      bottomLeft: isMe ? const Radius.circular(12) : Radius.zero,
                      bottomRight: isMe ? Radius.zero : const Radius.circular(12),
                    ),
                  ),
                  width: 140,
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 16,
                  ),
                  margin: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 8,
                  ),
                  child: Text(
                    msg,
                    style: TextStyle(
                        color: Theme.of(context).primaryTextTheme.headline1?.color),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
