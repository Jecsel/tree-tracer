
import 'package:flutter/material.dart';
import 'package:tree_tracer/screens/home.dart';
import 'package:tree_tracer/screens/trees.dart';

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
    
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tree Tracer'),
        backgroundColor: Colors.green, // Set the background color here
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            children:<Widget>[
              Image.asset(
                'assets/images/banner.png',
              ),
              SizedBox(height: 10),
              Text("Description:"),
              SizedBox(height: 10),
              Text("Mangroves play a crucial role in coastal ecosystems, providing habitat, protecting shorelines, and sequestering carbon. Accurate identification of mangrove species is essential for monitoring their health and understanding their ecological contributions. 'Grovievision' is a novel standalone application developed to streamline and enhance the process of mangrove species identification."),
              SizedBox(height: 10),
              Text("This thesis explores the development and implementation of Grovievision, a user-friendly application designed to facilitate the identification of mangrove species through image recognition technology. The application harnesses the power of machine learning and computer vision algorithms to enable quick and accurate identification of mangrove species from photographs, making it an invaluable tool for researchers, conservationists, and field practitioners.")
            ],
          ),
        ),
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
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Home()));
              },
            ),
            _buildDrawerItem(
              title: 'Mangrooves',
              index: 1,
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Trees()));
              },
            ),
            _buildDrawerItem(
              title: 'About Us',
              index: 2,
              onTap: () {
                _drawerItemTapped(2);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> AboutUs()));
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
    );
  }
}

