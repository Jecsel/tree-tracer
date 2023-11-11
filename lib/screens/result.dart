// lib/main.dart
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img; // This is for decoding the image

import 'package:flutter/material.dart';
import 'package:tree_tracer/screens/home.dart';
import 'package:tree_tracer/screens/view_species.dart';
import 'package:tree_tracer/services/database_helper.dart';

class ResultPage extends StatefulWidget {
  List<Map<String, dynamic>> results;
  String searchKey;

  ResultPage({required this.results, required this.searchKey});

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  String query = "";
  List<String> searchResults = [];

  late MangroveDatabaseHelper dbHelper;

  @override
  void initState() {
    super.initState();
      print("======= initState ===========");
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
    var searchKey = widget.searchKey;
    List<dynamic> mangrooveData = widget.results;

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
          title: Text('Scan Results'), // Add your app title here
      ),
      body: Column(
        children: [
          Expanded(
            child: searchKey == 'TREE' 
            ? ListView.builder(
              itemCount: mangrooveData.length,
              itemBuilder: (context, index) {
                final imageData = mangrooveData[index]['image'];
                final mangroveId= mangrooveData[index]['image']['id'];
                print('====== Similarity Score: ${mangrooveData[index]['score']}');

                return GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> ViewSpecies(tracerId: mangroveId ?? 0, category: searchKey, userType: 'User',)));
                    //   final imageData = mangrooveData[index];
                    //   final snackBar = SnackBar(
                    //     content: Text('Tapped on ${imageData}'),
                    //   );
                    //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                  child: ListTile(
                  title: Text('Local Name: ${imageData['local_name']}'),
                  subtitle: Text('Score: ${mangrooveData[index]['score']}%' ),
                  leading: FutureBuilder<Widget>(
                    future: loadImageFromFile(imageData['imagePath']),
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
                final imageDt = mangrooveData[index]['image'];
                final mangId= mangrooveData[index]['image']['mangroveId'];

                return GestureDetector(
                  // onTap: () {
                  //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> ViewSpecies(mangroveId: mangId ?? 0, category: searchKey, pageType: 'User')));
                  //     final snackBar = SnackBar(
                  //       content: Text('Tapped on ${mangId}'),
                  //     );
                  //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  // },
                  child: ListTile(  
                  title: Text('Name: ${imageDt['name']}'),
                  subtitle: Text('Score: ${mangrooveData[index]['score']}%' ),
                  leading: FutureBuilder<Widget>(
                    future: loadImageFromFile(imageDt['imagePath']),
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
    ));
  }
}
