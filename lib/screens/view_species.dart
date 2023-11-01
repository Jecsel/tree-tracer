import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tree_tracer/models/flower_model.dart';
import 'package:tree_tracer/models/fruit_model.dart';
import 'package:tree_tracer/models/leaf_model.dart';
import 'package:tree_tracer/models/root_model.dart';
import 'package:tree_tracer/models/tracer_model.dart';
import 'package:tree_tracer/services/database_helper.dart';

class ViewSpecies extends StatefulWidget {
  final int tracerId; // Mangrove Id
  final String category; // What category of mangrove, if TREE, ROOT, ETC.
  final String pageType; //What type of User

  ViewSpecies({required this.tracerId, required this.category, required this.pageType}); // Constructor that accepts data

  @override
  State<StatefulWidget> createState() => _ViewSpeciesState();
}

class _ViewSpeciesState extends State<ViewSpecies> {
  int _selectedIndex = 0;
  MangroveDatabaseHelper dbHelper = MangroveDatabaseHelper.instance;
  TracerModel? mangroveData;
  RootModel? rootData;
  FlowerModel? flowerData;
  FruitModel? fruitData;
  LeafModel? leafData;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    int tracerId = widget.tracerId;
    TracerModel? mangroveResultData =
        await dbHelper.getOneMangroveData(tracerId);
    RootModel? rootResultData = await dbHelper.getOneRootData(tracerId);
    FlowerModel? flowerResultData = await dbHelper.getOneFlowerData(tracerId);
    LeafModel? leafResultData = await dbHelper.getOneLeafData(tracerId);
    FruitModel? fruitResultData = await dbHelper.getOneFruitData(tracerId);

