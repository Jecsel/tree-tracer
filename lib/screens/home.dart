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
import 'package:tree_tracer/screens/admin.dart';
import 'package:tree_tracer/screens/result.dart';
import 'package:tree_tracer/screens/trees.dart';
import 'package:tree_tracer/screens/user_tree_list.dart';
import 'package:tree_tracer/services/database_helper.dart';
import 'package:tree_tracer/ui_components/main_view.dart';

import '../widgets/image_placeholder.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {

  // Run your app within the runApp function
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  MyApp();

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
  List<Map>? mangroveImages;
  List<Map<String, dynamic>> similarImages = [];
  late MangroveDatabaseHelper dbHelper;
  bool isErrorShow = false;

  @override
  void initState() {
    super.initState();
      print("======= initState ===========");
      dbHelper = MangroveDatabaseHelper.instance;
      fetchData();
  }

  Future<void> fetchData() async {
    mangroveImages = await dbHelper.getImagesFromMangrove();
  }

  Future _getFromGallery() async {
    final pickedFileFromGallery = await ImagePicker().getImage(     /// Get from gallery
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    print('pickFile');
    print(pickedFileFromGallery?.path);

    print('mangroveImages');
    print(mangroveImages!.length);

    localImage = File(pickedFileFromGallery!.path);

    for (Map mangroveImage in mangroveImages!) {
      String imagePath = mangroveImage['imagePath'];
      print('mANGROVE imagePath');
      print(imagePath);
      print('mANGROVE localImage');
      print(localImage);

      print("mangroveImage['imageBlob']");
      print(mangroveImage['imageBlob']);

      final tempDir = await getTemporaryDirectory();
      final tempPath = tempDir.path;
      final file = File('$tempPath/temp_image.jpg');
      if(mangroveImage['imageBlob'] != null) {
        await file.writeAsBytes(mangroveImage['imageBlob']);
      }
      print('========== PASOK ========');

      double similarityScore = await compareImages(src1: localImage, src2: File(imagePath), algorithm: PerceptualHash());

      if (imagePath.startsWith('assets/')) {
        similarityScore = await compareImages(src1: localImage, src2: file, algorithm: PerceptualHash());
      }

      print("similarityScore $similarityScore.");

      if (similarityScore <= 0.5) {
        print("Gallery image is similar to $similarityScore.");

        similarityScore = 100 - (similarityScore * 100);
        Map<String, dynamic> imageInfo = {
          "score": similarityScore,
          "image": mangroveImage, // Add the image or any other relevant information here
        };
        similarImages.add(imageInfo); //adding those results higher 50 percentage differences;
        similarImages.sort((a, b) => b["score"].compareTo(a["score"]));
      }else{
        similarityScore = 100 - (similarityScore * 100);
        print("Gallery image is BELOW similar to $similarityScore.");
      }
    }

    setState(() {
      localImage = File(pickedFileFromGallery.path);  
      similarImages = similarImages;

      print("similarImages ${similarImages.length}");
      isErrorShow = false;
      if(similarImages.length > 0) {
        Navigator.pushReplacement(this.context, MaterialPageRoute(builder: (context)=> ResultPage(results: similarImages, searchKey: 'TREE')));
      } else {
        isErrorShow = true;
        final snackBar = SnackBar(
          content: Text('No Results Found!'),
        );
        ScaffoldMessenger.of(this.context).showSnackBar(snackBar);
      }
    });
  }

  // Future<File> getImageFileFromAsset(String assetPath) async {
  //   final ByteData data = await rootBundle.load(assetPath);
  //   final List<int> bytes = data.buffer.asUint8List();
  //   final String tempFileName = assetPath.split('/').last;

  //   final Directory tempDir = await getTemporaryDirectory();
  //   final File tempFile = File('${tempDir.path}/$tempFileName');
    
  //   await tempFile.writeAsBytes(bytes, flush: true);
  //   return tempFile;
  // }

  checkImagePath(filePath) {
    if (!filePath.startsWith('assets/')) {
      return File(filePath);
    }

    return filePath;
  }

  Future _getImageFromCamera() async {    /// Get Image from Camera
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    print('pickFile');
    print(pickedFile);

    for (Map mangroveImage in mangroveImages!) {
      String imagePath = mangroveImage['imagePath'];

      print('mANGROVE IMAGES');
      print(imagePath);

      double similarityScore = 1.0;

      final tempDir = await getTemporaryDirectory();
      final tempPath = tempDir.path;
      final file = File('$tempPath/temp_image.jpg');
      await file.writeAsBytes(mangroveImage['imageBlob']);

      if (imagePath.startsWith('assets/')) {
        similarityScore = await compareImages(src1: localImage, src2: file, algorithm: PerceptualHash());
      } else {
         similarityScore = await compareImages(src1: File(pickedFile!.path), src2: imagePath, algorithm: PerceptualHash());
      }

      if (similarityScore <= 0.5) {
        print("Gallery image is similar to $similarityScore.");
        similarityScore = 100 - (similarityScore * 100);
        Map<String, dynamic> imageInfo = {
          "score": similarityScore,
          "image": mangroveImage, // Add the image or any other relevant information here
        };
        similarImages.add(imageInfo); //adding those results higher 50 percentage differences;
        similarImages.sort((a, b) => b["score"].compareTo(a["score"]));
      }else{
        print("Gallery image is BELOW similar to $similarityScore.");
      }
    }

    if (pickedFile != null) {
      setState(() {
        takenImage = File(pickedFile.path);// Compare the images here and show the result
        if(similarImages.length > 0) {
          Navigator.pushReplacement(this.context, MaterialPageRoute(builder: (context)=> ResultPage(results: similarImages, searchKey: 'TREE')));
        } else {
          final snackBar = SnackBar(
            content: Text('No Results Found!'),
          );
          ScaffoldMessenger.of(this.context).showSnackBar(snackBar);
        }
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

  _showModal() {
  BuildContext context = this.context;
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: Container(
          height: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _getFromGallery,
                child: Text('Take Local Image'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _getImageFromCamera,
                child: Text('      Scan Image     '),
              ),
              Visibility(
                visible: isErrorShow,
                child: Text(
                "No Results Found",
                style: TextStyle(
                  color: Colors.red
                ),
              ) 
              )
              
            ],
          ),
        ),
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

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.blue, Colors.lightBlue],
              ),
            ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icon.png',
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'TREE TRACER',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: _showModal,
                child: const Text("Scan"),
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
                title: 'Favorite',
                index: 1,
                onTap: () {
                  Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Trees()));
                },
              ),
              _buildDrawerItem(
                title: 'Admin',
                index: 2,
                onTap: () {
                  Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => MainView()));
                },
              ),
              _buildDrawerItem(
                title: 'Tree List',
                index: 3,
                onTap: () {
                  Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => UserTreeList(searchKey: 'TREE', userType: 'User',)));
                },
              ),
              _buildDrawerItem(
                title: 'About Us',
                index: 4,
                onTap: () {
                  Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => AboutUs()));
                },
              ),
              _buildDrawerItem(
                title: 'Exit',
                index: 5,
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
                MaterialPageRoute(builder: (context) => UserTreeList(searchKey: 'TREE', userType: 'User',)));
              case 2:
                // _drawerItemTapped(2);
                Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => AboutUs()));
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
