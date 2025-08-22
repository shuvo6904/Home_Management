import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:home_management/widgets/round_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import '../../utils/utility.dart';

class AddRoomInfoScreen extends StatefulWidget {
  final String itemName;
  final String itemId;

  const AddRoomInfoScreen(
      {super.key, required this.itemName, required this.itemId});

  @override
  State<AddRoomInfoScreen> createState() => _AddRoomInfoScreenState();
}

class _AddRoomInfoScreenState extends State<AddRoomInfoScreen> {
  bool isLoading = false;
  final roomNumber = TextEditingController();
  final renterName = TextEditingController();
  final renterPhone = TextEditingController();
  final renterAddress = TextEditingController();
  late DatabaseReference databaseRef;
  FirebaseStorage stroage = FirebaseStorage.instance;
  File? _photo;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    databaseRef = FirebaseDatabase.instance.ref(widget.itemId);
  }

  @override
  void dispose() {
    super.dispose();
    roomNumber.dispose();
    renterName.dispose();
    renterPhone.dispose();
    renterAddress.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add ${widget.itemName} Info'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: roomNumber,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: '01',
                    labelText: 'Enter Your ${widget.itemName} Number'),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: renterName,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Saiful Islam',
                    labelText: 'Enter Renter Name'),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: renterPhone,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '01*********',
                    labelText: 'Enter Renter Phone Number'),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: renterAddress,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Tangail Sadar, Tangail',
                    labelText: 'Enter Renter Address'),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    imgFromGallery();
                  },
                  child: const Text('Choose NID Image'),
                ),
              ),
              const SizedBox(height: 20),
              RoundButton(
                  title: 'Save',
                  loading: isLoading,
                  onTap: () {
                    setState(() {
                      isLoading = true;
                    });
                    saveRoomInfoData(databaseRef);
                  })
            ],
          ),
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
    if (_photo == null) return;
    final fileName = basename(_photo!.path);
    final destination = 'files/$fileName';

    try {
      final ref = FirebaseStorage.instance.ref(destination).child('file/');
      await ref.putFile(_photo!);
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  void saveRoomInfoData(DatabaseReference databaseRef) {
    // Generate a unique key for the new child
    String? uniqueKey = databaseRef.push().key;

    // Check if the unique key is null
    if (uniqueKey == null) {
      setState(() {
        isLoading = false;
      });
      Utility().toastMessage("Failed to generate a unique key");
      return; // Exit the function if the key is null
    }

    // Get the current date and time, and format it
    String formattedDateTime =
    DateFormat('yyyy/MM/dd HH:mm').format(DateTime.now());

    // Create a map to hold the data (ensure all entries are key-value pairs)
    Map<String, dynamic> data = {
      'id': uniqueKey,
      'roomNumber': roomNumber.text.toString(),
      'addedBy': FirebaseAuth.instance.currentUser?.email ?? 'default',
      'renterName': renterName.text.toString(),
      'renterPhoneNumber': renterPhone.text.toString(),
      'renterAddress': renterAddress.text.toString(),
      'dateTime': formattedDateTime, // Include the date and time
    };

    // Save data to the database using the unique key
    databaseRef.child(uniqueKey).set(data).then((value) {
      setState(() {
        isLoading = false;
      });
      Utility().toastMessage("Successfully Saved Room Info");
    }).onError((error, stackTrace) {
      setState(() {
        isLoading = false;
      });
      Utility().toastMessage(error.toString());
    });
  }
}

























