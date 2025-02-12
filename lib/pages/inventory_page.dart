import 'package:flutter/material.dart';

class DigimonInventoryPage extends StatelessWidget {
  const DigimonInventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Digimon Inventory", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo,
      ),
      body: const Center(
        child: Text("This is the Digimon Inventory Page", style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
