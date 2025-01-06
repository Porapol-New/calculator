// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator Menu',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.black87),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.white70),
        ),
      ),
      themeMode: _themeMode,
      home: HomeScreen(
        onThemeChanged: (bool isDarkMode) {
          setState(() {
            _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
          });
        },
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final ValueChanged<bool> onThemeChanged;

  const HomeScreen({required this.onThemeChanged});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Select a Calculation'),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(color: Colors.black),
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.wb_sunny : Icons.nightlight_round),
            onPressed: () {
              widget.onThemeChanged(!isDarkMode);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // ช่องค้นหา
            TextField(
              decoration: InputDecoration(
                hintText: 'Search calculations...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
            SizedBox(height: 20),
            // แสดงเมนูที่ดึงจาก Firestore
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('menuItems')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        'No calculations found',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    );
                  }

                  // ดึงข้อมูลและกรองตาม searchQuery
                  final filteredDocs = snapshot.data!.docs.where((doc) {
                    final title = doc['title'].toString().toLowerCase();
                    return title.contains(searchQuery.toLowerCase());
                  }).toList();

                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 20.0,
                      mainAxisSpacing: 20.0,
                      childAspectRatio: 3 / 4,
                    ),
                    itemCount: filteredDocs.length,
                    itemBuilder: (context, index) {
                      final doc = filteredDocs[index];
                      return MenuCard(
                        menuItem: MenuItem(
                          title: doc['title'],
                          icon: _getIconFromString(doc['icon']),
                          route: _getScreenFromRoute(doc['route']),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconFromString(String iconName) {
    switch (iconName) {
      case 'circle_outlined':
        return Icons.circle_outlined;
      case 'square_outlined':
        return Icons.square_outlined;
      case 'square_rounded':
        return Icons.square_rounded;
      default:
        return Icons.help_outline;
    }
  }

  Widget _getScreenFromRoute(String routeName) {
    switch (routeName) {
      case 'CircleScreen':
        return CalculatorScreen();
      case 'RectangleScreen':
        return RectangleCalculatorScreen();
      case 'CubeScreen':
        return CubeVolumeScreen();
      default:
        return Scaffold(
          appBar: AppBar(title: Text('Unknown Screen')),
          body: Center(child: Text('Screen not found')),
        );
    }
  }
}

class MenuCard extends StatelessWidget {
  final MenuItem menuItem;

  const MenuCard({required this.menuItem});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => menuItem.route),
        );
      },
      child: Card(
        color: Colors.grey[100],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(menuItem.icon, size: 60, color: Colors.grey[800]),
              SizedBox(height: 20),
              Text(
                menuItem.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MenuItem {
  final String title;
  final IconData icon;
  final Widget route;

  MenuItem({required this.title, required this.icon, required this.route});
}

class CalculatorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Circle Area Calculator')),
      body: Center(child: Text('Calculator Screen')),
    );
  }
}

class RectangleCalculatorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Rectangle Area Calculator')),
      body: Center(child: Text('Rectangle Screen')),
    );
  }
}

class CubeVolumeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cube Volume Calculator')),
      body: Center(child: Text('Cube Screen')),
    );
  }
}
