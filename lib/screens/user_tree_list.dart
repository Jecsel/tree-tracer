// lib/main.dart
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img; // This is for decoding the image

import 'package:flutter/material.dart';
import 'package:tree_tracer/models/flower_model.dart';
import 'package:tree_tracer/models/fruit_model.dart';
import 'package:tree_tracer/models/leaf_model.dart';
import 'package:tree_tracer/models/root_model.dart';
import 'package:tree_tracer/models/tracer_model.dart';
import 'package:tree_tracer/screens/about_us.dart';
import 'package:tree_tracer/screens/home.dart';
import 'package:tree_tracer/screens/trees.dart';
import 'package:tree_tracer/screens/view_species.dart';
import 'package:tree_tracer/services/database_helper.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:tree_tracer/ui_components/main_view.dart';

class UserTreeList extends StatefulWidget {
  String searchKey;
  String userType;

  UserTreeList({required this.searchKey, required this.userType});

  @override
  _UserTreeListState createState() => _UserTreeListState();
}

class _UserTreeListState extends State<UserTreeList> {
  String query = "";
  List<String> searchResults = [];

  late TracerDatabaseHelper dbHelper;
  List<dynamic> tracerData = [];

  int _selectedIndex = 0;

  _drawerItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  Widget _buildDrawerItem({
    required String title,
    required int index,
    VoidCallback? onTap,
  }) {
    return ListTile(
      title: Text(title),
      selected: _selectedIndex == index,
      onTap: onTap,
    );
  }

  @override
  void initState() {
    super.initState();
      print("======= initState ===========");
      dbHelper = TracerDatabaseHelper.instance;
      fetchData();
  }

  Future<void> fetchData() async {
    String searchKey = widget.searchKey;
    print("======= Result Start ===========");
    List<TracerModel> result = await dbHelper.getTracerDataList();
    print(result.length);
    print("======= Result End ===========");

    List<FruitModel> fruits = await dbHelper.getFruitDataList();
    List<LeafModel> leaves = await dbHelper.getLeafDataList();
    List<RootModel> roots = await dbHelper.getRootDataList();
    List<FlowerModel> flowers = await  dbHelper.getFlowerDataList();
    
    
    setState(() {
      switch (searchKey) {
        case 'TREE':
            tracerData = result;
          break;
        case 'ROOT':
            tracerData = roots;
          break;
        case 'FRUIT':
            tracerData = fruits;
          break;
        case 'LEAF':
            tracerData = leaves;
          break;
        case 'FLOWER':
            tracerData = flowers;
          break;
        default:
          tracerData = result;
      }
    
    });
  }

