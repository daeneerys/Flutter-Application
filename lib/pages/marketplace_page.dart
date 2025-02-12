import 'package:flutter/material.dart';

class DigimonMarketplacePage extends StatelessWidget {
  const DigimonMarketplacePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Digimon Marketplace", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo,
      ),
      body: const Center(
        child: Text("This is the Axie Marketplace Page", style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
