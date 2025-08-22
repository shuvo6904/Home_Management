import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:home_management/widgets/round_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class AddRenterInfoScreen extends StatefulWidget {
  const AddRenterInfoScreen({super.key, required itemName, required itemId});

  @override
  State<AddRenterInfoScreen> createState() => _AddRenterInfoScreenState();
}

class _AddRenterInfoScreenState extends State<AddRenterInfoScreen> {
  FirebaseStorage stroage = FirebaseStorage.instance;
  File? _photo;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Renter Info'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            RoundButton(
                title: "Upload Image",
                onTap: () {
                  imgFromGallery();
                }
            )
          ],
        ),
      ),
    );
  }

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile();
      } else {
        if (kDebugMode) {
          print('No image selected.');
        }
      }
    });
  }

  Future uploadFile() async {
    if(_photo == null) return;
    final fileName = basename(_photo!.path);
    final destination = 'files/$fileName';

    try {
      final ref = FirebaseStorage.instance
          .ref(destination)
          .child('file/');
      await ref.putFile(_photo!);
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }
}


































