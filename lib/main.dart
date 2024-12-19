import 'package:flutter/material.dart';
import 'screens/contacts_screen.dart';
import 'screens/meetings_screen.dart';
import 'screens/notes_screen.dart';
import 'screens/tasks_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    });
  }

  List<Map<String, dynamic>> buttonList = [
    {'text': 'Meetings', 'screen': MeetingsScreen()},
    {'text': 'Contacts', 'screen': ContactsScreen()},
    {'text': 'Notes', 'screen': NotesScreen()},
    {'text': 'Tasks', 'screen': TasksScreen()},
  ];

  void _addNewButton(String buttonName) {
    setState(() {
      buttonList.add({
        'text': buttonName,
        'screen': NewButtonScreen(buttonName: buttonName),
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Личные Заметки',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      themeMode: _themeMode,
      debugShowCheckedModeBanner: false,
      home: HomeScreen(
        toggleTheme: _toggleTheme,
        buttonList: buttonList,
        addNewButton: _addNewButton,
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final VoidCallback toggleTheme;
  final List<Map<String, dynamic>> buttonList;
  final Function(String) addNewButton;

  HomeScreen({
    required this.toggleTheme,
    required this.buttonList,
    required this.addNewButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Заметки'),
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: toggleTheme,
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _showAddButtonDialog(context);
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: buttonList.map((button) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Theme.of(context).brightness == Brightness.dark
                        ? Colors.deepPurple[800]
                        : Theme.of(context).primaryColor,
                    minimumSize: Size(200, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => button['screen']),
                    );
                  },
                  child: Text(
                    button['text'],
                    style: TextStyle(fontSize: 18),
                  ),
                 ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  void _showAddButtonDialog(BuildContext context) {
    String newButtonName = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Button'),
          content: TextField(
            onChanged: (value) {
              newButtonName = value;
            },
            decoration: InputDecoration(hintText: "Enter button name"),
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
                if (newButtonName.isNotEmpty) {
                  addNewButton(newButtonName);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}

class NewButtonScreen extends StatefulWidget {
  final String buttonName;

  NewButtonScreen({required this.buttonName});

  @override
  _NewButtonScreenState createState() => _NewButtonScreenState();
}

class _NewButtonScreenState extends State<NewButtonScreen> {
  List<String> items = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.buttonName),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _showAddItemDialog(context);
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(items[index]),
          );
        },
      ),
    );
  }

  void _showAddItemDialog(BuildContext context) {
    String newItemName = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Item'),
          content: TextField(
            onChanged: (value) {
              newItemName = value;
            },
            decoration: InputDecoration(hintText: "Enter item name"),
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
                if (newItemName.isNotEmpty) {
                  setState(() {
                    items.add(newItemName);
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}