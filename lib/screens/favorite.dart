// lib/main.dart
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img; // This is for decoding the image

import 'package:flutter/material.dart';
import 'package:tree_tracer/models/tracer_model.dart';
import 'package:tree_tracer/screens/home.dart';
import 'package:tree_tracer/services/database_helper.dart';

class FavoritePage extends StatefulWidget {

  FavoritePage();

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<FavoritePage> {
  String query = "";
 List<TracerModel>? searchResults;

  late MangroveDatabaseHelper dbHelper;

  @override
  void initState() {
    super.initState();
      print("======= initState ===========");
       dbHelper = MangroveDatabaseHelper.instance;
       fetchData();
  }

    Future<void> fetchData() async {
    List<TracerModel> result = await dbHelper.getTracerFavouriteDataList();

    for (TracerModel tracerData in result) {
      // Access and check properties of each TracerModel instance
      print('ID: ${tracerData.id}, Name: ${tracerData.local_name}'); // Replace with actual property names
    }

    
    setState(() {
      searchResults = result;
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

  @override
  Widget build(BuildContext context) {
    var searchKey = 'TREE';


    return MaterialApp(
      home: Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.green,
          leading: IconButton(
          icon: Icon(Icons.arrow_back), // Add your arrow icon here
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
            },
          ),
          title: Text('Favourite Page'), // Add your app title here
      ),
      body: ListView.builder(
              itemCount: searchResults!.length,
              itemBuilder: (context, index) {

                return ListTile(
                title: Text('Local Name: ${searchResults![index].local_name}'),
                subtitle: Text('Scientific Name: ${searchResults![index].scientific_name}' ),
                leading: FutureBuilder<Widget>(
                  future: loadImageFromFile(searchResults![index].imagePath ?? ''),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return snapshot.data ?? CircularProgressIndicator();
                    } else {
                      return CircularProgressIndicator(); // Or another loading indicator
                    }
                  },
                ),
                );
              },
            )
    ));
  }
}