    Future<bool> _onBackPressed(BuildContext context) async {
    final confirmed = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Exit the app?'),
          content: Text('Are you sure you want to exit the app?'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    return confirmed ?? false; // Return false if the dialog is dismissed
  }

  Future<Widget> loadImageFromFile(String filePath) async {
    print('============ loadImageFromFile ===== ${filePath}');
    if (filePath.startsWith('assets/')) {
      // If the path starts with 'assets/', load from assets
      return Image.asset(filePath, width: 60, height: 60);
    } else {
      final file = File(filePath);

      if (await file.exists()) {
        // If the file exists in local storage, load it
        return Image.file(file, width: 60, height: 60,);
      }
    }

  // If no valid image is found, return a default placeholder
  return Image.asset("assets/images/default_placeholder.png", width: 60, height: 60,); // You can replace this with your placeholder image
}
  void search(String keyword) {
    // Create a new list to store the filtered data
    List<TracerModel> filteredData = [];

    // Iterate through the original data and add matching items to the filtered list
    for (var item in tracerData) {
      if (item.local_name.toLowerCase().contains(keyword.toLowerCase()) ||
          item.scientific_name.toLowerCase().contains(keyword.toLowerCase())) {
        filteredData.add(item);
      }
    }

    setState(() {
      // Update the tracerData with the filtered data
      tracerData = filteredData;
    });
  }

  @override
  Widget build(BuildContext context) {
    String searchKey = widget.searchKey;
    String userType = widget.userType;
    
    List<Map<String, dynamic>> carouselItems = [
      {'name': 'TREE', 'image': 'assets/images/tree.png'},
      {'name': 'FLOWER', 'image': 'assets/images/flower.png'},
      {'name': 'LEAF', 'image': 'assets/images/leaf.png'},
      {'name': 'ROOT', 'image': 'assets/images/root.png'},
      {'name': 'FRUIT', 'image': 'assets/images/fruit.png'},
    ];

    return WillPopScope(
      child: MaterialApp(
        home: Scaffold(
        appBar: AppBar(
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color.fromARGB(255, 24, 122, 0), Color.fromARGB(255, 82, 209, 90)],
                ),
              ),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back), // Add your arrow icon here
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
              },
            ),
            title: Text('Tree List'), // Add your app title here
        ),
        body: Column(
          children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  "Tree Species List",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20.0
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onChanged: (value) {
                  search(value);
                },
                decoration: InputDecoration(
                  labelText: "Search Tree",
                  prefixIcon: Icon(Icons.image_search_rounded),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Expanded(
              child: searchKey == 'TREE' 
              ? ListView.builder(
                itemCount: tracerData.length,
                itemBuilder: (context, index) {
                  final imageData = tracerData[index];
                  final mangroveId= tracerData[index].id;

                  return GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> ViewSpecies(tracerId: mangroveId ?? 0, category: searchKey, userType: userType,)));
                        // final imageData = tracerData[index];
                        // final snackBar = SnackBar(
                        //   content: Text('Tapped on ${imageData}'),
                        // );
                        // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                    child: ListTile(
                    title: Text('Local Name: ${imageData.local_name}'),
                    subtitle: Text('Scientific Name: ${imageData.scientific_name}' ),
                    leading: FutureBuilder<Widget>(
                      future: loadImageFromFile(imageData.imagePath),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return snapshot.data ?? CircularProgressIndicator();
                        } else {
                          return CircularProgressIndicator(); // Or another loading indicator
                        }
                      },
                    ),
                  )
                  );
                },
              )
              : ListView.builder(
                itemCount: tracerData.length,
                itemBuilder: (context, index) {
                  final imageDt = tracerData[index];
                  final mangId= tracerData[index].mangroveId;

                  return GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> ViewSpecies(tracerId: mangId ?? 0, category: searchKey, userType: userType)));
                      // final snackBar = SnackBar(content: Text('Tapped on ${mangId}'),);
                      // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                    child: ListTile(  
                    title: Text('Name: ${imageDt.name}'),
                    leading: FutureBuilder<Widget>(
                      future: loadImageFromFile(imageDt.imagePath),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return snapshot.data ?? CircularProgressIndicator();
                        } else {
                          return CircularProgressIndicator(); // Or another loading indicator
                        }
                      },
                    ),
                  )
                  );
                },
              )
            )
          ],
        ),
        endDrawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              _buildDrawerItem(
                title: 'Home',
                index: 0,
                onTap: () {
                  _drawerItemTapped(0);
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) => Home()));
                },
              ),
              _buildDrawerItem(
                title: 'Favorite',
                index: 1,
                onTap: () {
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) => Trees()));
                },
              ),
              _buildDrawerItem(
                title: 'Admin',
                index: 2,
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => MainView()));
                },
              ),
              _buildDrawerItem(
                title: 'Tree List',
                index: 3,
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserTreeList(
                                searchKey: 'TREE',
                                userType: 'User',
                              )));
                },
              ),
              _buildDrawerItem(
                title: 'About Us',
                index: 4,
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => AboutUs()));
                },
              ),
              _buildDrawerItem(
                title: 'Exit',
                index: 5,
                onTap: () {
                  _onBackPressed(context);
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
                backgroundColor: Colors.green),
            BottomNavigationBarItem(
                icon: Icon(Icons.grass),
                label: 'Trees',
                backgroundColor: Colors.green),
            BottomNavigationBarItem(
                icon: Icon(Icons.face),
                label: 'About',
                backgroundColor: Colors.green),
            BottomNavigationBarItem(
                icon: Icon(Icons.exit_to_app),
                label: 'Exit',
                backgroundColor: Colors.green),
          ],
          currentIndex: 1,
          selectedItemColor: Colors.amber[800],
          onTap: (int index) {
            switch (index) {
              case 0:
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Home()));
              case 1:
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserTreeList(
                              searchKey: 'TREE',
                              userType: 'User',
                            )));
              case 2:
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => AboutUs()));
              case 3:
                _onBackPressed(context);
            }
            setState(
              () {
                _selectedIndex = index;
              },
            );
          },
        ),
      
      ))
  , 
      onWillPop: () async { return _onBackPressed(context); },
    );
    
    }
}
