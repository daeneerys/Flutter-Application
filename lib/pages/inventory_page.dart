import 'package:flutter/material.dart';
import 'dart:ui'; // For blur effect

class DigimonInventoryPage extends StatefulWidget {
  final List<dynamic> ownedDigimons;
  final Function(List<dynamic>) updateInventory; // Callback to sync with Marketplace

  const DigimonInventoryPage({super.key, required this.ownedDigimons, required this.updateInventory});

  @override
  State<DigimonInventoryPage> createState() => _DigimonInventoryPageState();
}

class _DigimonInventoryPageState extends State<DigimonInventoryPage> {
  late List<dynamic> inventory;

  @override
  void initState() {
    super.initState();
    inventory = List.from(widget.ownedDigimons); // Clone the list to modify
  }

  void confirmRemoveDigimon(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Remove Digimon"),
          content: const Text("Are you sure you want to remove this Digimon from your inventory?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Close the dialog
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                removeDigimon(index);
              },
              child: const Text("Remove", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void removeDigimon(int index) {
    setState(() {
      inventory.removeAt(index);
    });

    widget.updateInventory(inventory); // Update marketplace when Digimon is removed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'digimons.jpg', // Change this to your actual background image path
              fit: BoxFit.cover,
            ),
          ),

          // Blurry Effect
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // Adjust blur intensity
              child: Container(color: Colors.black.withOpacity(0.2)), // Slight dark overlay
            ),
          ),

          // Inventory List
          Column(
            children: [
              AppBar(
                title: const Text("Digimon Inventory", style: TextStyle(color: Colors.white)),
                backgroundColor: Colors.indigo,
                elevation: 0,
              ),
              Expanded(
                child: inventory.isEmpty
                    ? const Center(
                  child: Text(
                    "No Digimons owned yet!",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                )
                    : Padding(
                  padding: const EdgeInsets.all(12),
                  child: ListView.builder(
                    itemCount: inventory.length,
                    itemBuilder: (context, index) {
                      var digimon = inventory[index];
                      return Card(
                        color: Colors.indigo[900],
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              digimon['image'],
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            digimon['name'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            "ID: ${digimon['id']}",
                            style: const TextStyle(color: Colors.white70),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.redAccent),
                            onPressed: () => confirmRemoveDigimon(index),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
