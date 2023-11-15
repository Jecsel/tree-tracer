// lib/main.dart
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tree_tracer/models/favourite_model.dart';
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

  List<File>? tracerFileImageArray;
  // List<String>? tracerPathImageArray = ['/data/user/0/com.example.tree_tracer/cache/scaled_IMG20231111120429.jpg','/data/user/0/com.example.tree_tracer/cache/scaled_IMG20231111120429.jpg'];
  List<String> tracerPathImageArray = [];
  List<File> tempTracerFileImageArray = [];

  File? tracerImage;
  File? fruitImage;
  File? leafImage;
  File? flowerImage;
  File? rootImage;

  File? takenImage;

  List<String> treeImagePathList = [];

  String? treeImagePath = 'assets/images/default_placeholder.png';
  String? fruitImagePath = 'assets/images/default_placeholder.png';
  String? leafImagePath = 'assets/images/default_placeholder.png';
  String? flowerImagePath = 'assets/images/default_placeholder.png';
  String? rootImagePath = 'assets/images/default_placeholder.png';

  //For Main Tree
  TextEditingController localNameController = TextEditingController();
  TextEditingController scientificNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController summaryController = TextEditingController();
  TextEditingController familyController = TextEditingController();
  TextEditingController benifitsController = TextEditingController();
  TextEditingController usesController = TextEditingController();
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
    print('======== tracerImage ========');
    print(tracerImage);

    if(tracerImage != null){
      print('======== mangroveImages is not null ========');

      final List<int> bytes = await tracerImage!.readAsBytes();
      final List<int> rootBytes = await tracerImage!.readAsBytes();
      final List<int> flowerBytes = await tracerImage!.readAsBytes();
      final List<int> leafBytes = await tracerImage!.readAsBytes();
      final List<int> fruitBytes = await tracerImage!.readAsBytes();
      
      final Uint8List mangroveImageBytes = Uint8List.fromList(bytes);
      final Uint8List rootImageBytes =  Uint8List.fromList(rootBytes);
      final Uint8List flowerImageBytes =  Uint8List.fromList(flowerBytes);
      final Uint8List leafImageBytes =  Uint8List.fromList(leafBytes);
      final Uint8List fruitImageBytes =  Uint8List.fromList(fruitBytes);

      final newMangroove = TracerModel(
        imagePath: treeImagePath,
        local_name: localNameController.text,
        scientific_name: scientificNameController.text,
        description: descriptionController.text,
        summary: 'No Summary',
        family: familyController.text,
        benifits: benifitsController.text,
        uses: usesController.text,
        favourite: 0
      );
      
      final insertedMangrove = await dbHelper?.insertDBMangroveData(newMangroove);

      
      for (var tracerImgPath in treeImagePathList) {
        final fav = FavouriteModel(
          tracerId: insertedMangrove ?? 1,
          imagePath: tracerImgPath
        );

        final newFav = await dbHelper?.insertDBFavouriteData(fav);
      }

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
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> AdminPage(searchKey: 'TREE', userType: 'Admin')));
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
        print('===******===== pickedFileFromGallery.path ===*****=====');
        print(pickedFileFromGallery.path);

        String imgPath = pickedFileFromGallery.path;
        tracerImage = File(imgPath);

        tracerFileImageArray?.add(tracerImage!);
        tracerPathImageArray.add(pickedFileFromGallery.path);

        treeImagePath = imgPath;
        treeImagePathList.add(imgPath);

        print('treeImagePathList');
        print(treeImagePathList);
        print(treeImagePathList.length);
      });
    }
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

  Future<void> removeImageInArray(int index) async {

    setState(() {
      tempTracerFileImageArray.removeAt(index);

      print('tempTracerFileImageArray');
      print(tempTracerFileImageArray);

    });
  }

  @override
  Widget build(BuildContext context) {

    print("===tracerImage======= ${tracerImage} ===========");
    if (tracerImage != null) {
      tempTracerFileImageArray.add(tracerImage!);
    }
    

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back), // Add your arrow icon here
              onPressed: () {
                Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => AdminPage(searchKey: 'TREE', userType: 'User',)));
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
                    Container(
                      height: 150.0,
                      child: tempTracerFileImageArray.length > 0 ? 
                        ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: tempTracerFileImageArray.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Stack(
                                children: [
                                  Image.file(
                                    tempTracerFileImageArray[index],
                                    width: 150.0, // Adjust the width as needed
                                    height: 150.0, // Adjust the height as needed
                                    fit: BoxFit.cover,
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: () {
                                        removeImageInArray(index);
                                      },
                                      child: Icon(
                                        Icons.remove_circle,
                                        color: Colors.red,
                                        size: 30.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        )

                        : Image.asset(
                            'assets/images/default_placeholder.png',
                            height: 150,
                            width: 150,
                          ),
                    ),

                    // tracerImage != null
                    //     ? Image.file(
                    //         tracerImage!,
                    //         height: 150,
                    //       )
                    //     : Image.asset(
                    //         'assets/images/default_placeholder.png',
                    //         height: 150,
                    //         width: 150,
                    //       ),
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
                              Text('Add Tree Image'),
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
                        decoration: InputDecoration(labelText: 'Common Name'),
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
                        controller: familyController,
                        decoration: InputDecoration(labelText: 'Family'),
                        maxLines: 2, // You can adjust the number of lines
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
                        controller: benifitsController,
                        decoration: InputDecoration(labelText: 'Benifits'),
                        maxLines: 4, // You can adjust the number of lines
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                      child: TextField(
                        controller: usesController,
                        decoration: InputDecoration(labelText: 'Uses'),
                        maxLines: 4, // You can adjust the number of lines
                      ),
                    ),
                    
                    SizedBox(height: 30),
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
                          child: Text('UPLOAD')
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )));
  }
  }