    setState(() {
      mangroveData = mangroveResultData;
      rootData = rootResultData;
      fruitData = fruitResultData;
      leafData = leafResultData;
      flowerData = flowerResultData;

      print("========== rootData ===========");
      print(rootData);
    });
  }

  Future<void> deleteMangroveData() async {
    int tracerId = widget.tracerId;
    await dbHelper.deleteFlowerData(tracerId);
    await dbHelper.deleteFruitData(tracerId);
    await dbHelper.deleteLeafData(tracerId);
    await dbHelper.deleteRootData(tracerId);
    await dbHelper.deleteMangroveData(tracerId);
  }

  _drawerItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  _gotoSearchList() {
    String pageType = widget.pageType;
    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> SearchPage(searchKey: 'TREE', pageType: pageType)));
  }

  _gotoUpdateSpecies() {
    int tracerId = widget.tracerId;
    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> UpdateSpecies(tracerId: tracerId)));
  }

    Future<Widget> loadImageFromFile(String filePath) async {
      if (filePath.startsWith('assets/')) {
        // If the path starts with 'assets/', load from assets
        return Image.asset(filePath);
      } else {
        final file = File(filePath);

        if (await file.exists()) {
          // If the file exists in local storage, load it
          return Image.file(file);
        }
      }

      // If no valid image is found, return a default placeholder
      return Image.asset("assets/images/default_placeholder.png"); // You can replace this with your placeholder image
    }

    Future<Widget> loadImage(String filePath) async {
      if (filePath.startsWith('assets/')) {
        // If the path starts with 'assets/', load from assets
        return Image.asset(filePath, width: 80, height: 80);
      } else {
        final file = File(filePath);

        if (await file.exists()) {
          // If the file exists in local storage, load it
          return Image.file(file, width: 80, height: 80);
        }
      }

      // If no valid image is found, return a default placeholder
      return Image.asset("assets/images/default_placeholder.png", width: 80, height: 80); // You can replace this with your placeholder image
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
  Widget build(BuildContext context) {
    var pageType = widget.pageType;
    var searchKey = widget.category;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mangroove Info'),
        backgroundColor: Colors.green, // Set the background color here
        leading: IconButton(
            icon: Icon(Icons.arrow_back), // Add your arrow icon here
            onPressed: () {
              // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SearchPage(pageType: pageType, searchKey: searchKey,)));
            },
          ),
        actions: <Widget>[
          Visibility(
            visible: pageType == 'Admin',
            child: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                _gotoUpdateSpecies();
              },
            ),
          ),
          Visibility(
            visible: pageType == 'Admin',
            child: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                deleteMangroveData();
                _gotoSearchList();
                final snackBar = SnackBar(
                  content: Text('Mangrove Delete!'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Column(
              children: <Widget>[
                FutureBuilder<Widget>(
                  future: loadImageFromFile(mangroveData?.imagePath ?? ''),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return snapshot.data ?? CircularProgressIndicator();;
                    } else {
                      return CircularProgressIndicator(); // Or another loading indicator
                    }
                  },
                ),
                SizedBox(height: 10),
                Text(
                  mangroveData?.scientific_name ?? 'No Scientific Name',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 25),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      "Local Names: ",
                      style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    Expanded(
                      child: Text(
                        mangroveData?.local_name ?? 'No Scientific Name')),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      "Description: ",
                      style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    Expanded(
                      child: Text(
                        mangroveData?.description ?? 'No Description')),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "Summary: ",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    Expanded(
                      child: Text(
                        mangroveData?.description ?? '--------------')),
                  ],
                ),

                SizedBox(height: 30),
                Visibility(
                  visible: leafData?.imagePath != null || leafData?.imagePath != '',
                    child: Text(
                    "Leaves",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                Visibility(
                  visible: leafData?.imagePath != null || leafData?.imagePath != '',
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: Text(leafData?.name ?? 'No Name'),
                      ),
                      Expanded(
                        child: Text(leafData?.description ?? 'No Description'),
                      ),
                      FutureBuilder<Widget>(
                        future: loadImage(leafData?.imagePath ?? ''),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.done) {
                            return snapshot.data ?? CircularProgressIndicator();;
                          } else {
                            return CircularProgressIndicator(); // Or another loading indicator
                          }
                        },
                      ),
                      // Image.memory(
                      //   leafData?.imageBlob ?? Uint8List(0),
                      //   width: 80,
                      //   height: 80,
                      // ),
                    ],
                  ),
                ),

                SizedBox(height: 30),
                Visibility(
                  visible: fruitData?.imageBlob != null || fruitData?.imageBlob != '',
                    child: Text(
                    "Fruit",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                Visibility(
                  visible: fruitData?.imageBlob != null || fruitData?.imageBlob != '',
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: Text(fruitData?.name ?? 'No Name'),
                      ),
                      Expanded(
                        child: Text(fruitData?.description ?? 'No Description')
                      ),
                      FutureBuilder<Widget>(
                        future: loadImage(fruitData?.imagePath ?? ''),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.done) {
                            return snapshot.data ?? CircularProgressIndicator();;
                          } else {
                            return CircularProgressIndicator(); // Or another loading indicator
                          }
                        },
                      ), 
                      // Image.memory(
                      //   fruitData?.imageBlob ?? Uint8List(0),
                      //   width: 80,
                      //   height: 80,
                      // ),
                    ],
                  ),
                ),

                SizedBox(height: 30),
                Visibility(
                  visible: flowerData?.imageBlob != null || flowerData?.imageBlob != '',
                    child: Text(
                    "Flower",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                Visibility(
                  visible: flowerData?.imageBlob != null || flowerData?.imageBlob != '',
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: Text(flowerData?.name ?? 'No Name'),
                      ),
                      Expanded(
                        child: Text(flowerData?.description ?? 'No Description')
                      ),
                      FutureBuilder<Widget>(
                        future: loadImage(flowerData?.imagePath ?? ''),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.done) {
                            return snapshot.data ?? CircularProgressIndicator();;
                          } else {
                            return CircularProgressIndicator(); // Or another loading indicator
                          }
                        },
                      ),
                      // Image.memory(
                      //   flowerData?.imageBlob ?? Uint8List(0),
                      //   width: 80,
                      //   height: 80,
                      // ),
                    ],
                  ),

                ),
                
                SizedBox(height: 30),
                Visibility(
                  visible: rootData?.imageBlob != null || rootData?.imageBlob != '',
                    child: Text(
                    "Root",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                Visibility(
                  visible: rootData?.imageBlob != null || rootData?.imageBlob != '',
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: Text(rootData?.name ?? 'No Name'),
                      ),
                      Expanded(
                        child: Text(rootData?.description ?? 'No Description')
                      ),
                      FutureBuilder<Widget>(
                        future: loadImage(rootData?.imagePath ?? ''),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.done) {
                            return snapshot.data ?? CircularProgressIndicator();;
                          } else {
                            return CircularProgressIndicator(); // Or another loading indicator
                          }
                        },
                      ),
                      // Image.memory(
                      //   rootData?.imageBlob ?? Uint8List(0),
                      //   width: 80,
                      //   height: 80,
                      // ),
                    ],
                  ),
                ),
                
              ],
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _buildDrawerItem(
              title: 'Home',
              index: 0,
              onTap: () {
                // Navigator.pushReplacement(
                //     context, MaterialPageRoute(builder: (context) => Home()));
              },
            ),
            _buildDrawerItem(
              title: 'Admin',
              index: 1,
              onTap: () {
                // Navigator.pushReplacement(context,
                // MaterialPageRoute(builder: (context) => Login()));
              },
            ),
            _buildDrawerItem(
              title: 'About Us',
              index: 1,
              onTap: () {
                // Navigator.pushReplacement(context,
                // MaterialPageRoute(builder: (context) => AboutUs()));
              },
            ),
            _buildDrawerItem(
              title: 'Exit',
              index: 2,
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
