import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:home_management/ui/home/add_home_category_screen.dart';

class HomeCategoryScreen extends StatefulWidget {
  final String itemName;
  final String itemId;

  const HomeCategoryScreen(
      {super.key, required this.itemName, required this.itemId});

  @override
  State<HomeCategoryScreen> createState() => _HomeCategoryScreenState();
}

class _HomeCategoryScreenState extends State<HomeCategoryScreen> {
  final firebaseAuth = FirebaseAuth.instance;
  late DatabaseReference databaseRef; // Declare the DatabaseReference variable

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    databaseRef = FirebaseDatabase.instance.ref(widget.itemId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.itemName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
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

                        return GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // Two items per row
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0,
                            childAspectRatio:
                                3 / 2, // Aspect ratio for each item
                          ),
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            return Card(
                              color: Colors.indigoAccent,
                              // Set background color here
                              elevation: 3.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(8.0),
                                onTap: () {
                                  /*Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              HomeCategoryScreen(
                                                itemName: list[index]
                                                    ['categoryName'],
                                                itemId: list[index]
                                                    ['id'], // Pass the ID here
                                              )));*/
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.home_outlined,
                                      size: 50,
                                      color: Colors.white,
                                    ), // Example icon
                                    const SizedBox(height: 8.0),
                                    Text(
                                      list[index]['categoryName'],
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }
                    }))
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
                    builder: (context) => AddHomeCategoryScreen(
                        itemName: widget.itemName, itemId: widget.itemId)));
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
