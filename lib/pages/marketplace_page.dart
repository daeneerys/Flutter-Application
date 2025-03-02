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
  List<dynamic> filteredDigimons = [];
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
        filteredDigimons = fetchedDigimons;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  void searchDigimon(String query) {
    setState(() {
      filteredDigimons = digimons
          .where((digimon) => digimon['name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
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
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  controller: searchController,
                  onChanged: searchDigimon,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xFFFFFFFF),
                    hintText: "Search Digimon...",
                    hintStyle: const TextStyle(color: Colors.grey),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
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
                        child: ExpansionTile(
                          trailing: SizedBox.shrink(),
                          iconColor: Colors.white,
                          collapsedIconColor: Colors.white,
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Keeps name + arrow and button spaced
                            children: [
                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      digimon['image'],
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 12),

                                  // Prevents overflow while keeping the name and arrow together
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.4, // Ensures it does not take too much space
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            digimon['name'],
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Oxanium',
                                            ),
                                            overflow: TextOverflow.ellipsis, // Truncate text if too long
                                            maxLines: 1,
                                            softWrap: false,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              // "Get" Button with adaptive padding
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  double buttonPadding = constraints.maxWidth < 400 ? 8.0 : 16.0;

                                  return ElevatedButton(
                                    onPressed: alreadyOwned ? null : () => buyDigimon(digimon),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: alreadyOwned ? Colors.grey : const Color(0xFFFFC107),
                                      padding: EdgeInsets.symmetric(horizontal: buttonPadding, vertical: 8),
                                      minimumSize: const Size(90, 40),
                                    ),
                                    child: const Text(
                                      "Get",
                                      style: TextStyle(
                                        color: Color(0xFF121212),
                                        fontFamily: 'Oxanium',
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "X-Antibody: ${digimon['xAntibody']}",
                                      style: const TextStyle(color: Color(0xFFFFFFFF), fontSize: 16, fontFamily: 'Oxanium'),
                                    ),
                                    Text(
                                      "Level: ${digimon['level']}",
                                      style: const TextStyle(color: Color(0xFFFFFFFF), fontSize: 16, fontFamily: 'Oxanium'),
                                    ),
                                    Text(
                                      "Attribute: ${digimon['attribute']}",
                                      style: const TextStyle(color: Color(0xFFFFFFFF), fontSize: 16, fontFamily: 'Oxanium'),
                                    ),
                                    Text(
                                      "Type: ${digimon['type']}",
                                      style: const TextStyle(color: Color(0xFFFFFFFF), fontSize: 16, fontFamily: 'Oxanium'),
                                    ),
                                    Text(
                                      "Field: ${digimon['field']}",
                                      style: const TextStyle(color: Color(0xFFFFFFFF), fontSize: 16, fontFamily: 'Oxanium'),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "Description:",
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      digimon['description'],
                                      style: const TextStyle(color: Color(0xFFFFFFFF), fontSize: 14, fontFamily: 'Poppins'),
                                    ),
                                  ],
                                ),
                              ),
                            )],
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