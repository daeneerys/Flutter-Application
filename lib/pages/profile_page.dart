import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile Page", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo,
      ),
      body: const Center(
        child: Text("This is the Profile Page", style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
