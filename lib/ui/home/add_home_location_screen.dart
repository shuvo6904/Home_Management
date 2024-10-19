import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:home_management/utils/utility.dart';
import 'package:home_management/widgets/round_button.dart';
import 'package:intl/intl.dart';

class AddHomeLocationScreen extends StatefulWidget {
  const AddHomeLocationScreen({super.key});

  @override
  State<AddHomeLocationScreen> createState() => _AddHomeLocationScreenState();
}

class _AddHomeLocationScreenState extends State<AddHomeLocationScreen> {
  bool isLoading = false;
  final homeLocationNameController = TextEditingController();

  final databaseRef = FirebaseDatabase.instance.ref('Home Location');

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    homeLocationNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Home Location'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            TextFormField(
              controller: homeLocationNameController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Hazibari',
                  labelText: 'Enter Your Home Location'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: RoundButton(
                  title: "Add Home",
                  loading: isLoading,
                  onTap: () {
                    setState(() {
                      isLoading = true;
                    });
                    saveHomeLocationData(databaseRef);
                  }),
            )
          ],
        ),
      ),
    );
  }

  void saveHomeLocationData(DatabaseReference databaseRef) {
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
      'name': homeLocationNameController.text.toString(),
      'addedBy': FirebaseAuth.instance.currentUser?.email ?? 'default',
      'dateTime': formattedDateTime, // Include the date and time
    };

    // Save data to the database using the unique key
    databaseRef.child(uniqueKey).set(data).then((value) {
      setState(() {
        isLoading = false;
      });
      Utility().toastMessage("Successfully Added Home Location");
    }).onError((error, stackTrace) {
      setState(() {
        isLoading = false;
      });
      Utility().toastMessage(error.toString());
    });
  }
}
