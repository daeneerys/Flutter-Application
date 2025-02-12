import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About Page", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo,
      ),
      body: const Center(
        child: Text("This is the About Page", style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
