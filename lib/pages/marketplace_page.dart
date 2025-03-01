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

              widget.updateInventory(widget.ownedDigimons);
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
          Positioned.fill(
            child: Image.asset(
              "assets/background.png",
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: Colors.black.withOpacity(0.2),
              ),
            ),
          ),
          Column(
            children: [
              AppBar(
                title: const Text("Digimon Marketplace", style: TextStyle(color: Colors.white,fontSize: 28,
              fontFamily: 'Payback')),
                backgroundColor:Color(0xFF1976D2),
                elevation: 0,
              ),
              Expanded(
                child: digimons.isEmpty
                    ? const Center(
                  child: Text(
                    "No Digimons available!",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                )
                    : Padding(
                  padding:
                  const EdgeInsets.all(12),
                  child: ListView.builder(
                    itemCount: digimons.length,
                    itemBuilder: (context, index) {
                      var digimon = digimons[index];
                      bool alreadyOwned = widget.ownedDigimons.any((d) => d['id'] == digimon['id']);
                      return Card(
                        color: Color(0xFF1976D2),
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
                          trailing: ElevatedButton(
                            onPressed: alreadyOwned ? null : () => buyDigimon(digimon),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: alreadyOwned ? Colors.grey : Colors.amber,
                            ),
                            child: Text(alreadyOwned ? "Owned" : "Get"),
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
