// ignore_for_file: use_key_in_widget_constructors

import 'package:calculator/Circle.dart';
import 'package:calculator/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: _themeMode,
      home: HomeScreen(
        onThemeChanged: (bool isDarkMode) {
          setState(() {
            _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
          });
        },
      ),
      onGenerateRoute: (RouteSettings settings) {
        final routeName = settings.name;

        if (routeName == '/Circlearea') {
          return MaterialPageRoute(builder: (context) => Circlearea());
        } else if (routeName == '/squareRoute') {
          return MaterialPageRoute(builder: (context) => SquareScreen());
        } else if (routeName == '/triangleRoute') {
          return MaterialPageRoute(builder: (context) => TriangleScreen());
        } else {
          return MaterialPageRoute(
            builder: (context) => NotFoundScreen(), // หน้าสำหรับ route ที่ไม่พบ
          );
        }
      },
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
            TextField(
              decoration: InputDecoration(
                hintText: 'Search calculations...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
            SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('menuItems')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No calculations found'));
                  }

                  final filteredDocs = snapshot.data!.docs.where((doc) {
                    final title = doc['title'].toString().toLowerCase();
                    return title.contains(searchQuery.toLowerCase());
                  }).toList();

                  if (filteredDocs.isEmpty) {
                    return Center(
                        child: Text('No matching calculations found'));
                  }

                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: filteredDocs.length,
                    itemBuilder: (context, index) {
                      final doc = filteredDocs[index];
                      return MenuCard(
                        title: doc['title'],
                        iconName: doc['icon'],
                        routeName: doc['route'],
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
}

class MenuCard extends StatelessWidget {
  final String title;
  final String iconName;
  final String routeName;

  const MenuCard({
    required this.title,
    required this.iconName,
    required this.routeName,
  });

  @override
  Widget build(BuildContext context) {
    IconData icon = _getIconFromName(iconName);

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, routeName);
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50),
            SizedBox(height: 10),
            Text(title),
          ],
        ),
      ),
    );
  }

  IconData _getIconFromName(String iconName) {
    Map<String, IconData> iconMap = {
      'circle_outlined': Icons.circle_outlined,
      'square_outlined': Icons.square_outlined,
      'triangle_outlined': Icons.change_history,
    };

    return iconMap[iconName] ?? Icons.help_outline;
  }
}

class SquareScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Square Calculation'),
      ),
      body: Center(
        child: Text(
          'This is the Square Calculation screen',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class TriangleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Triangle Calculation'),
      ),
      body: Center(
        child: Text(
          'This is the Triangle Calculation screen',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class NotFoundScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Not Found'),
      ),
      body: Center(
        child: Text(
          'Page not found',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
