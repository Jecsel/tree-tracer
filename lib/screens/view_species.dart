import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tree_tracer/models/flower_model.dart';
import 'package:tree_tracer/models/fruit_model.dart';
import 'package:tree_tracer/models/leaf_model.dart';
import 'package:tree_tracer/models/root_model.dart';
import 'package:tree_tracer/models/tracer_model.dart';
import 'package:tree_tracer/screens/admin.dart';
import 'package:tree_tracer/screens/update_species.dart';
import 'package:tree_tracer/services/database_helper.dart';

class ViewSpecies extends StatefulWidget {
  final int tracerId; // Mangrove Id
  final String category; // What category of mangrove, if TREE, ROOT, ETC.
  final String userType; //What type of User

  ViewSpecies({required this.tracerId, required this.category, required this.userType}); // Constructor that accepts data

  @override
  State<StatefulWidget> createState() => _ViewSpeciesState();
}

class _ViewSpeciesState extends State<ViewSpecies> {
  int _selectedIndex = 0;
  MangroveDatabaseHelper dbHelper = MangroveDatabaseHelper.instance;
  TracerModel? tracerData;
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
        await dbHelper.getOneTracerData(tracerId);
    RootModel? rootResultData = await dbHelper.getOneRootData(tracerId);
    FlowerModel? flowerResultData = await dbHelper.getOneFlowerData(tracerId);
    LeafModel? leafResultData = await dbHelper.getOneLeafData(tracerId);
    FruitModel? fruitResultData = await dbHelper.getOneFruitData(tracerId);

    setState(() {
      tracerData = mangroveResultData;
      rootData = rootResultData;
      fruitData = fruitResultData;
      leafData = leafResultData;
      flowerData = flowerResultData;

      print("========== rootData ===========");
      print(rootData);
    });
  }

  Future<void> deleteTracer() async {
    int tracerId = widget.tracerId;
    await dbHelper.deleteFlowerData(tracerId);
    await dbHelper.deleteFruitData(tracerId);
    await dbHelper.deleteLeafData(tracerId);
    await dbHelper.deleteRootData(tracerId);
    await dbHelper.deleteTracerData(tracerId);
  }

  _drawerItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  _gotoSearchList() {
    String userType = widget.userType;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) =>
            AdminPage(searchKey: 'TREE', userType: userType)));
  }

  _gotoUpdateSpecies() {
    int tracerId = widget.tracerId;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateSpecies(tracerId: tracerId)));
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
    return Image.asset("assets/images/default_placeholder.png",
      width: 80,
      height: 80); // You can replace this with your placeholder image
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
    var userType = widget.userType;
    var searchKey = widget.category;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mangroove Info'),
        backgroundColor: Colors.green, // Set the background color here
        leading: IconButton(
            icon: Icon(Icons.arrow_back), // Add your arrow icon here
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminPage(userType: userType, searchKey: searchKey)));
            },
          ),
        actions: <Widget>[
          Visibility(
            visible: userType == 'Admin',
            child: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                _gotoUpdateSpecies();
              },
            ),
          ),
          Visibility(
            visible: userType == 'Admin',
            child: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                deleteTracer();
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
                  future: loadImageFromFile(tracerData?.imagePath ?? ''),
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
                  tracerData?.local_name ?? 'No Local Name',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 25),
                ),
                SizedBox(height: 10),
                Text(
                  tracerData?.scientific_name ?? 'No Scientific Name',
                  style: TextStyle(
                    color: Colors.grey,
                    fontStyle: FontStyle.italic
                  ),
                ),
                SizedBox(height: 10),
                Text(tracerData?.description ?? 'No Description'),

                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Benifits',
                          style: TextStyle(
                            fontWeight: FontWeight.w600
                          ),
                        ),
                        Text(tracerData?.benifits ?? 'No Benifits'),
                        Text(
                          'Uses',
                          style: TextStyle(
                            fontWeight: FontWeight.w600
                          ),
                        ),
                        Text(tracerData?.uses ?? 'No Uses'),
                      ],
                  )
,
                  )
                   
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
