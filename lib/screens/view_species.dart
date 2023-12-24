import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tree_tracer/models/favourite_model.dart';
import 'package:tree_tracer/models/flower_model.dart';
import 'package:tree_tracer/models/fruit_model.dart';
import 'package:tree_tracer/models/leaf_model.dart';
import 'package:tree_tracer/models/root_model.dart';
import 'package:tree_tracer/models/tracer_model.dart';
import 'package:tree_tracer/screens/admin.dart';
import 'package:tree_tracer/screens/extend_info.dart';
import 'package:tree_tracer/screens/update_species.dart';
import 'package:tree_tracer/screens/user_tree_list.dart';
import 'package:tree_tracer/services/database_helper.dart';
import 'package:tree_tracer/widgets/read_more_text.dart';

class ViewSpecies extends StatefulWidget {
  final int tracerId;
  final String category; // What category of TREE, ROOT, ETC.
  final String userType; //What type of User

  ViewSpecies(
      {required this.tracerId,
      required this.category,
      required this.userType}); // Constructor that accepts data

  @override
  State<StatefulWidget> createState() => _ViewSpeciesState();
}

class _ViewSpeciesState extends State<ViewSpecies> {
  int _selectedIndex = 0;
  TracerDatabaseHelper dbHelper = TracerDatabaseHelper.instance;
  TracerModel? tracerData;
  RootModel? rootData;
  FlowerModel? flowerData;
  FruitModel? fruitData;
  LeafModel? leafData;
  List<File> tempTracerFileImageArray = [];

  @override
  void initState() {
    super.initState();
    dbHelper = TracerDatabaseHelper.instance;
    fetchData();
  }

  Future<void> fetchData() async {
    int tracerId = widget.tracerId;
    TracerModel? mangroveResultData = await dbHelper.getOneTracerData(tracerId);
    RootModel? rootResultData = await dbHelper.getOneRootData(tracerId);
    FlowerModel? flowerResultData = await dbHelper.getOneFlowerData(tracerId);
    LeafModel? leafResultData = await dbHelper.getOneLeafData(tracerId);
    FruitModel? fruitResultData = await dbHelper.getOneFruitData(tracerId);

    List<FavouriteModel>? tracerFavs =
        await dbHelper.getFavouriteDataList(tracerId);

    for (var imgPaths in tracerFavs) {
      tempTracerFileImageArray.add(File(imgPaths.imagePath));
    }

    setState(() {
      tracerData = mangroveResultData;
      rootData = rootResultData;
      fruitData = fruitResultData;
      leafData = leafResultData;
      flowerData = flowerResultData;
      tempTracerFileImageArray = tempTracerFileImageArray;

      print("========== tempTracerFileImageArray ===========");
      print(tempTracerFileImageArray);
    });
  }

  Future<void> deleteTracer() async {
    int tracerId = widget.tracerId;
    await dbHelper.deleteFlowerData(tracerId);
    await dbHelper.deleteFruitData(tracerId);
    await dbHelper.deleteLeafData(tracerId);
    await dbHelper.deleteRootData(tracerId);
    await dbHelper.deleteTracerData(tracerId);
  }

  Future<void> addToFavourite() async {
    tracerData?.favourite = tracerData!.favourite == 0 ? 1 : 0;

    var msg = tracerData!.favourite == 1
        ? "Added to Favourite!"
        : "Removed to Favourite!";

    final snackBar = SnackBar(content: Text(msg));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    await dbHelper.updateFavouriteStatus(
        tracerData!.id ?? 1, tracerData?.favourite ?? 1);

    setState(() {
      tracerData!.favourite = tracerData!.favourite;
    });
  }

