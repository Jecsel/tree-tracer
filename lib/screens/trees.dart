import 'package:flutter/material.dart';
import 'package:tree_tracer/components/show_tree.dart';
import 'package:tree_tracer/screens/about_us.dart';
import 'package:tree_tracer/screens/home.dart';

class Trees extends StatefulWidget {
  const Trees({super.key});

  @override
  State<StatefulWidget> createState() => _TreesPageState();
}

class DropdownItem {
  final String label;
  final String imagePath;
  final String description;

  DropdownItem({
    required this.label,
    required this.imagePath,
    required this.description,
  });
}

class _TreesPageState extends State<Trees> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyDropdownDemo(),
    );
  }
}

class MyDropdownDemo extends StatefulWidget {
  @override
  _MyDropdownDemoState createState() => _MyDropdownDemoState();
}

class _MyDropdownDemoState extends State<MyDropdownDemo> {
  DropdownItem? selectedDropdownItem;

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

  List<DropdownItem> dropdownItems = [
    DropdownItem(
      label: 'Item 1',
      imagePath: "assets/images/balobo.jpeg",
      description: 'Description for Item 1',
    ),
    DropdownItem(
      label: 'Item 2',
      imagePath: "assets/images/balobo.jpeg",
      description: 'Description for Item 2',
    ),
    // Add more items as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tree Tracer'),
        backgroundColor: Colors.green, // Set the background color here
      ),
      body: Column(
        children: <Widget>[
          // Place the DropdownButton at the top and make it fit the width
          Container(
            width: double.infinity, // Expand to fit the width
            padding: EdgeInsets.all(16),
            child: DropdownButton<DropdownItem>(
              hint: Text('Tree'),
              value: selectedDropdownItem,
              onChanged: (DropdownItem? newValue) {
                setState(() {
                  // selectedDropdownItem = newValue;
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => ShowTree()));
                });
              },
              items: dropdownItems.map((DropdownItem item) {
                return DropdownMenuItem<DropdownItem>(
                  value: item,
                  child: Row(
                    children: <Widget>[
                      Image.asset(
                        item.imagePath,
                        width: 30,
                        height: 30,
                      ),
                      SizedBox(width: 10),
                      Text(item.label),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          Container(
            width: double.infinity, // Expand to fit the width
            padding: EdgeInsets.all(16),
            child: DropdownButton<DropdownItem>(
              hint: Text('Flower'),
              value: selectedDropdownItem,
              onChanged: (DropdownItem? newValue) {
                setState(() {
                  selectedDropdownItem = newValue;
                });
              },
              items: dropdownItems.map((DropdownItem item) {
                return DropdownMenuItem<DropdownItem>(
                  value: item,
                  child: Row(
                    children: <Widget>[
                      Image.asset(
                        item.imagePath,
                        width: 30,
                        height: 30,
                      ),
                      SizedBox(width: 10),
                      Text(item.label),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          Container(
            width: double.infinity, // Expand to fit the width
            padding: EdgeInsets.all(16),
            child: DropdownButton<DropdownItem>(
              hint: Text('Trunk'),
              value: selectedDropdownItem,
              onChanged: (DropdownItem? newValue) {
                setState(() {
                  selectedDropdownItem = newValue;
                });
              },
              items: dropdownItems.map((DropdownItem item) {
                return DropdownMenuItem<DropdownItem>(
                  value: item,
                  child: Row(
                    children: <Widget>[
                      Image.asset(
                        item.imagePath,
                        width: 30,
                        height: 30,
                      ),
                      SizedBox(width: 10),
                      Text(item.label),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          Container(
            width: double.infinity, // Expand to fit the width
            padding: EdgeInsets.all(16),
            child: DropdownButton<DropdownItem>(
              hint: Text('Leaf'),
              value: selectedDropdownItem,
              onChanged: (DropdownItem? newValue) {
                setState(() {
                  selectedDropdownItem = newValue;
                });
              },
              items: dropdownItems.map((DropdownItem item) {
                return DropdownMenuItem<DropdownItem>(
                  value: item,
                  child: Row(
                    children: <Widget>[
                      Image.asset(
                        item.imagePath,
                        width: 30,
                        height: 30,
                      ),
                      SizedBox(width: 10),
                      Text(item.label),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          Container(
            width: double.infinity, // Expand to fit the width
            padding: EdgeInsets.all(16),
            child: DropdownButton<DropdownItem>(
              hint: Text('Fruit'),
              value: selectedDropdownItem,
              onChanged: (DropdownItem? newValue) {
                setState(() {
                  selectedDropdownItem = newValue;
                });
              },
              items: dropdownItems.map((DropdownItem item) {
                return DropdownMenuItem<DropdownItem>(
                  value: item,
                  child: Row(
                    children: <Widget>[
                      Image.asset(
                        item.imagePath,
                        width: 30,
                        height: 30,
                      ),
                      SizedBox(width: 10),
                      Text(item.label),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          if (selectedDropdownItem != null)
            Column(
              children: <Widget>[
                SizedBox(height: 20),
                Image.asset(
                  selectedDropdownItem!.imagePath,
                  width: 100,
                  height: 100,
                ),
                SizedBox(height: 10),
                Text(selectedDropdownItem!.description),
              ],
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
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Trees()));
              },
            ),
            _buildDrawerItem(
              title: 'About Us',
              index: 2,
              onTap: () {
                _drawerItemTapped(2);
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
        selectedItemColor: const Color.fromARGB(255, 0, 4, 255),
        onTap: (int index) {
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Home()));
            case 1:
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Trees()));
            case 2:
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => AboutUs()));
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
