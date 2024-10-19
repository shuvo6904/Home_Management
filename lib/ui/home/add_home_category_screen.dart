import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../utils/utility.dart';
import '../../widgets/round_button.dart';

class AddHomeCategoryScreen extends StatefulWidget {
  final String itemName;
  final String itemId;
  const AddHomeCategoryScreen({super.key, required this.itemName, required this.itemId});

  @override
  State<AddHomeCategoryScreen> createState() => _AddHomeCategoryScreenState();
}

class _AddHomeCategoryScreenState extends State<AddHomeCategoryScreen> {
  bool isLoading = false;
  final homeCategoryNameController = TextEditingController();
  late DatabaseReference databaseRef; // Declare the DatabaseReference variable

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    databaseRef = FirebaseDatabase.instance.ref(widget.itemId);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    homeCategoryNameController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add ${widget.itemName} Category'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            TextFormField(
              controller: homeCategoryNameController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Flat',
                  labelText: 'Enter Your Home Category'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: RoundButton(
                  title: 'Add ${widget.itemName} Category',
                  loading: isLoading,
                  onTap: () {
                    setState(() {
                      isLoading = true;
                    });
                    saveHomeCategoryData(databaseRef);
                  }),
            )
          ],
        ),
      ),
    );
  }

  void saveHomeCategoryData(DatabaseReference databaseRef) {
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
      'categoryName': homeCategoryNameController.text.toString(),
      'addedBy': FirebaseAuth.instance.currentUser?.email ?? 'default',
      'dateTime': formattedDateTime, // Include the date and time
    };

    // Save data to the database using the unique key
    databaseRef.child(uniqueKey).set(data).then((value) {
      setState(() {
        isLoading = false;
      });
      Utility().toastMessage("Successfully Added Home Category");
    }).onError((error, stackTrace) {
      setState(() {
        isLoading = false;
      });
      Utility().toastMessage(error.toString());
    });
  }
}
