import 'dart:io';

import 'package:flutter/material.dart';
import 'package:grovievision/models/image_data.dart';
import 'package:image_picker/image_picker.dart';
import 'package:carousel_slider/carousel_slider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
  String searchQuery = '';
  int _selectedIndex = 0;
  int _selectedIdx = 0;
  final CarouselController _carouselController = CarouselController();

      // Define a list of ImageData objects
    List<ImageData> imageDataList = [
      ImageData(
        imagePath: "assets/images/coconut.jpeg",
        name: "Image 1",
        description: "This is the first image.",
      ),
      ImageData(
        imagePath: "assets/images/narra.jpeg",
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grovievision'),
        backgroundColor: Colors.green, // Set the background color here
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0), // Adjust the margin as needed
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          SizedBox(height: 20),
          // Half of the screen with a green gradient
          CarouselSlider(
            options: CarouselOptions(
              height: MediaQuery.of(context).size.height * 0.2, // Adjust the height as needed
              enlargeCenterPage: true,
              autoPlay: true, // Set to true if you want the carousel to auto-play
              autoPlayInterval: Duration(seconds: 3), // Auto-play interval
              autoPlayAnimationDuration: Duration(milliseconds: 800), // Animation duration
              autoPlayCurve: Curves.fastOutSlowIn, // Animation curve
              scrollDirection: Axis.horizontal, // Set to Axis.horizontal for a horizontal carousel
            ),
            items: [
              // Add your carousel items here
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.green.shade300, Colors.green.shade700],
                  ),
                ),
                child: Center(
                  child: Text('Image 1'),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.blue.shade300, Colors.blue.shade700],
                  ),
                ),
                child: Center(
                  child: Text('Image 2'),
                ),
              ),
              // Add more carousel items as needed
            ],
          ),
          // The rest of your content goes here
          Expanded(
            child: Center(
              child: _getSelectedWidget(),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _buildDrawerItem(
              title: 'Home',
              index: 0,
            ),
            _buildDrawerItem(
              title: 'Mangrooves',
              index: 1,
            ),
            _buildDrawerItem(
              title: 'About Us',
              index: 2,
            ),
            _buildDrawerItem(
              title: 'Exit',
              index: 3,
            ),
          ],
        ),
      ),
      floatingActionButton: MyFAB(),
    );
  }

Widget _getSelectedWidget() {
  switch (_selectedIndex) {
    case 0:
      // Filter the imageDataList based on the searchQuery
      final filteredDataList = imageDataList
          .where((data) =>
              data.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
              data.description.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();

      return ListView.separated(
        itemCount: filteredDataList.length,
        separatorBuilder: (BuildContext context, int index) =>
            const Divider(),
        itemBuilder: (BuildContext context, int index) {
          final imageData = filteredDataList[index];
          return ListTile(
            leading: Image.asset(imageData.imagePath),
            title: Text(imageData.name),
            subtitle: Text(imageData.description),
          );
        },
      );
    case 1:
      return Mangroove();
    case 2:
      return AboutUs();
    default:
      return Text('Unknown Page');
  }
}

  ListTile _buildDrawerItem({required String title, required int index}) {
    return ListTile(
      title: Text(title),
      selected: _selectedIndex == index,
      onTap: () {
        _onItemTapped(index);
        Navigator.pop(context); // Close the drawer
      },
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

  /// Get from gallery
  Future _getFromGallery() async {
    final pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        localImage = File(pickedFile.path);
      });
    }
  }

  /// Get Image from Camera
  Future getImageFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

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
                    ElevatedButton(
                      onPressed: _getFromGallery,
                      child: Text('Take Local Image'),
                    ),
                    SizedBox(height: 20),
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

class Mangroove extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('Mangroove Page'); // Replace with your Mangroove content
  }
}

class AboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('About Us Page'); // Replace with your About Us content
  }
}
