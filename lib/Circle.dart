// ignore_for_file: file_names, use_key_in_widget_constructors

import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minimalist Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey, // ใช้สีฟ้าอ่อนและสีเทาสำหรับ Light Mode
        brightness: Brightness.light,
        scaffoldBackgroundColor: Color(0xFFF8F9FA), // พื้นหลังสีขาวนวล
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.black87),
        ),
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blueGrey, // ใช้โทนสีเทาฟ้าสำหรับ Dark Mode
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Color(0xFF121212), // พื้นหลังสีดำหม่น
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.white70),
        ),
      ),
      themeMode: ThemeMode.system, // ปรับตามการตั้งค่าระบบ
      home: Circlearea(),
    );
  }
}

class Circlearea extends StatefulWidget {
  @override
  _CircleareaState createState() => _CircleareaState();
}

class _CircleareaState extends State<Circlearea> {
  final TextEditingController _radiusController = TextEditingController();
  double _circleArea = 0.0;
  bool _isDarkMode = false;

  // ฟังก์ชันคำนวณพื้นที่วงกลม
  void _calculateCircleArea() {
    final radius = double.tryParse(_radiusController.text);
    if (radius != null) {
      setState(() {
        _circleArea = 3.1416 * radius * radius;
      });
    }
  }

  // ฟังก์ชันสำหรับเปลี่ยนธีมสี
  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  // ฟังก์ชันสำหรับแสดงคำอธิบายสูตรคำนวณ
  void _showFormulaExplanation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('คำอธิบายสูตรคำนวณ'),
        content: Text(
          'พื้นที่ของวงกลมสามารถคำนวณได้ด้วยสูตร: \n'
          'พื้นที่ = π x รัศมียกกำลังสอง\n\n'
          'π (Pi) คือค่าคงที่ทางคณิตศาสตร์ ซึ่งมีค่าประมาณ 3.1416. '
          'รัศมีคือระยะทางจากจุดศูนย์กลางของวงกลมถึงขอบนอก. '
          'ดังนั้นเมื่อเรานำรัศมีมาคูณกับตัวเอง (รัศมียกกำลังสอง) '
          'แล้วคูณด้วยค่า π เราก็จะได้ค่าพื้นที่ของวงกลม.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('ปิด'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minimalist Calculator'),
        backgroundColor: _isDarkMode
            ? Colors.black
            : Color(0xFFFAFAFA), // ใช้พื้นหลังที่สว่างและดูนวลตา
        elevation: 0,
        centerTitle: true,
        titleTextStyle:
            TextStyle(color: _isDarkMode ? Colors.white : Colors.black),
        iconTheme:
            IconThemeData(color: _isDarkMode ? Colors.white : Colors.black),
        actions: [
          IconButton(
            icon: Icon(_isDarkMode
                ? Icons.wb_sunny_outlined
                : Icons.nightlight_outlined),
            onPressed: _toggleTheme, // ปุ่มสำหรับเปลี่ยนธีมสี
            color: _isDarkMode ? Colors.white : Colors.black,
          ),
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: _showFormulaExplanation, // ปุ่มแสดงคำอธิบายสูตร
            color: _isDarkMode ? Colors.white : Colors.black,
          ),
        ],
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
                      'สูตรคำนวณพื้นที่วงกลม: พื้นที่ = π x รัศมียกกำลังสอง\n'
                      'กรุณากรอกรัศมีเพื่อคำนวณพื้นที่วงกลม',
                    ),
                    SizedBox(height: 10),
                    _buildTextField(
                      controller: _radiusController,
                      label: 'Radius of Circle',
                      icon: Icons.circle_outlined,
                    ),
                    SizedBox(height: 8),
                    _buildCalculateButton(
                      label: 'Calculate Circle Area',
                      onPressed: _calculateCircleArea,
                    ),
                    SizedBox(height: 8),
                    _buildResultText('Circle Area: $_circleArea'),
                  ],
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
      backgroundColor: _isDarkMode ? Colors.black : Colors.white,
    );
  }

  Widget _buildCard({required Widget child}) {
    return Card(
      color: _isDarkMode
          ? Colors.grey[800]
          : Colors.grey[100], // ปรับสีการ์ดให้เข้ากับโทนธีม
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
        prefixIcon:
            Icon(icon, color: _isDarkMode ? Colors.white54 : Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              BorderSide(color: _isDarkMode ? Colors.white54 : Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              BorderSide(color: _isDarkMode ? Colors.white : Colors.black),
        ),
        labelStyle:
            TextStyle(color: _isDarkMode ? Colors.white70 : Colors.black),
      ),
      keyboardType: TextInputType.number,
      style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black),
    );
  }

  Widget _buildCalculateButton(
      {required String label, required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: _isDarkMode ? Colors.white : Colors.black,
        foregroundColor: _isDarkMode ? Colors.black : Colors.white,
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
        color: _isDarkMode ? Colors.white : Colors.black87,
      ),
    );
  }

  Widget _buildDescriptionText(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        color: _isDarkMode ? Colors.white70 : Colors.grey[800],
      ),
    );
  }
}
