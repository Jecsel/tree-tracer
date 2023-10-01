import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tree_tracer/components/treeImageListState.dart';
import 'package:tree_tracer/models/image_data.dart';
import 'package:tree_tracer/screens/about_us.dart';
import 'package:image_picker/image_picker.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:image_compare/image_compare.dart';
import 'package:path/path.dart';
import 'dart:typed_data';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:tree_tracer/screens/trees.dart';

import '../widgets/image_placeholder.dart';

Future<void> main() async {
  sqfliteFfiInit(); // Initialize the sqflite_ffi library
  databaseFactory = databaseFactoryFfi; // Initialize the databaseFactory

  // Open the database and perform any necessary setup
  final databasePath = await getDatabasesPath();
  final path = join(databasePath, 'mangroove_main_db.db');

  final database = await openDatabase(path);

  // Run your app within the runApp function
  runApp(MyApp(database: database));
}

class MyApp extends StatelessWidget {
  final Database database;

  MyApp({required this.database});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Database database; // Declare a variable to hold the database instance
  String searchQuery = '';
  int _selectedIndex = 0;
  int _selectedIdx = 0;
  final CarouselController _carouselController = CarouselController();

  static const IconData qr_code_scanner_rounded =
  IconData(0xf00cc, fontFamily: 'MaterialIcons');
  final picker = ImagePicker();
  File? localImage;
  File? takenImage;
  double perceptualResult = 0.0;

    /// Compare two images
  Future compareTwoImages() async {
    final perceptual = await compareImages(
        src1: localImage, src2: takenImage, algorithm: PerceptualHash());

    setState(() {
      perceptualResult = 100 - (perceptual * 100);
    });
    print('Difference: ${perceptualResult}%');
  }

  /// Get from gallery
  Future _getFromGallery() async {
    final pickedFileFromGallery = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    print('pickFile');
    print(pickedFileFromGallery);

    if (pickedFileFromGallery != null) {
      setState(() {
        localImage = File(pickedFileFromGallery.path);
      });
    }
  }

  /// Get Image from Camera
  Future _getImageFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    print('pickFile');
    print(pickedFile);

