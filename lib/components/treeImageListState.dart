import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:typed_data';

class TreeImageList extends StatefulWidget {

  @override
  _TreeImageListState createState() => _TreeImageListState();
}

class _TreeImageListState extends State<TreeImageList> {
  List<Map<String, dynamic>> treeDataList = []; // List to store tree data

  @override
  void initState() {
    super.initState();
    copyDatabase(); // Call the method to copy the database
    loadTreeData(); // Load data from the Tree table when the widget is created
  }

  Future<void> copyDatabase() async {
    // Get a reference to the database
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'tracer_main_db.db');

    // Check if the database file already exists
    if (FileSystemEntity.typeSync(path) == FileSystemEntityType.notFound) {
      // Copy the database from assets to the device's local storage
      final ByteData data = await rootBundle.load('assets/databases/tracer_main_db.db');
      final List<int> bytes = data.buffer.asUint8List();
      await File(path).writeAsBytes(bytes, flush: true);
    }
  }


  Future<void> loadTreeData() async {
    // Open the database
    final database = await openDatabase(
      join(await getDatabasesPath(), 'tracer_main_db.db'),
    );

    // Query the Tree table
    final List<Map<String, dynamic>> trees = await database.query('Tree');

    setState(() {
      treeDataList = trees;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tree Images'),
      ),
      body: Column(
        children: [
          Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                "List of your favorite trees",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20.0
                ),
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: treeDataList.length,
              itemBuilder: (context, index) {
                final tree = treeDataList[index];
                final imageBytes = tree['image'] as Uint8List; // Retrieve image bytes

                return ListTile(
                  title: Text(tree['name'] as String),
                  subtitle: Text(tree['description'] as String),
                  leading: Container(
                    width: 100, // Set the desired width
                    height: 100, // Set the desired height
                    child: Image.memory(
                      imageBytes,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          )
        ],
      )
      
      

    );
  }
}

void main() {
  runApp(MaterialApp(
    home: TreeImageList(),
  ));
}
