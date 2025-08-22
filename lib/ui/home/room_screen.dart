import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:home_management/ui/home/add_room_info_screen.dart';

class RoomScreen extends StatefulWidget {
  final String itemName;
  final String itemId;

  const RoomScreen({super.key, required this.itemName, required this.itemId});

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  final firebaseAuth = FirebaseAuth.instance;
  late DatabaseReference databaseRef;

  @override
  void initState() {
    super.initState();
    print(widget.itemId);
    databaseRef = FirebaseDatabase.instance.ref().child(widget.itemId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Room')),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Expanded(
                child: StreamBuilder(
                    stream: databaseRef.onValue,
                    builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        Map<dynamic, dynamic> map =
                            snapshot.data!.snapshot.value as dynamic;
                        List<dynamic> list = [];
                        list.clear();
                        list = map.values.toList();

                        return ListView.builder(
                            itemCount: snapshot.data!.snapshot.children.length,
                            itemBuilder: (context, index) {
                              return Card(
                                child: ListTile(
                                  title: Text(
                                    'Room Number: ${list[index]['roomNumber']}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                      'Renter Name: ${list[index]['renterName']}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.normal)),
                                ),
                              );
                            });
                      }
                    }
                )
            )
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(15),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddRoomInfoScreen(
                          itemName: widget.itemName,
                          itemId: widget.itemId,
                        )));
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
