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
// import 'package:sqflite_common/sqlite_api.dart';
import 'package:tree_tracer/screens/admin.dart';
import 'package:tree_tracer/screens/favorite.dart';
import 'package:tree_tracer/screens/result.dart';
import 'package:tree_tracer/screens/trees.dart';
import 'package:tree_tracer/screens/trivia_home.dart';
import 'package:tree_tracer/screens/user_tree_list.dart';
import 'package:tree_tracer/services/database_helper.dart';
import 'package:tree_tracer/ui_components/main_view.dart';

import '../widgets/image_placeholder.dart';
import 'package:path_provider/path_provider.dart';

import 'loading_screen.dart';

Future<void> main() async {

  // Run your app within the runApp function
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // late Database database; // Declare a variable to hold the database instance
  String searchQuery = '';
  int _selectedIndex = 0;
  final int _selectedIdx = 0;
  final CarouselController _carouselController = CarouselController();

  static const IconData qr_code_scanner_rounded =
  IconData(0xf00cc, fontFamily: 'MaterialIcons');
  final picker = ImagePicker();
  File? localImage;
  File? takenImage;
  double perceptualResult = 0.0;
  List<Map>? tracerImages;
  List<Map<String, dynamic>> similarImages = [];
  late TracerDatabaseHelper dbHelper;
  bool isErrorShow = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
      dbHelper = TracerDatabaseHelper.instance;
      fetchData();
  }

  Future<void> fetchData() async {
    tracerImages = await dbHelper.getImagesFromTracer();
  }

  Future _getFromGallery() async {
    setState(() {
      isLoading = true;
    });
    final pickedFileFromGallery = await ImagePicker().getImage(     /// Get from gallery
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    // Navigator.pop(this.context);

    localImage = File(pickedFileFromGallery!.path);

    Navigator.pushReplacement(this.context, MaterialPageRoute(builder: (context)=> const MyLoadingScreen()));

    for (Map mangroveImage in tracerImages!) {
      String imagePath = mangroveImage['imagePath'];

      final tempDir = await getTemporaryDirectory();
      final tempPath = tempDir.path;
      final file = File('$tempPath/temp_image.jpg');
      if(mangroveImage['imageBlob'] != null) {
        await file.writeAsBytes(mangroveImage['imageBlob']);
      }

       double similarityScore = 1.0;
      if (imagePath.startsWith('assets/')) {
        similarityScore = await compareImages(src1: localImage, src2: file, algorithm: PerceptualHash());
      } else {
        similarityScore = await compareImages(src1: localImage, src2: File(imagePath), algorithm: PerceptualHash());
      }

      if (similarityScore <= 0.5) {

        similarityScore = 100 - (similarityScore * 100);
        int roundedSimilarityScore = similarityScore.round();
        Map<String, dynamic> imageInfo = {
          "score": similarityScore,
          "image": mangroveImage, // Add the image or any other relevant information here
        };
        similarImages.add(imageInfo); //adding those results higher 50 percentage differences;
        similarImages.sort((a, b) => b["score"].compareTo(a["score"]));
      }else{
        similarityScore = 100 - (similarityScore * 100);
      }
    }

    setState(() {
      localImage = File(pickedFileFromGallery.path);  
      similarImages = similarImages;

      isErrorShow = false;
      isLoading = false;
      if(similarImages.isNotEmpty) {
        Navigator.pushReplacement(this.context, MaterialPageRoute(builder: (context)=> ResultPage(results: similarImages, searchKey: 'TREE')));
      } else {
        isErrorShow = true;
        Navigator.pushReplacement(this.context, MaterialPageRoute(builder: (context)=> ResultPage(results: similarImages, searchKey: 'TREE')));
      }
    });
  }


  checkImagePath(filePath) {
    if (!filePath.startsWith('assets/')) {
      return File(filePath);
    }

    return filePath;
  }

  _goToTrivia(){
    Navigator.pushReplacement(this.context, MaterialPageRoute(builder: (context) => const TriviaHome()));
  }

  _goToTreeList(){
    Navigator.pushReplacement(this.context,
      MaterialPageRoute(builder: (context) => UserTreeList(searchKey: 'TREE', userType: 'User',)
      )
    );

    setState(() {
      _selectedIndex = 1;
    });
    
  }

  Future _getImageFromCamera() async {    /// Get Image from Camera
    setState(() {
      isLoading = true;
    });
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    // Navigator.pop(this.context); 

    for (Map mangroveImage in tracerImages!) {
      String imagePath = mangroveImage['imagePath'];

      double similarityScore = 1.0;

      final tempDir = await getTemporaryDirectory();
      final tempPath = tempDir.path;
      final file = File('$tempPath/temp_image.jpg');
      if(mangroveImage['imageBlob'] != null) {
        await file.writeAsBytes(mangroveImage['imageBlob']);
      }

      if (imagePath.startsWith('assets/')) {
        similarityScore = await compareImages(src1: File(pickedFile!.path), src2: file, algorithm: PerceptualHash());
      } else {
        similarityScore = await compareImages(src1: File(pickedFile!.path), src2: File(imagePath), algorithm: PerceptualHash());
      }

      if (similarityScore <= 0.75) {
        similarityScore = 100 - (similarityScore * 100);
        int roundedSimilarityScore = similarityScore.round();
        Map<String, dynamic> imageInfo = {
          "score": roundedSimilarityScore,
          "image": mangroveImage, // Add the image or any other relevant information here
        };
        similarImages.add(imageInfo); //adding those results higher 50 percentage differences;
        similarImages.sort((a, b) => b["score"].compareTo(a["score"]));
      }
    }

    if (pickedFile != null) {
      setState(() {
        takenImage = File(pickedFile.path);// Compare the images here and show the result
        isErrorShow = false;
        isLoading = false;
        if(similarImages.isNotEmpty) {
          Navigator.pushReplacement(this.context, MaterialPageRoute(builder: (context)=> ResultPage(results: similarImages, searchKey: 'TREE')));
        } else {
          isErrorShow = true;
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

  _drawerItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<bool> _onBackPressed(BuildContext context) async {
    final confirmed = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Exit the app?'),
          content: const Text('Are you sure you want to exit the app?'),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop(false);
                // Navigator.pushReplacement(
                //   context, MaterialPageRoute(builder: (context) => Home()));
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                // Navigator.of(context).pop(true);
                exit(0);
              },
            ),
          ],
        );
      },
    );

    return confirmed ?? false; // Return false if the dialog is dismissed
  }

  _showModal() {
  BuildContext context = this.context;
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: SizedBox(
          height: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _getFromGallery,
                child: const Text('Take Local Image'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _getImageFromCamera,
                child: const Text('      Scan Image     '),
              )
            ],
          ),
        ),
        actions: <TextButton>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);

              setState(() {
                isLoading = false;
              });
            },
            child: const Text('Close'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async {
        return _onBackPressed(context);
        },
      child: MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color.fromARGB(255, 24, 122, 0), Color.fromARGB(255, 82, 209, 90)],
              ),
            ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipOval(
            child: Image.asset(
              "assets/images/app_logo.jpg",
                  width: 200, // Set both width and height to the same value
                  height: 200, // to create a perfect circle
                ),
              ),
            const Padding(
              padding: EdgeInsets.all(10.0),
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
              child: Center(
                child: SizedBox(
                  width: 200,
                  child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: Colors.green
                  ),
                    onPressed: _goToTreeList,
                    child: const Text("Tree List", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: SizedBox(
                  width: 200,
                  child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: Colors.green
                  ),
                    onPressed: _goToTrivia,
                    child: const Text("Trivia", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
            ),


            // const SizedBox(height: 20),
            // Visibility(
            //   visible: isLoading, 
            //   child: Image.asset(
            //     "assets/images/loading.gif",
            //     width: 35,  // Set both width and height to the same value
            //     height: 35, // to create a perfect circle
            //   ),
            // ),
            // const SizedBox(height: 20),
            // Visibility(
            //   visible: !isLoading && isErrorShow,
            //   child: const Text(
            //     "No Results Found!",
            //     style: TextStyle(color: Colors.red),
            //   ))
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
                  context, MaterialPageRoute(builder: (context) => const Home()));
                },
              ),
              _buildDrawerItem(
                title: 'Favorite',
                index: 1,
                onTap: () {
                  Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => FavoritePage()));
                },
              ),
              _buildDrawerItem(
                title: 'Admin',
                index: 2,
                onTap: () {
                  Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const MainView()));
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
                    // Navigator.pop(context);
                  _onBackPressed(context);
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
              backgroundColor: Colors.green),
            BottomNavigationBarItem(
              icon: Icon(Icons.grass),
              label: 'Trees',
              backgroundColor: Colors.green),
            BottomNavigationBarItem(
              icon: Icon(Icons.face),
              label: 'About',
              backgroundColor: Colors.green),
            BottomNavigationBarItem(
              icon: Icon(Icons.exit_to_app),
              label: 'Exit',
              backgroundColor: Colors.green),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: (int index) {
            switch (index) {
              case 0:
                // _drawerItemTapped(0);
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => const Home()));
              case 1:
                Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => UserTreeList(searchKey: 'TREE', userType: 'User',)));
              case 2:
                // _drawerItemTapped(2);
                Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => AboutUs()));
              case 3:
                _onBackPressed(context);
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
        '/tracers': (context) => const Trees(),
        '/about_us': (context) => AboutUs(),
      },
    )
    );
    

  }

  Widget _getSelectedWidget() {
    switch (_selectedIndex) {
      case 0:
        return _homePage();
      case 1:
        return const Trees();
      case 2:
        return AboutUs();
      default:
        return const Text('Unknown Page');
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
          leading: SizedBox(
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
