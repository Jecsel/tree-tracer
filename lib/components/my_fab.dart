

import 'package:flutter/material.dart';

class MyFAB extends StatelessWidget {
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
              title: Text('Add Item'),
              content: TextField(
                // Add your text input field for item here.
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
      child: Icon(Icons.add),
    );
  }
}

class MyListView extends StatefulWidget {
  @override
  _MyListViewState createState() => _MyListViewState();
}

class _MyListViewState extends State<MyListView> {
  List<String> items = ['Item 1', 'Item 2', 'Item 3'];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(items[index]),
         onTap: () {
            // Add your action when an item is tapped.
            // Show a Snackbar using ScaffoldMessenger.
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('You tapped item ${index + 1}'),
              ),
            );
          }
        );
      },
    );
  }
}