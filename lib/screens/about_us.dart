
import 'package:flutter/material.dart';
import 'package:tree_tracer/screens/favorite.dart';
import 'package:tree_tracer/screens/home.dart';
import 'package:tree_tracer/screens/trees.dart';
import 'package:tree_tracer/screens/user_tree_list.dart';
import 'package:tree_tracer/ui_components/main_view.dart';

class AboutUs extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => AboutUsState();

}

class AboutUsState extends State<AboutUs>{
  int _selectedIndex = 0;

  _drawerItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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

  Future<bool> _onBackPressed(BuildContext context) async {
    final confirmed = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Exit the app?'),
          content: Text('Are you sure you want to exit the app?'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    return confirmed ?? false; // Return false if the dialog is dismissed
  }
    
  @override
  Widget build(BuildContext context) {
    
    return WillPopScope(
      child:  Scaffold(
        appBar: AppBar(
          title: const Text('Tree Tracer'),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color.fromARGB(255, 24, 122, 0), Color.fromARGB(255, 82, 209, 90)],
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Column(
                children:<Widget>[
                  // Image.asset(
                  //   'assets/images/cresta_de_gallo.jpg',
                  // ),
                  // SizedBox(height: 10),
                  Text("Summary",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600
                    )
                  ),

                  SizedBox(height: 10),
                  Text(
                    textAlign: TextAlign.justify,
                    "      Tree identifier applications are software tools that utilize computer vision and machine learning algorithms to identify different species of trees based on their physical characteristics, such as leaf shape, bark texture, and overall appearance. These apps are designed to help people learn about the trees around them, whether they are in a city park, a suburban neighborhood, or a rural forest."),
                  SizedBox(height: 10),
                  Text(
                    textAlign: TextAlign.justify,
                    "      The need for tree identification apps has arisen due to the growing interest in environmental conservation, as well as the popularity of outdoor activities like hiking, birdwatching, and nature photography. By using a tree tracer app, users can quickly and accurately identify the trees they encounter in their travels and learn more about the ecological role and cultural significance of each species."),
                  SizedBox(height: 10),
                  Text(
                    textAlign: TextAlign.justify,
                    "      Tree Tracer apps work by using the camera on a user's smartphone or tablet to take a photo of a tree, which is then analyzed by the app's algorithms to determine its species. One of the main benefits of the tree tracer application is that it allows users to quickly and easily identify trees without having to be an expert in botany. Users can simply take a photo of the tree, and the app will provide information about the species, including its common name, scientific name, and other relevant details."),
                  SizedBox(height: 10),
                  Text(
                    textAlign: TextAlign.justify,
                    "      Overall, the tree tracer application is a valuable tool for anyone interested in learning about trees and the natural world. They provide a fun and interactive way to explore the environment and can help users deepen their knowledge and appreciation of the natural world."),
                  SizedBox(height: 10),
                  Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          Text(
                            "Developers",
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w600,
                                color: Color.fromARGB(199, 99, 177, 9)),
                          ),
                          SizedBox(height: 20),
                          Padding(
                                padding: const EdgeInsets.only(right: 20, left: 20),
                                child: Image.asset(
                                  'assets/images/carl.jpg',
                                  width: 100,
                                  height: 100,
                                ),
                              ),
                              Text("Carl Michael Orellana"),
                          SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.only(right: 20, left: 20),
                            child: Image.asset(
                              'assets/images/glenn.jpg',
                              width: 100,
                              height: 100,
                            ),
                          ),
                          Text("Glenn Vincent Maestro"),
                          SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.only(right: 20, left: 20),
                            child: Image.asset(
                              'assets/images/joshua.jpg',
                              width: 100,
                              height: 100,
                            ),
                          ),
                          Text("Jushua Fruelda"),
                          SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.only(right: 20, left: 20),
                            child: Image.asset(
                              'assets/images/clarence.jpg',
                              width: 100,
                              height: 100,
                            ),
                          ),
                          Text("Clarence Jade Maduro Moaje "),
                          SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.only(right: 20, left: 20),
                            child: Image.asset(
                              'assets/images/lawrenz.jpg',
                              width: 100,
                              height: 100,
                            ),
                          ),
                          Text("Lawrenz Manipol")
                        ],
                      ),
                    )
                ],
              ),
            ),
          )
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
                  MaterialPageRoute(builder: (context) => FavoritePage()));
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
            currentIndex: 2,
            selectedItemColor: Colors.amber[800],
            onTap: (int index) {
              switch (index) {
                case 0:
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) => Home()));
                case 1:
                  Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => UserTreeList(searchKey: 'TREE', userType: 'User',)));
                case 2:
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
      onWillPop: () async { return _onBackPressed(context); }
    );
    
    
    }
}