  _drawerItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  _gotoSearchList() {
    String userType = widget.userType;
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                AdminPage(searchKey: 'TREE', userType: userType)));
  }

  _gotoUpdateSpecies() {
    int tracerId = widget.tracerId;
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => UpdateSpecies(tracerId: tracerId)));
  }

  _gotoExtendedInfo() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ExtendInfo(tracerId: widget.tracerId, category: widget.category, userType: widget.userType)));
  }

  Future<Widget> loadImageFromFile(String filePath) async {
    if (filePath.startsWith('assets/')) {
      // If the path starts with 'assets/', load from assets
      return SizedBox(
        width: 300,
        height: 250,
        child: Image.asset(
          filePath,
          fit: BoxFit.cover,
        ),
      );
    } else {
      final file = File(filePath);

      if (await file.exists()) {
        // If the file exists in local storage, load it
        return SizedBox(
          width: 300,
          height: 250,
          child: Image.file(
            file,
            fit: BoxFit.cover,
          ),
        );
      }
    }

    // If no valid image is found, return a default placeholder
    return SizedBox(
      width: 300,
      height: 250,
      child: Image.asset(
        "assets/images/default_placeholder.png",
        fit: BoxFit.cover,
      ),
    ); // You can replace this with your placeholder image
  }

  Future<void> _gotoSimilarTrees() async {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                UserTreeList(searchKey: 'TREE', userType: 'User')));
  }

  Future<Widget> loadImage(String filePath) async {
    if (filePath.startsWith('assets/')) {
      // If the path starts with 'assets/', load from assets
      return Image.asset(filePath, width: 150, height: 150);
    } else {
      final file = File(filePath);

      if (await file.exists()) {
        // If the file exists in local storage, load it
        return Image.file(file, width: 150, height: 150);
      }
    }

    // If no valid image is found, return a default placeholder
    return Image.asset("assets/images/default_placeholder.png",
        width: 150,
        height: 150); // You can replace this with your placeholder image
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

  Future<void> removeImageInArray(int index) async {
    setState(() {
      tempTracerFileImageArray.removeAt(index);

      print('tempTracerFileImageArray');
      print(tempTracerFileImageArray);
    });
  }

  @override
  Widget build(BuildContext context) {
    var userType = widget.userType;
    var searchKey = widget.category;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tree Info'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 24, 122, 0),
                Color.fromARGB(255, 82, 209, 90)
              ],
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // Add your arrow icon here
          onPressed: () {
            if (userType == 'Admin') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                  AdminPage(userType: userType, searchKey: searchKey)));
            } else {
              Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => UserTreeList(searchKey: 'TREE', userType: 'user' )));
            }
          },
        ),
        actions: <Widget>[
          Visibility(
            visible: userType == 'Admin',
            child: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                _gotoUpdateSpecies();
              },
            ),
          ),
          Visibility(
            visible: userType == 'Admin',
            child: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                deleteTracer();
                _gotoSearchList();
                final snackBar = const SnackBar(
                  content: Text('Tracer Delete!'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
            ),
          ),
          Visibility(
            visible: userType != 'Admin' && tracerData != null,
            child: IconButton(
              icon: tracerData?.favourite == 1
                  ? const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    )
                  : const Icon(Icons.favorite_border),
              onPressed: () {
                addToFavourite();
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 250.0,
                  child: tempTracerFileImageArray.length > 0
                      ? ListView.builder(
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
                                      if (snapshot.connectionState ==
                                          ConnectionState.done) {
                                        return snapshot.data ??
                                            const CircularProgressIndicator();
                                      } else {
                                        return const CircularProgressIndicator(); // Or another loading indicator
                                      }
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                      : Image.asset(
                          'assets/images/default_placeholder.png',
                          height: 300,
                          width: 300,
                        ),
                ),
                const SizedBox(height: 10),
                Text(
                  tracerData?.local_name ?? 'No Local Name',
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 25),
                ),
                const SizedBox(height: 10),
                Text(
                  'Scientific Name: ${tracerData?.scientific_name}' ??
                      'No Scientific Name',
                  style: const TextStyle(
                      color: Colors.grey, fontStyle: FontStyle.italic),
                ),
                Text(
                  'Family: ${tracerData?.family}' ?? 'No Family',
                  style: const TextStyle(
                      color: Colors.grey, fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 10),
                ReadMoreText(
                  longText: tracerData?.description ?? 'No Description',
                  maxLines: 2,
                ),

                // const SizedBox(height: 20),
                // Column(
                //   children: [
                //     Container(
                //       width: double.infinity,
                //       color: Colors.yellow,
                //       child: Align(
                //         alignment: Alignment.topLeft,
                //         child: Column(
                //           mainAxisAlignment: MainAxisAlignment.start,
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: [
                //             Text(
                //               tracerData?.benifits != '' ? 'Benifits' : '',
                //               style: const TextStyle(fontWeight: FontWeight.w600),
                //             ),
                //             Text(tracerData?.benifits ?? 'No Benifits'),
                //             Text(
                //               tracerData?.uses != '' ? 'Uses' : '',
                //               style: const TextStyle(fontWeight: FontWeight.w600),
                //             ),
                //             Text(tracerData?.uses ?? 'No Uses'),
                //           ],
                //         ),  
                //       ),
                //     ),
                //   ],
                // ),
                const SizedBox(
                  height: 50.0,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: Colors.green
                    ),
                    onPressed: () {
                      _gotoExtendedInfo();
                    }, 
                    child: const Text("Next", style: TextStyle(color: Colors.white)),
                  ),
              ],
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _buildDrawerItem(
              title: 'Home',
              index: 0,
              onTap: () {
                // Navigator.pushReplacement(
                //     context, MaterialPageRoute(builder: (context) => Home()));
              },
            ),
            _buildDrawerItem(
              title: 'Admin',
              index: 1,
              onTap: () {
                // Navigator.pushReplacement(context,
                // MaterialPageRoute(builder: (context) => Login()));
              },
            ),
            _buildDrawerItem(
              title: 'About Us',
              index: 1,
              onTap: () {
                // Navigator.pushReplacement(context,
                // MaterialPageRoute(builder: (context) => AboutUs()));
              },
            ),
            _buildDrawerItem(
              title: 'Exit',
              index: 2,
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
