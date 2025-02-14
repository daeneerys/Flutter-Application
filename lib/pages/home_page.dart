import 'dart:ui'; // Required for blur effect
import 'package:flutter/material.dart';
import 'inventory_page.dart';
import 'marketplace_page.dart';
import 'profile_page.dart';
import 'about_page.dart';
import '../digimon_api_service.dart';

class DigimonHomePage extends StatefulWidget {
  const DigimonHomePage({super.key});

  @override
  State<DigimonHomePage> createState() => _DigimonHomePageState();
}

class _DigimonHomePageState extends State<DigimonHomePage> {
  List<dynamic> digimons = [];
  List<dynamic> ownedDigimons = [];
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
        // Limit the number of Digimons to 5
        digimons = fetchedDigimons.take(5).toList();
      });
    } catch (e) {
      print("Error: $e");
    }
  }
  void updateInventory(List<dynamic> newInventory) {
    setState(() {
      ownedDigimons = newInventory;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Digimon Home", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: const Text("User Name", style: TextStyle(color: Colors.white)),
              accountEmail: const Text("user@example.com", style: TextStyle(color: Colors.white70)),
              currentAccountPicture: const CircleAvatar(
                backgroundImage: AssetImage('assets/profile_pic.png'),
              ),
              decoration: const BoxDecoration(color: Colors.indigo),
            ),
            _drawerItem(context, Icons.home, "Home Page", () {
              Navigator.pop(context);
            }),
            _drawerItem(context, Icons.inventory, "Digimon Inventory", () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DigimonInventoryPage(ownedDigimons: ownedDigimons, updateInventory: updateInventory),
                ),
              );
            }),
            _drawerItem(context, Icons.shopping_cart, "Digimon Marketplace", () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DigimonMarketplacePage(ownedDigimons: ownedDigimons, updateInventory: updateInventory),
                ),
              );
            }),
            _drawerItem(context, Icons.person, "Profile Page", () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
            }),
            _drawerItem(context, Icons.info, "About Page", () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutPage()));
            }),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Background Image with Blur Effect
          Positioned.fill(
            child: Image.asset(
              'home.jpg', // Replace with your actual image
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // Adjust blur intensity
              child: Container(
                color: Colors.black.withOpacity(0.3), // Dark overlay for readability
              ),
            ),
          ),

          // Main Content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Check out this cool Digimons!",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth < 600) {
                        return ListView.builder(
                          itemCount: digimons.length,
                          itemBuilder: (context, index) {
                            return _buildCard(index, constraints.maxWidth * 0.8);
                          },
                        );
                      }
                      return GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
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
          ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }

  // Reusable method for building each Digimon card with dynamic size
  Widget _buildCard(int index, double cardWidth) {
    return Card(
      color: Colors.indigo[900], // Darker color for better contrast
      elevation: 8, // Shadow effect for the card
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Rounded corners
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10), // Rounded corners for image
            child: Image.network(
              digimons[index]['image'],
              height: 200, // Image height (adjustable for responsiveness)
              width: cardWidth, // Dynamic card width
              fit: BoxFit.fill, // Adjust to maintain aspect ratio
            ),
          ),
          const SizedBox(height: 12),
          Text(
            digimons[index]['name'],
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'ID: ${digimons[index]['id']}',
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  ListTile _drawerItem(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.indigo),
      title: Text(title, style: const TextStyle(color: Colors.indigo)),
      onTap: onTap,
    );
  }
}
