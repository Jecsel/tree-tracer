// lib/main.dart
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tree_tracer/models/flower_model.dart';
import 'package:tree_tracer/models/fruit_model.dart';
import 'package:tree_tracer/models/leaf_model.dart';
import 'package:tree_tracer/models/root_model.dart';
import 'package:tree_tracer/models/tracer_model.dart';
import 'package:tree_tracer/screens/admin.dart';
import 'package:tree_tracer/screens/user_tree_list.dart';
import 'package:tree_tracer/services/database_helper.dart';

class AddSpecies extends StatefulWidget {
  @override
  _AddSpeciesState createState() => _AddSpeciesState();
}

class _AddSpeciesState extends State<AddSpecies> {
  final picker = ImagePicker();
  File? mangroveImage;
  File? fruitImage;
  File? leafImage;
  File? flowerImage;
  File? rootImage;

  File? takenImage;

  String? mangroveImagePath = 'assets/images/default_placeholder.png';
  String? fruitImagePath = 'assets/images/default_placeholder.png';
  String? leafImagePath = 'assets/images/default_placeholder.png';
  String? flowerImagePath = 'assets/images/default_placeholder.png';
  String? rootImagePath = 'assets/images/default_placeholder.png';

  //For Main Tree
  TextEditingController localNameController = TextEditingController();
  TextEditingController scientificNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController summaryController = TextEditingController();
  //For Root
  TextEditingController rootNameInput = TextEditingController();
  TextEditingController rootDescInput = TextEditingController();
  //For Flower
  TextEditingController flowerNameInput = TextEditingController();
  TextEditingController flowerDescInput = TextEditingController(); 
  //For Leaf
  TextEditingController leafNameInput = TextEditingController();
  TextEditingController leafDescInput = TextEditingController();
  TextEditingController leafImputInput = TextEditingController();
  //For fruit
  TextEditingController fruitNameInput = TextEditingController();
  TextEditingController fruitDescInput = TextEditingController();
  TextEditingController fruitImputInput = TextEditingController();

  MangroveDatabaseHelper? dbHelper;
  List<TracerModel> mangroveDataList = [];
  List<FruitModel> fruitDataList = [];
  List<LeafModel> leafDataList = [];
  List<FlowerModel> flowerDataList = [];
  List<RootModel> rootDataList = [];

  @override
  void initState() {
    super.initState();
    dbHelper = MangroveDatabaseHelper.instance;
  }

  Future<Uint8List> fileToUint8List(File file) async {
    final List<int> bytes = await file.readAsBytes();
    print('======== bytes ========');
    print(bytes);

    print('========  Uint8List.fromList(bytes) ========');
    print( Uint8List.fromList(bytes));
    return Uint8List.fromList(bytes);
  }

  Future<void> _insertMangrooveData() async {
    print('======== mangroveImage ========');
    print(mangroveImage);

    if(mangroveImage != null){
      print('======== mangroveImages is not null ========');

      final List<int> bytes = await mangroveImage!.readAsBytes();
      final List<int> rootBytes = await mangroveImage!.readAsBytes();
      final List<int> flowerBytes = await mangroveImage!.readAsBytes();
      final List<int> leafBytes = await mangroveImage!.readAsBytes();
      final List<int> fruitBytes = await mangroveImage!.readAsBytes();
      
      final Uint8List mangroveImageBytes = Uint8List.fromList(bytes);
      final Uint8List rootImageBytes =  Uint8List.fromList(rootBytes);
      final Uint8List flowerImageBytes =  Uint8List.fromList(flowerBytes);
      final Uint8List leafImageBytes =  Uint8List.fromList(leafBytes);
      final Uint8List fruitImageBytes =  Uint8List.fromList(fruitBytes);

      final newMangroove = TracerModel(
        imagePath: mangroveImagePath,
        local_name: localNameController.text,
        scientific_name: scientificNameController.text,
        description: descriptionController.text,
        summary: summaryController.text
      );
      
      final insertedMangrove = await dbHelper?.insertDBMangroveData(newMangroove);

      final newRoot = RootModel(
        imagePath: rootImagePath,
        tracerId: insertedMangrove ?? 0,
        name: rootNameInput.text,
        description: rootDescInput.text,
      );

      final newFlower = FlowerModel(
        imagePath: flowerImagePath,
        tracerId: insertedMangrove ?? 0,
        name: flowerNameInput.text,
        description: flowerDescInput.text
      );

      final newLeaf = LeafModel(
        imagePath: leafImagePath,
        tracerId: insertedMangrove ?? 0,
        name: leafNameInput.text,
        description: leafDescInput.text,
      );

      final newFruit = FruitModel(
        imagePath: fruitImagePath,
        tracerId: insertedMangrove ?? 0,
        name: fruitNameInput.text,
        description: fruitDescInput.text,
      );

      final root_id = dbHelper?.insertDBRootData(newRoot);
      final flower_id = dbHelper?.insertDBFlowerData(newFlower);
      final leaf_id = dbHelper?.insertDBLeafData(newLeaf);
      final fruit_id = dbHelper?.insertDBFruitData(newFruit);
    }
  }

