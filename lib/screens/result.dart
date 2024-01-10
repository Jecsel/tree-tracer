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

  ResultPage({super.key, required this.results, required this.searchKey});

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  String query = "";
  List<String> searchResults = [];

  late TracerDatabaseHelper dbHelper;

  @override
  void initState() {
    super.initState();
    print("======= initState ===========");
  }

  Future<Widget> loadImageFromFile(String filePath) async {
    print('============ loadImageFromFile ===== $filePath');
    if (filePath.startsWith('assets/')) {
      // If the path starts with 'assets/', load from assets
      return Image.asset(filePath, width: 60, height: 60);
    } else {
      final file = File(filePath);

      if (await file.exists()) {
        // If the file exists in local storage, load it
        return Image.file(
          file,
          width: 60,
          height: 60,
        );
      }
    }

    // If no valid image is found, return a default placeholder
    return Image.asset(
      "assets/images/default_placeholder.png",
      width: 60,
      height: 60,
    ); // You can replace this with your placeholder image
  }

  @override
  Widget build(BuildContext context) {
    var searchKey = widget.searchKey;
    List<dynamic> tracerData = widget.results;

    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // Add your arrow icon here
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => const Home()));
          },
        ),
        title: const Text('Scan Results'), // Add your app title here
      ),
      body: tracerData.isEmpty
          ? const Center(
              child: Text(
                '--- No Results ---',
                style: TextStyle(color: Colors.red),
              ),
            )
          : Column(
              children: [
                Expanded(
                    child: searchKey == 'TREE'
                        ? ListView.builder(
                            itemCount: tracerData.length,
                            itemBuilder: (context, index) {
                              // Check if the first result has already been displayed
                              if (index > 0) {
                                return const SizedBox
                                    .shrink(); // Skip the remaining results
                              }

                              final imageData = tracerData[index]['image'];
                              final mangroveId =
                                  tracerData[index]['image']['id'];
                              print(
                                  '====== Similarity Score: ${tracerData[index]['score']}');

                              return GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ViewSpecies(
                                                  tracerId: mangroveId ?? 0,
                                                  category: searchKey,
                                                  userType: 'User',
                                                )));
                                  },
                                  child: ListTile(
                                    title: Text(
                                        'Local Name: ${imageData['local_name']}'),
                                    subtitle: Text(
                                        'Score: ${tracerData[index]['score']}%'),
                                    leading: FutureBuilder<Widget>(
                                      future: loadImageFromFile(
                                          imageData['imagePath']),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.done) {
                                          return snapshot.data ??
                                              const CircularProgressIndicator();
                                        } else {
                                          return const CircularProgressIndicator(); // Or another loading indicator
                                        }
                                      },
                                    ),
                                  ));
                            },
                          )
                        : ListView.builder(
                            itemCount: tracerData.length,
                            itemBuilder: (context, index) {
                              final imageDt = tracerData[index]['image'];
                              final mangId =
                                  tracerData[index]['image']['mangroveId'];

                              if (index > 0) {
                                return const SizedBox
                                    .shrink(); // Skip the remaining results
                              }

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
                                subtitle: Text(
                                    'Score: ${tracerData[index]['score']}%'),
                                leading: FutureBuilder<Widget>(
                                  future:
                                      loadImageFromFile(imageDt['imagePath']),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      return snapshot.data ??
                                          const CircularProgressIndicator();
                                    } else {
                                      return const CircularProgressIndicator(); // Or another loading indicator
                                    }
                                  },
                                ),
                              ));
                            },
                          ))
              ],
            ),
    ));
  }
}
