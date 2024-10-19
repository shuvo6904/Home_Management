import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:home_management/ui/auth/login_screen.dart';
import 'package:home_management/ui/home/add_home_location_screen.dart';
import 'package:home_management/ui/home/home_category_screen.dart';
import 'package:home_management/utils/utility.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final firebaseAuth = FirebaseAuth.instance;
  final databaseRef = FirebaseDatabase.instance.ref('Home Location');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        automaticallyImplyLeading: false,
        centerTitle: false,
        actions: [
          IconButton(
              onPressed: () {
                firebaseAuth.signOut().then((value) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                }).onError((error, stackTrace) {
                  Utility().toastMessage(error.toString());
                });
              },
              icon: const Icon(Icons.logout_outlined)),
          const SizedBox(
            width: 10,
          )
        ],
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
                    return const Center(child: CircularProgressIndicator());
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
                        childAspectRatio: 3 / 2, // Aspect ratio for each item
                      ),
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        return Card(
                          color: Colors.blue, // Set background color here
                          elevation: 3.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(8.0),
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => HomeCategoryScreen(
                                    itemName: list[index]['name'],
                                    itemId: list[index]['id'], // Pass the ID here
                                  )));
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                /*const Icon(Icons.home_outlined, size: 50, color: Colors.white,),*/ // Example icon
                                SvgPicture.asset(
                                  'assets/icons/location.svg', // Path to the SVG asset
                                  width: 35,
                                  height: 35,
                                  color: Colors.white, // Optional: Apply color to the SVG
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  list[index]['name'],
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
                },
              ),
            )

            /*Expanded(
                child: StreamBuilder(
                    stream: databaseRef.onValue,
                    builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                      if (!snapshot.hasData) {
                        return const CircularProgressIndicator();
                      } else {
                        Map<dynamic, dynamic> map =
                            snapshot.data!.snapshot.value as dynamic;
                        List<dynamic> list = [];
                        list.clear();
                        list = map.values.toList();
                        return ListView.builder(
                            itemCount: snapshot.data!.snapshot.children.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(list[index]['name']),
                              );
                            });
                      }
                    }))*/
            /*Expanded(
              child: FirebaseAnimatedList(
                  query: databaseRef,
                  defaultChild: const Text('Loading'),
                  itemBuilder: (context, snapshot, animation, index) {
                    return ListTile(
                      title: Text(snapshot.child('name').value.toString()),
                    );
                  }),
            )*/
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
                    builder: (context) => const AddHomeLocationScreen()));
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
