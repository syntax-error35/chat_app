import 'dart:io';

import 'package:chat_app/widgets/auth/auth_form.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var msg = 'An error occurred, Please check your credentials.';
  var _isLoading = false;
  void _submitAuthForm(
    String email,
    String username,
    File? image,
    String password,
    bool isLogin,
  ) async {
    UserCredential _authResult;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        _authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        _authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

       final ref = FirebaseStorage.instance.ref().child('user_image').child('${_authResult.user!.uid}.jpg');
       await ref.putFile(image!);
       final url = await ref.getDownloadURL();
        await FirebaseFirestore.instance.collection('users').doc(_authResult.user!.uid).set({
          'username' : username,
          'email' : email,
          'image_url' : url,
        });
      }
    } on PlatformException catch (err) {
      if (err.message!.isNotEmpty) {
        msg = err.message!;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(msg),
          backgroundColor: Theme.of(context).errorColor,
        ));
        setState(() {
          _isLoading = false;
        });
      }
    }catch(err){
      msg = err.toString();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(msg),
        backgroundColor: Theme.of(context).errorColor,
      ));
      setState(() {
        _isLoading = false;
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitAuthForm, _isLoading),
    );
  }
}