  _gotoSearchList() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> AdminPage(searchKey: 'TREE', pageType: 'Admin')));
  }

  Future _getFromGallery(fromField) async {
    /// Get from gallery
    final pickedFileFromGallery = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );

    if (pickedFileFromGallery != null) {
      setState(() {
        switch (fromField) {
          case "tree":
            print('===******===== pickedFileFromGallery.path ===*****=====');
            print(pickedFileFromGallery.path);
            mangroveImage = File(pickedFileFromGallery.path);
            mangroveImagePath = pickedFileFromGallery.path;
            break;
          case "root":
            rootImage = File(pickedFileFromGallery.path);
            rootImagePath = pickedFileFromGallery.path;
            break;
          case "flower":
            flowerImage = File(pickedFileFromGallery.path);
            flowerImagePath = pickedFileFromGallery.path;
            break;
          case "leaf":
            leafImage = File(pickedFileFromGallery.path);
            leafImagePath = pickedFileFromGallery.path;
            break;
          case "fruit":
            fruitImage = File(pickedFileFromGallery.path);
            fruitImagePath = pickedFileFromGallery.path;
            break;
          default:
            mangroveImage = File(pickedFileFromGallery.path);
            mangroveImagePath = pickedFileFromGallery.path;
        }
        
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back), // Add your arrow icon here
              onPressed: () {
                Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => AdminPage(searchKey: 'TREE', pageType: 'User',)));
              },
              
            ),
            title: Text('Search Tree')
            ),
            body: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Text(
                      "Tree",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    mangroveImage != null
                        ? Image.file(
                            mangroveImage!,
                            height: 150,
                          )
                        : Image.asset(
                            'assets/images/default_placeholder.png',
                            height: 150,
                            width: 150,
                          ),
                    SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                        child: ElevatedButton(
                          onPressed: () {
                            _getFromGallery('tree');
                          },
                          style: ElevatedButton.styleFrom(
                              textStyle: TextStyle(fontSize: 20),
                              minimumSize: Size(double.infinity, 60)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Upload Tree Image'),
                              Icon(Icons.add)
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                      child: TextField(
                        controller: localNameController,
                        decoration: InputDecoration(labelText: 'Local Name'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                      child: TextField(
                        controller: scientificNameController,
                        decoration:
                            InputDecoration(labelText: 'Scientific Name'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                      child: TextField(
                        controller: descriptionController,
                        decoration: InputDecoration(labelText: 'Description'),
                        maxLines: 2, // You can adjust the number of lines
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                      child: TextField(
                        controller: summaryController,
                        decoration: InputDecoration(labelText: 'Summary'),
                        maxLines: 4, // You can adjust the number of lines
                      ),
                    ),
                    
                    SizedBox(height: 30),
                    Text(
                      "Root",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    rootImage != null
                        ? Image.file(
                            rootImage!,
                            height: 150,
                          )
                        : Image.asset(
                            'assets/images/default_placeholder.png',
                            height: 150,
                            width: 150,
                          ),
                    SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                        child: ElevatedButton(
                          onPressed: () {
                            _getFromGallery('root');
                          },
                          style: ElevatedButton.styleFrom(
                              textStyle: TextStyle(fontSize: 20),
                              minimumSize: Size(double.infinity, 60)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Upload Root Image'),
                              Icon(Icons.add)
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                      child: TextField(
                        controller: rootNameInput,
                        decoration: InputDecoration(labelText: 'Name'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                      child: TextField(
                        controller: rootDescInput,
                        decoration: InputDecoration(labelText: 'Description'),
                        maxLines: 2, // You can adjust the number of lines
                      ),
                    ),

                    SizedBox(height: 30),
                    Text(
                      "Flower",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    flowerImage != null
                        ? Image.file(
                            flowerImage!,
                            height: 150,
                          )
                        : Image.asset(
                            'assets/images/default_placeholder.png',
                            height: 150,
                            width: 150,
                          ),
                    SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                        child: ElevatedButton(
                          onPressed: () {
                            _getFromGallery('flower');
                          },
                          style: ElevatedButton.styleFrom(
                              textStyle: TextStyle(fontSize: 20),
                              minimumSize: Size(double.infinity, 60)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Upload Flower Image'),
                              Icon(Icons.add)
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                      child: TextField(
                        controller: flowerNameInput,
                        decoration: InputDecoration(labelText: 'Name'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                      child: TextField(
                        controller: flowerDescInput,
                        decoration: InputDecoration(labelText: 'Description'),
                        maxLines: 2, // You can adjust the number of lines
                      ),
                    ),

                    SizedBox(height: 30),
                    Text(
                      "Leaf",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    leafImage != null
                        ? Image.file(
                            leafImage!,
                            height: 150,
                          )
                        : Image.asset(
                            'assets/images/default_placeholder.png',
                            height: 150,
                            width: 150,
                          ),
                    SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                        child: ElevatedButton(
                          onPressed: () {
                            _getFromGallery('leaf');
                          },
                          style: ElevatedButton.styleFrom(
                              textStyle: TextStyle(fontSize: 20),
                              minimumSize: Size(double.infinity, 60)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Upload Leaf Image'),
                              Icon(Icons.add)
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                      child: TextField(
                        controller: leafNameInput,
                        decoration: InputDecoration(labelText: 'Name'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                      child: TextField(
                        controller: leafDescInput,
                        decoration: InputDecoration(labelText: 'Description'),
                        maxLines: 2, // You can adjust the number of lines
                      ),
                    ),

                    SizedBox(height: 30),
                    Text(
                      "Fruit",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    fruitImage != null
                        ? Image.file(
                            fruitImage!,
                            height: 150,
                          )
                        : Image.asset(
                            'assets/images/default_placeholder.png',
                            height: 150,
                            width: 150,
                          ),
                    SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                        child: ElevatedButton(
                          onPressed: () {
                            _getFromGallery('fruit');
                          },
                          style: ElevatedButton.styleFrom(
                              textStyle: TextStyle(fontSize: 20),
                              minimumSize: Size(double.infinity, 60)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Upload Fruit Image'),
                              Icon(Icons.add)
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                      child: TextField(
                        controller: fruitNameInput,
                        decoration: InputDecoration(labelText: 'Name'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                      child: TextField(
                        controller: fruitDescInput,
                        decoration: InputDecoration(labelText: 'Description'),
                        maxLines: 2, // You can adjust the number of lines
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                        child: ElevatedButton(
                          onPressed: () {
                            _insertMangrooveData();
                            _gotoSearchList();
                          },
                          style: ElevatedButton.styleFrom(
                              textStyle: TextStyle(fontSize: 20),
                              backgroundColor:  Color.fromARGB(255, 2, 191, 5),
                              minimumSize: Size(double.infinity, 60)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('SUBMIT'),
                              Icon(Icons.upload)
                            ],
                          ),
                        ),
                      ),
                    ),
                    // ElevatedButton(
                    //   onPressed: () {
                    //     _insertMangrooveData();
                    //     _gotoSearchList();
                    //   },
                    //   child: Text("Upload Mangroove"),
                    // ),
                  ],
                ),
              ),
            )));
  }
  }
