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

class AboutUsState extends State<AboutUs> {
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
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Tree Tracer'),
            flexibleSpace: Container(
              decoration: BoxDecoration(
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
          ),
          body: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Column(
                children: <Widget>[
                  // Image.asset(
                  //   'assets/images/cresta_de_gallo.jpg',
                  // ),
                  // SizedBox(height: 10),
                  Text("Summary",
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.w600)),

                  SizedBox(height: 10),
                  Text(
                      textAlign: TextAlign.justify,
                      "      Tree Tracer application is a software tool that tells people about the general location of the different species of trees in Sibuyan Island. This app is designed to help people learn about the trees around them, whether they are in a city park, a suburban neighbourhood, or a rural forest. This app is useful for tourists, the local people and the DENR in Sibuyan Island. "),
                  SizedBox(height: 10),
                  Text(
                      textAlign: TextAlign.justify,
                      "      While the most important feature of the app is its ability to tell users about the general location of trees in the Island of Sibuyan, the app also provides information about the species of the tree, including its common name, scientific name, and other relevant details such as its uses, and benefits. In addition to that, the application also offers trivia questions or random information about the trees and where it is located in the Island of Sibuyan making it a fun and interactive between the system and the user."),
                  SizedBox(height: 10),
                  Text(
                      textAlign: TextAlign.justify,
                      "      Overall, the Tree Tracer application is a valuable tool in learning about trees in Sibuyan Island. It provides a fun and interactive way to explore the environment and can help users deepen their knowledge and appreciation of Sibuyan Island."),
                  SizedBox(height: 10),
                  Text(textAlign: TextAlign.justify, ""),
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
          )),
          endDrawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  title: 'Home',
                  index: 0,
                  onTap: () {
                    _drawerItemTapped(0);
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Home()));
                  },
                ),
                _buildDrawerItem(
                  title: 'Favorite',
                  index: 1,
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FavoritePage()));
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
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserTreeList(
                                  searchKey: 'TREE',
                                  userType: 'User',
                                )));
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
            selectedItemColor: Color.fromARGB(255, 0, 4, 255),
            onTap: (int index) {
              switch (index) {
                case 0:
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) => Home()));
                case 1:
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserTreeList(
                                searchKey: 'TREE',
                                userType: 'User',
                              )));
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
        onWillPop: () async {
          return _onBackPressed(context);
        });
  }
}