    if (pickedFile != null) {
      setState(() {
        takenImage = File(pickedFile.path);
        // Compare the images here and show the result
      });
    }
  }

  // Define a list of ImageData objects
  List<ImageData> imageDataList = [
    ImageData(
      imagePath: "assets/images/app_logo.jpg",
      name: "Image 1",
      description: "This is the first image.",
    ),
    ImageData(
      imagePath: "assets/images/app_logo.jpg",
      name: "Image 2",
      description: "This is the second image.",
    ),
    // add more images here...
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIdx = index;
    });
  }

  void _goToPreviousSlide() {
    _carouselController.previousPage();
  }

  void _goToNextSlide() {
    _carouselController.nextPage();
  }

  void _onItemTappedCat(int index) {
    setState(() {
      _selectedIdx = index;
    });
  }

  _drawerItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Tree Tracer'),
          backgroundColor: Colors.green, // Set the background color here
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  
                  if (localImage != null)
                    Image.file(
                      localImage!,
                      height: 150,
                    ),
                  SizedBox(height: 10),
                  if(takenImage != null)
                    Image.file(
                      takenImage!,
                        height: 150,
                    ),
                  SizedBox(height: 10),
                  if(takenImage != null && localImage != null)
                    Text('${perceptualResult.toInt().toString()} % Matched!'),
                  SizedBox(height: 10),
                  if(takenImage == null)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: _getImageFromCamera,
                      child: const Text("Scan"),
                    ),
                  SizedBox(height: 10),
                  if(takenImage != null && localImage == null)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: _getFromGallery,
                      child: const Text("Upload Image"),
                  ),
                  SizedBox(height: 10),
                  if(takenImage != null && localImage == null)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text("Find Match"),
                    ),
                  SizedBox(height: 10),
                  if(takenImage != null  && localImage != null) 
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: compareTwoImages,
                      child: const Text("Compare"),
                    ),
                  SizedBox(height: 10),
                ],
              ),
            ),

            Expanded(
              child: Center(
                child: _getSelectedWidget(),
              ),
            ),
          ],
        ),
        endDrawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              _buildDrawerItem(
                title: 'Home',
                index: 0,
                onTap: () {
                  _drawerItemTapped(0);
                  Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Home()));
                },
              ),
              _buildDrawerItem(
                title: 'Trees',
                index: 1,
                onTap: () {
                  Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Trees()));
                },
              ),
              _buildDrawerItem(
                title: 'About Us',
                index: 2,
                onTap: () {
                  Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => AboutUs()));
                },
              ),
              _buildDrawerItem(
                title: 'Exit',
                index: 3,
                onTap: () {
                  _drawerItemTapped(3);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
                backgroundColor: Colors.blueAccent),
            BottomNavigationBarItem(
                icon: Icon(Icons.grass),
                label: 'Trees',
                backgroundColor: Colors.blueAccent),
            BottomNavigationBarItem(
                icon: Icon(Icons.face),
                label: 'About',
                backgroundColor: Colors.blueAccent),
            // BottomNavigationBarItem(
            //     icon: Icon(Icons.qr_code_scanner_sharp),
            //     label: 'Scan',
            //     backgroundColor: Colors.blueAccent),
            BottomNavigationBarItem(
                icon: Icon(Icons.exit_to_app),
                label: 'Exit',
                backgroundColor: Colors.blueAccent),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: (int index) {
            switch (index) {
              case 0:
                // _drawerItemTapped(0);
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Home()));
              case 1:
                Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => Trees()));
                // _drawerItemTapped(1);
                // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Trees()));
              case 2:
                // _drawerItemTapped(2);
                Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => AboutUs()));
              // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> AboutUs()));
              // case 3:
              //   showModal(context);
              case 3:
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Home()));
            }
            setState(
              () {
                _selectedIndex = index;
              },
            );
          },
        ),
      ),
      routes: {
        '/mangrooves': (context) => Trees(),
        '/about_us': (context) => AboutUs(),
      },
    );
  }

  void showModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: const Text('Example Dialog'),
        actions: <TextButton>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Close'),
          )
        ],
      ),
    );
  }

  Widget _getSelectedWidget() {
    switch (_selectedIndex) {
      case 0:
        return _homePage();
      case 1:
        return Trees();
      case 2:
        return AboutUs();
      default:
        return Text('Unknown Page');
    }
  }

  Widget _homePage() {
    // return TreeImageList(database: database);
    // Filter the imageDataList based on the searchQuery
    final filteredDataList = imageDataList
        .where((data) =>
            data.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
            data.description.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return ListView.separated(
      itemCount: filteredDataList.length,
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemBuilder: (BuildContext context, int index) {
        final imageData = filteredDataList[index];
        return ListTile(
          leading: Container(
            width: 100, // Adjust the width as needed
            height: 100, // Adjust the height as needed
            child: Image.asset(imageData.imagePath, fit: BoxFit.cover),
          ),
          title: Text(imageData.name),
          subtitle: Text(imageData.description),
        );
      },
    );
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
}

class MyFAB extends StatefulWidget {
  @override
  _MyFABState createState() => _MyFABState();
}

class _MyFABState extends State<MyFAB> {
  static const IconData qr_code_scanner_rounded =
      IconData(0xf00cc, fontFamily: 'MaterialIcons');
  final picker = ImagePicker();
  File? localImage;
  File? takenImage;

  double perceptualResult = 0.0;

  /// Compare two images
  Future compareTwoImages() async {
    final perceptual = await compareImages(
        src1: localImage, src2: takenImage, algorithm: PerceptualHash());

    setState(() {
      perceptualResult = 100 - (perceptual * 100);
    });
    print('Difference: ${perceptualResult}%');
  }

  /// Get from gallery
  Future _getFromGallery() async {
    final pickedFileFromGallery = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    print('pickFile');
    print(pickedFileFromGallery);

    if (pickedFileFromGallery != null) {
      setState(() {
        localImage = File(pickedFileFromGallery.path);
      });
    }
  }

  /// Get Image from Camera
  Future getImageFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    print('pickFile');
    print(pickedFile);

    if (pickedFile != null) {
      setState(() {
        takenImage = File(pickedFile.path);
        // Compare the images here and show the result
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        // Add your action here when the FAB is tapped.
        // For example, you can open a dialog to add items to the list.
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Select'),
              content: SingleChildScrollView(
                // Wrap the Column with SingleChildScrollView
                child: Column(
                  children: [
                    localImage != null
                        ? Image.file(
                            localImage!,
                            height: 150,
                          )
                        : Text('Local Image Placeholder'),
                    SizedBox(height: 10),
                    takenImage != null
                        ? Image.file(
                            takenImage!,
                            height: 150,
                          )
                        : Text('Taken Image Placeholder'),
                    SizedBox(height: 10),
                    Text(
                        'PerceptualHash ${perceptualResult.toInt().toString()} %'),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: compareTwoImages,
                      child: Text('Compare Images'),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _getFromGallery,
                      child: Text('Take Local Image'),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: getImageFromCamera,
                      child: Text('Take Image'),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Add'),
                  onPressed: () {
                    // Add your logic to add the item to the list here.
                    // You can update the list using a Stateful widget or a state management solution like Provider or Riverpod.
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
      child: const Icon(qr_code_scanner_rounded),
    );
  }
}
