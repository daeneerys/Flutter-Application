import 'dart:ui'; // For ImageFilter.blur
import 'package:flutter/material.dart';
import '../digimon_api_service.dart';

class DigimonMarketplacePage extends StatefulWidget {
  final List<dynamic> ownedDigimons;
  final Function(List<dynamic>) updateInventory; // Callback function

  const DigimonMarketplacePage({super.key, required this.ownedDigimons, required this.updateInventory});

  @override
  _DigimonMarketplacePageState createState() => _DigimonMarketplacePageState();
}

class _DigimonMarketplacePageState extends State<DigimonMarketplacePage> {
  List<dynamic> digimons = [];
  final DigimonApiService apiService = DigimonApiService();

  @override
  void initState() {
    super.initState();
    fetchDigimons();
  }

  void fetchDigimons() async {
    try {
      var fetchedDigimons = await apiService.fetchDigimons();
      setState(() {
        digimons = fetchedDigimons;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  void buyDigimon(dynamic digimon) {
    // Check if Digimon is already owned
    bool alreadyOwned = widget.ownedDigimons.any((d) => d['id'] == digimon['id']);

    if (alreadyOwned) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("You already own this Digimon. Check in your inventory!"),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirm Purchase"),
        content: Text("Do you want to buy ${digimon['name']}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                widget.ownedDigimons.add(digimon);
              });

              widget.updateInventory(widget.ownedDigimons); // Update inventory in main state

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("${digimon['name']} added to inventory!"),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: const Text("Buy"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image with Blur Effect
          Positioned.fill(
            child: Image.asset(
              "background.png", // Change to your background image
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // Adjust blur intensity
              child: Container(
                color: Colors.black.withOpacity(0.3), // Slightly dark overlay
              ),
            ),
          ),
          // Main UI
          Column(
            children: [
              AppBar(
                title: const Text("Digimon Marketplace", style: TextStyle(color: Colors.white)),
                backgroundColor: Colors.indigo, // Slight transparency
              ),
              Expanded(
                child: digimons.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth < 600) {
                      return ListView.builder(
                        padding: const EdgeInsets.all(10),
                        itemCount: digimons.length,
                        itemBuilder: (context, index) {
                          return _buildCard(index, constraints.maxWidth * 0.8);
                        },
                      );
                    }
                    return GridView.builder(
                      padding: const EdgeInsets.all(10),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 0.7,
                      ),
                      itemCount: digimons.length,
                      itemBuilder: (context, index) {
                        return _buildCard(index, constraints.maxWidth / 5);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCard(int index, double cardWidth) {
    var digimon = digimons[index];
    bool alreadyOwned = widget.ownedDigimons.any((d) => d['id'] == digimon['id']);

    return Card(
      color: Colors.indigo[900],
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              digimon['image'],
              height: 200,
              width: cardWidth,
              fit: BoxFit.fill,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            digimon['name'],
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'ID: ${digimon['id']}',
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: alreadyOwned ? null : () => buyDigimon(digimon),
            style: ElevatedButton.styleFrom(
              backgroundColor: alreadyOwned ? Colors.grey : Colors.amber,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: Text(alreadyOwned ? "Owned" : "Get"),
          ),
        ],
      ),
    );
  }
}
