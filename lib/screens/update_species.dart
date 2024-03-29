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

class UpdateSpecies extends StatefulWidget {
  final int tracerId;

  const UpdateSpecies({super.key, required this.tracerId});

  @override
  _UpdateSpeciesState createState() => _UpdateSpeciesState();
}

class _UpdateSpeciesState extends State<UpdateSpecies> {
  final picker = ImagePicker();
  
  File? tracerImage;
  File? fruitImage;
  File? leafImage;
  File? flowerImage;
  File? rootImage;

  TracerModel? tracerData;
  RootModel? rootData;
  FlowerModel? flowerData;
  LeafModel? leafData;
  FruitModel? fruitData;

  File? takenImage;
  Uint8List? tracerImg;

  String? tracerImagePath = 'assets/images/default_placeholder.png';
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
  TextEditingController triviaController = TextEditingController();
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

  TracerDatabaseHelper? dbHelper;
  List<TracerModel> tracerDataList = [];
  List<FruitModel> fruitDataList = [];
  List<LeafModel> leafDataList = [];
  List<FlowerModel> flowerDataList = [];
  List<RootModel> rootDataList = [];
  List<File> tempTracerFileImageArray = [];
  List<FavouriteModel>? tracerFavs = [];

  @override
  void initState() {
    super.initState();
    dbHelper = TracerDatabaseHelper.instance;
    fetchData();
  }

  Future<void> fetchData() async {
    int mangroveId = widget.tracerId;
    TracerModel? tracerResultData = await dbHelper?.getOneTracerData(mangroveId);

     tracerFavs = await dbHelper?.getFavouriteDataList(mangroveId);

    for (var imgPaths in tracerFavs!) {
      tempTracerFileImageArray.add(File(imgPaths.imagePath));
    }

    setState(() {
      tracerData = tracerResultData;
      tracerImg = tracerData!.imageBlob;
      tracerImagePath = tracerData!.imagePath;

      tempTracerFileImageArray = tempTracerFileImageArray;

      localNameController.text = tracerData!.local_name;
      scientificNameController.text = tracerData!.scientific_name;
      descriptionController.text = tracerData!.description;
      summaryController.text = tracerData!.summary;
      familyController.text = tracerData!.family;
      benifitsController.text = tracerData!.benifits;
      usesController.text = tracerData!.uses;
      triviaController.text = tracerData!.trivia;
    });
  }

  Future<Uint8List> fileToUint8List(File file) async {
    final List<int> bytes = await file.readAsBytes();
    return Uint8List.fromList(bytes);
  }

  Future<void> _updateTracerData() async {
    final tracerUpdatedData = TracerModel(
      id: tracerData!.id,
      imageBlob: tracerImg,
      imagePath: tracerImagePath,
      local_name: localNameController.text,  
      scientific_name: localNameController.text,
      description: descriptionController.text,
      summary: summaryController.text,
      family: familyController.text,
      benifits: benifitsController.text,
      uses: usesController.text,
      trivia: triviaController.text,
      favourite: 0
    );

    final insertedTracer = await dbHelper?.updateTracerData(tracerUpdatedData);
  }

