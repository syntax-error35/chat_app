import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  bool _isButtonDisabled = true;
  bool empty = true ;
  var _enteredMsg = '';
  var _textController = TextEditingController();
  void _sendMsg () async  {
    FocusScope.of(context).unfocus();
    final user =  FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance.collection('users').doc(user?.uid).get();
    FirebaseFirestore.instance.collection('chats').add({
      'text' : _enteredMsg,
      'createdAt' : Timestamp.now(),
      'userId' : user?.uid,
      'username' : userData['username'],
      'userImage' : userData['image_url'],
    }
    );
    _textController.clear();
    setState(() {
      _isButtonDisabled = true;
    });
}
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: const InputDecoration(labelText: 'Send a message'),
              onChanged: (value) {
                if(value.isNotEmpty){
                  setState(() {
                    _isButtonDisabled = false;
                  });
                }
                _enteredMsg = value;
              },
            ),
          ),
          IconButton(
            onPressed: _isButtonDisabled ? null : _sendMsg,
            icon: const Icon(Icons.send),
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}
