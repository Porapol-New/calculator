// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minimalist Calculator',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.black87),
        ),
      ),
      home: CubeVolume(),
    );
  }
}

class CubeVolume extends StatefulWidget {
  @override
  _CubeVolumeState createState() => _CubeVolumeState();
}

class _CubeVolumeState extends State<CubeVolume> {
  final TextEditingController _sideController = TextEditingController();
  double _cubeVolume = 0.0;
  bool _showFormula = false; // ตัวแปรเพื่อควบคุมการแสดงคำอธิบายสูตร

  void _calculateCubeVolume() {
    final side = double.tryParse(_sideController.text);
    if (side != null) {
      setState(() {
        _cubeVolume = side * side * side;
      });
    }
  }

  void _toggleFormula() {
    setState(() {
      _showFormula = !_showFormula; // เปลี่ยนสถานะการแสดง/ซ่อนสูตร
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minimalist Calculator'),
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
                      'สูตรคำนวณปริมาตรทรงลูกบาศก์: ปริมาตร = ด้าน^3\n'
                      'กรุณากรอกค่าด้านของลูกบาศก์เพื่อคำนวณปริมาตร',
                    ),
                    SizedBox(height: 10),
                    _buildTextField(
                        controller: _sideController,
                        label: 'Side of Cube',
                        icon: Icons.cut_outlined),
                    SizedBox(height: 8),
                    _buildCalculateButton(
                      label: 'Calculate Cube Volume',
                      onPressed: _calculateCubeVolume,
                    ),
                    SizedBox(height: 8),
                    _buildResultText('Cube Volume: $_cubeVolume'),
                  ],
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _toggleFormula, // ปุ่มสำหรับแสดง/ซ่อนคำอธิบายสูตร
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[800],
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                child: Text(
                  _showFormula ? 'ซ่อนคำอธิบายสูตร' : 'แสดงคำอธิบายสูตร',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              if (_showFormula) // แสดงคำอธิบายสูตรเมื่อผู้ใช้กดปุ่ม
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: _buildCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'คำอธิบายสูตร:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        _buildDescriptionText(
                          'การคำนวณปริมาตรของลูกบาศก์ (Cube Volume) ใช้สูตรง่าย ๆ '
                          'ปริมาตร (V) = ด้าน (s) ยกกำลังสาม หรือ V = s³\n'
                          'ปริมาตรของลูกบาศก์คือพื้นที่ที่ลูกบาศก์ใช้ในช่องว่าง ซึ่งสามารถคำนวณได้โดยการนำความยาวของด้านหนึ่งของลูกบาศก์มาคูณกันสามครั้ง '
                          'ดังนั้น ปริมาตรจึงขึ้นอยู่กับค่าของความยาวด้านของลูกบาศก์',
                        ),
                        SizedBox(height: 10),
                        _buildDescriptionText(
                          'ตัวอย่าง: ถ้าด้านของลูกบาศก์มีความยาว 3 หน่วย ปริมาตรจะคำนวณเป็น 3³ = 3 x 3 x 3 = 27 หน่วย³',
                        ),
                      ],
                    ),
                  ),
                ),
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

  Widget _buildCalculateButton(
      {required String label, required VoidCallback onPressed}) {
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