  _gotoSearchList() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> AdminPage(searchKey: 'TREE', userType: 'Admin')));
  }

  Future<Widget> loadImageFromFile(String filePath) async {
    if (filePath.startsWith('assets/')) {
      // If the path starts with 'assets/', load from assets
      return SizedBox(
        width: 300,
        height: 250,
        child: Image.asset(filePath, fit: BoxFit.cover)
      );
    } else {
      final file = File(filePath);

      if (await file.exists()) {
        // If the file exists in local storage, load it
        return SizedBox(
          width: 300,
          height: 250,
          child: Image.file(file, fit: BoxFit.cover,)
        );
      }
    }

    // If no valid image is found, return a default placeholder
    return SizedBox(
      width: 300,
      height: 250,
      child: Image.asset("assets/images/default_placeholder.png", fit: BoxFit.cover)
    ); // You can replace this with your placeholder image
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
            tracerImage = File(pickedFileFromGallery.path);
            tracerImagePath = pickedFileFromGallery.path;
            tracerData!.imagePath = pickedFileFromGallery.path;

            final fav = FavouriteModel(
              tracerId: tracerData!.id ?? 1,
              imagePath: pickedFileFromGallery.path
            );
            final newFav = dbHelper?.insertDBFavouriteData(fav);

            tempTracerFileImageArray.add(tracerImage!);
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
            tracerImage = File(pickedFileFromGallery.path);
            tracerImagePath = pickedFileFromGallery.path;
        }
        
      });
    }
  }

  Future<void> removeImageInArray(int index)  async {

    int tracerImgID = tracerFavs?[index].id ?? 1;
    await dbHelper?.deleteFavouriteData(tracerImgID);

    setState(() {
      tempTracerFileImageArray.removeAt(index);

      print('tempTracerFileImageArray');
      print(tempTracerFileImageArray);

    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color.fromARGB(255, 24, 122, 0), Color.fromARGB(255, 82, 209, 90)],
                ),
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back), // Add your arrow icon here
              onPressed: () {
                Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => AdminPage(searchKey: 'TREE', userType: 'User',)));
              },
              
            ),
            title: const Text('Update Tree')
            ),
            body: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      "Tree",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 250.0,
                      child: tempTracerFileImageArray.isNotEmpty ? 
                        ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: tempTracerFileImageArray.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Stack(
                                children: [

                                  FutureBuilder<Widget>(
                                    future: loadImageFromFile(tempTracerFileImageArray[index].path),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.done) {
                                        return snapshot.data ?? const CircularProgressIndicator();
                                      } else {
                                        return const CircularProgressIndicator(); // Or another loading indicator
                                      }
                                    },
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: () {
                                        removeImageInArray(index);
                                      },
                                      child: const Icon(
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
                    // FutureBuilder<Widget>(
                    //   future: loadImageFromFile(tracerData?.imagePath ?? ''),
                    //   builder: (context, snapshot) {
                    //     if (snapshot.connectionState == ConnectionState.done) {
                    //       return snapshot.data ?? CircularProgressIndicator();;
                    //     } else {
                    //       return CircularProgressIndicator(); // Or another loading indicator
                    //     }
                    //   },
                    // ),
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
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                        child: ElevatedButton(
                          onPressed: () {
                            _getFromGallery('tree');
                          },
                          style: ElevatedButton.styleFrom(
                              textStyle: const TextStyle(fontSize: 20),
                              minimumSize: const Size(double.infinity, 60)),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Add Tree Image'),
                              Icon(Icons.add)
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                      child: TextField(
                        controller: localNameController,
                        decoration: const InputDecoration(labelText: 'Common Name'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                      child: TextField(
                        controller: scientificNameController,
                        decoration:
                            const InputDecoration(labelText: 'Scientific Name'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                      child: TextField(
                        controller: familyController,
                        decoration: const InputDecoration(labelText: 'Family'),
                        maxLines: 2, // You can adjust the number of lines
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                      child: TextField(
                        controller: descriptionController,
                        decoration: const InputDecoration(labelText: 'Description'),
                        maxLines: 2, // You can adjust the number of lines
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                      child: TextField(
                        controller: benifitsController,
                        decoration: const InputDecoration(labelText: 'Benifits'),
                        maxLines: 4, // You can adjust the number of lines
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                      child: TextField(
                        controller: usesController,
                        decoration: const InputDecoration(labelText: 'Uses'),
                        maxLines: 4, // You can adjust the number of lines
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                      child: TextField(
                        controller: triviaController,
                        decoration: const InputDecoration(labelText: 'Trivia'),
                        maxLines: 4, // You can adjust the number of lines
                      ),
                    ),
                    
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                        child: ElevatedButton(
                          onPressed: () {
                            _updateTracerData();
                            _gotoSearchList();
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            backgroundColor: Colors.green
                          ),
                          child: const Text('UPDATE', style: TextStyle(color: Colors.white),)
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )));
  }
  }
