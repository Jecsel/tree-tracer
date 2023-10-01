
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tree_tracer/screens/about_us.dart';
import 'package:tree_tracer/screens/home.dart';
import 'package:tree_tracer/screens/trees.dart';

class ShowTree extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _ShowTreeState();

}

class _ShowTreeState  extends State<ShowTree> {
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
                'assets/images/coconut.jpeg',
              ),
              SizedBox(height: 10),
              Text("Description:"),
              SizedBox(height: 10),
              Text("A coconut is an iconic drupe with a distinctive appearance. It typically features a round or oval shape, a tough, brown, fibrous husk, and a smooth, glossy, brown or green shell. The inner fruit, or 'endosperm,' is the edible part of the coconut and has a white, luscious flesh with a mildly sweet flavor.")
            ],
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

