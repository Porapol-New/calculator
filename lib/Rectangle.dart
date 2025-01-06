import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minimalist Rectangle Calculator',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.black87),
        ),
      ),
      home: Rectangle(),
    );
  }
}

class Rectangle extends StatefulWidget {
  @override
  _RectangleState createState() =>
      _RectangleState();
}

class _RectangleState extends State<Rectangle> {
  final TextEditingController _widthController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

  double _rectangleArea = 0.0;

  void _calculateRectangleArea() {
    final width = double.tryParse(_widthController.text);
    final height = double.tryParse(_heightController.text);
    if (width != null && height != null) {
      setState(() {
        _rectangleArea = width * height;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minimalist Rectangle Calculator'),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(color: Colors.black),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDescriptionText(
                      'สูตรคำนวณพื้นที่สี่เหลี่ยม: พื้นที่ = ความกว้าง x ความสูง\n'
                      'กรุณากรอกความกว้างและความสูงเพื่อคำนวณพื้นที่สี่เหลี่ยม',
                    ),
                    SizedBox(height: 10),
                    _buildTextField(
                      controller: _widthController,
                      label: 'Width of Rectangle',
                      icon: Icons.square_outlined,
                    ),
                    SizedBox(height: 10),
                    _buildTextField(
                      controller: _heightController,
                      label: 'Height of Rectangle',
                      icon: Icons.height_outlined,
                    ),
                    SizedBox(height: 8),
                    _buildCalculateButton(
                      label: 'Calculate Rectangle Area',
                      onPressed: _calculateRectangleArea,
                    ),
                    SizedBox(height: 8),
                    _buildResultText('Rectangle Area: $_rectangleArea'),
                  ],
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Card(
      color: Colors.grey[100],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: child,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildCalculateButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  Widget _buildResultText(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildDescriptionText(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        color: Colors.grey[800],
      ),
    );
  }
}
