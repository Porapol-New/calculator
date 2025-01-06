// ignore_for_file: file_names

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select a Calculation'),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(color: Colors.black),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 3 / 4,
          ),
          itemCount: menuItems.length,
          itemBuilder: (context, index) {
            return MenuCard(menuItem: menuItems[index]);
          },
        ),
      ),
    );
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

List<MenuItem> menuItems = [
  MenuItem(
    title: 'Circle Area',
    icon: Icons.circle_outlined,
    route: CircleAreaScreen(),
  ),
  MenuItem(
    title: 'Rectangle Area',
    icon: Icons.square_outlined,
    route: RectangleAreaScreen(),
  ),
  MenuItem(
    title: 'Take a Picture',
    icon: Icons.camera_alt_outlined,
    route: PictureAnalysisScreen(),
  ),
];

class CircleAreaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Circle Area Calculation'),
      ),
      body: Center(
        child: Text('Circle Area Calculation Screen'),
      ),
    );
  }
}

class RectangleAreaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rectangle Area Calculation'),
      ),
      body: Center(
        child: Text('Rectangle Area Calculation Screen'),
      ),
    );
  }
}

class PictureAnalysisScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Picture Analysis'),
      ),
      body: Center(
        child: Text('Picture Analysis Screen'),
      ),
    );
  }
}
