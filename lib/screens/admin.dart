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
import 'package:tree_tracer/screens/add_species.dart';
import 'package:tree_tracer/screens/home.dart';
import 'package:tree_tracer/screens/view_species.dart';
import 'package:tree_tracer/services/database_helper.dart';
import 'package:carousel_slider/carousel_slider.dart';

class AdminPage extends StatefulWidget {
  String searchKey;
  String userType;

  AdminPage({required this.searchKey, required this.userType});

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  String query = "";
  List<String> searchResults = [];

  late MangroveDatabaseHelper dbHelper;
  List<dynamic> mangrooveData = [];

  @override
  void initState() {
    super.initState();
      print("======= initState ===========");
      dbHelper = MangroveDatabaseHelper.instance;
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
            mangrooveData = result;
          break;
        case 'ROOT':
            mangrooveData = roots;
          break;
        case 'FRUIT':
            mangrooveData = fruits;
          break;
        case 'LEAF':
            mangrooveData = leaves;
          break;
        case 'FLOWER':
            mangrooveData = flowers;
          break;
        default:
          mangrooveData = result;
      }
    
    });
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

  _gotoAddSpecies() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>AddSpecies()));
  }

  Future<void> _handleRefresh() async {
    // Simulate a refresh action (e.g., fetch new data from a server)
    fetchData();
    await Future.delayed(Duration(seconds: 2));
  }
  
  void search(String keyword) {
    // Create a new list to store the filtered data
    List<TracerModel> filteredData = [];

    // Iterate through the original data and add matching items to the filtered list
    for (var item in mangrooveData) {
      if (item.local_name.toLowerCase().contains(keyword.toLowerCase()) ||
          item.scientific_name.toLowerCase().contains(keyword.toLowerCase())) {
        filteredData.add(item);
      }
    }

    setState(() {
      // Update the mangrooveData with the filtered data
      mangrooveData = filteredData;
    });
  }

  @override
  Widget build(BuildContext context) {
    String searchKey = widget.searchKey;
    String pageType = widget.userType;
    List<Map<String, dynamic>> carouselItems = [
      {'name': 'TREE', 'image': 'assets/images/tree.png'},
      {'name': 'FLOWER', 'image': 'assets/images/flower.png'},
      {'name': 'LEAF', 'image': 'assets/images/leaf.png'},
      {'name': 'ROOT', 'image': 'assets/images/root.png'},
      {'name': 'FRUIT', 'image': 'assets/images/fruit.png'},
    ];

    return MaterialApp(
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
          title: Text('Admin Page'), // Add your app title here
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child:   Column(
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
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: Colors.green
                ),
                onPressed: () => {_gotoAddSpecies()},
                child: const Text("Add Tree"),
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
                itemCount: mangrooveData.length,
                itemBuilder: (context, index) {
                  final imageData = mangrooveData[index];
                  final mangroveId= mangrooveData[index].id;

                  return GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> ViewSpecies(tracerId: mangroveId ?? 0, category: searchKey, userType: 'Admin',)));
                      //   final imageData = mangrooveData[index];
                      //   final snackBar = SnackBar(
                      //     content: Text('Tapped on ${imageData}'),
                      //   );
                      //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
                itemCount: mangrooveData.length,
                itemBuilder: (context, index) {
                  final imageDt = mangrooveData[index];
                  final mangId= mangrooveData[index].tracerId;

                  return GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> ViewSpecies(tracerId: mangId ?? 0, category: searchKey, userType: 'Admin')));
                      //   final snackBar = SnackBar(
                      //     content: Text('Tapped on ${mangId}'),
                      //   );
                      //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
    
      )
      
    ));
  }
}
