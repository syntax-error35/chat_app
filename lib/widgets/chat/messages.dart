import 'package:chat_app/widgets/chat/message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Messages extends StatelessWidget {
  //const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var currentUser = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chats')
          .orderBy(
            'createdAt',
            descending: true,
          )
          .snapshots(),
      builder: (ctx, chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final chatDocs = chatSnapshot.data?.docs;
        for (var item in chatDocs ?? []) {
          debugPrint(item.data()['text']);
        }
        return ListView.builder(
                reverse: true,
                itemCount: chatSnapshot.data?.docs.length,
                itemBuilder: (ctx, index) {
                  return MessageBubble(
                    chatDocs?[index].data()['text'] ?? '', // forwarding the text
                    currentUser?.uid == chatDocs?[index].data()['userId'] , // checking whether its me or not
                    chatDocs?[index].data()['username'],
                      chatDocs![index].data()['userImage'],
                  );
                });
      },
    );
  }
}
