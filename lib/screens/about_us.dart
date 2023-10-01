
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
                'assets/images/cresta_de_gallo.jpg',
              ),
              SizedBox(height: 10),
              Text("Description:"),
              SizedBox(height: 10),
              Text("Cresta De Gallo Island emerges from the crystal clear waters of Romblon like a gem awaiting discovery. A picture of seclusion and untouched beauty, this crescent-shaped paradise is every traveler’s dream of an idyllic escape. Cresta De Gallo is famous for its pristine beaches, vibrant marine life, and the gentle lull of its waves. In this itinerary and travel guide, we’ll navigate through the must-see spots, local tips, and the best ways to get there. So, pack your bags, and let’s set sail to this lesser-known treasure of the Philippines!"),
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
              title: 'Trees',
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
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Home()));
              case 1:
                Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => Trees()));
              case 2:
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
    );
  }
}

