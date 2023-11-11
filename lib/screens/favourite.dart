// lib/main.dart
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img; // This is for decoding the image

import 'package:flutter/material.dart';
import 'package:tree_tracer/screens/home.dart';
import 'package:tree_tracer/services/database_helper.dart';

class FavouritePage extends StatefulWidget {


  FavouritePage();

  @override
  _FavouritePageState createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  String query = "";
  List<String> searchResults = [];

  late MangroveDatabaseHelper dbHelper;
  late List<dynamic> treeTracer;

  @override
  void initState() {
    super.initState();
      print("======= initState ===========");
      dbHelper = MangroveDatabaseHelper.instance;
      fetchData();
  }

  Future<void> fetchData() async {
    var treeTracerData = await dbHelper.getTracerFavouriteDataList();
    treeTracer = treeTracerData;

    print("============= ${treeTracerData} ========");

    setState(() {
      treeTracer = treeTracerData;
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
    // List<dynamic> treeTracer = widget.results;

    print("=====treeTracer[index]======== ${treeTracer.length} ========");

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
      body: treeTracer.isNotEmpty ?
        Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: treeTracer.length,
                itemBuilder: (context, index) {
                  // final imageData = treeTracer[index]?['image'];
                  // final mangroveId= treeTracer[index]?['image']['id'];

                  var tracerDta = treeTracer[index];

                  print("=====tracerDta======== ${tracerDta} ========");

                  return GestureDetector(
                    onTap: () {
                    },
                    child: ListTile(
                    title: Text('Local Name: ${treeTracer[index]?['local_name']}'),
                    subtitle: Text('Score: ${treeTracer[index]['score']}%' ),
                    leading: FutureBuilder<Widget>(
                      future: loadImageFromFile(treeTracer[index]['imagePath']),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return snapshot.data ?? CircularProgressIndicator();
                        } else {
                          return CircularProgressIndicator(); // Or another loading indicator
                        }
                      },
                    ),
                    trailing: IconButton(
                      icon: treeTracer[index]['image'] == 0 ? Icon(Icons.favorite_border) : Icon(Icons.favorite, color: Colors.red,),
                      onPressed: () { },
                    ),
                  )
                  );
                },
              )
            )
          ],
        )
        : Text("No Favourites Added."),
    ));
  }
}
