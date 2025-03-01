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
  List<dynamic> filteredDigimons = []; // For search functionality
  final DigimonApiService apiService = DigimonApiService();
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchDigimons();
  }

  void fetchDigimons() async {
    try {
      var digimonIds = List.generate(100, (index) => index + 1); // Fetch IDs 1 to 100
      var fetchedDigimons = await apiService.fetchMultipleDigimons(digimonIds);
      setState(() {
        digimons = fetchedDigimons;
        filteredDigimons = fetchedDigimons; // Initialize filtered list
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  void filterSearchResults(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredDigimons = digimons;
      } else {
        filteredDigimons = digimons
            .where((digimon) => digimon['name'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
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
                title: const Text(
                  "Digimon Marketplace",
                  style: TextStyle(color: Colors.white, fontSize: 28, fontFamily: 'Payback'),
                ),
                backgroundColor: Color(0xFF1976D2),
                elevation: 0,
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  controller: searchController,
                  onChanged: filterSearchResults,
                  decoration: InputDecoration(
                    hintText: "Search Digimon...",
                    hintStyle: const TextStyle(color: Colors.grey),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    filled: true,
                    fillColor: Color(0xFFFFFFFF),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(color: Colors.black),
                ),
              ),
              Expanded(
                child: filteredDigimons.isEmpty
                    ? const Center(
                  child: Text(
                    "No Digimons available!",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                )
                    : Padding(
                  padding: const EdgeInsets.all(12),
                  child: ListView.builder(
                    itemCount: filteredDigimons.length,
                    itemBuilder: (context, index) {
                      var digimon = filteredDigimons[index];
                      bool alreadyOwned = widget.ownedDigimons.any((d) => d['id'] == digimon['id']);

                      return Card(
                        color: Color(0xFF1976D2),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              digimon['image'],
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            digimon['name'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Oxanium',
                            ),
                          ),
                          trailing: ElevatedButton(
                            onPressed: alreadyOwned ? null : () => buyDigimon(digimon),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: alreadyOwned ? Colors.grey : const Color(0xFFFFC107),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            ),
                            child: const Text("Get", style: TextStyle(color: Color(0xFF121212)) ),
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
