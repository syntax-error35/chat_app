import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class UserImage extends StatefulWidget {
 UserImage(this.ImagePickFn);
  final void Function(File pickedImage) ImagePickFn;
  @override
  State<UserImage> createState() => _UserImageState();
}

class _UserImageState extends State<UserImage> {
  File? _imageFile;
  bool _image = false;
  void _getImage() async {
    var _pickedImage = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 50, maxWidth: 150, );
    setState(() {
      _imageFile = File(_pickedImage!.path);
      _image = true;
    });
    widget.ImagePickFn(_imageFile!);
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundImage: _image ? FileImage( _imageFile! ) : null,
          radius: 40,
        ),
    TextButton.icon(
    onPressed: _getImage,
    icon: const Icon(Icons.image),
    label: const Text('Add Image'),
    ),
    ],
    );
  }
  // @override
  // void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  //   super.debugFillProperties(properties);
  //   properties.add(DiagnosticsProperty<File>('_imageFile', _imageFile));
  // }
}
