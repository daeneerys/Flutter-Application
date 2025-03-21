import 'dart:io';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'inventory_page.dart';
import 'marketplace_page.dart';
import 'profile_page.dart';
import 'about_page.dart';
import '../digimon_api_service.dart';
import 'login_page.dart';

class DigimonHomePage extends StatefulWidget {
  final String username;
  final String email;
  final String profilePicture;

  const DigimonHomePage({
    super.key,
    required this.username,
    required this.email,
    required this.profilePicture,
  });

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
      var digimonIds = List.generate(100, (index) => index + 1); // Fetch IDs 1 to 100
      var fetchedDigimons = await apiService.fetchMultipleDigimons(digimonIds);
      setState(() {
        digimons = fetchedDigimons;
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
  void _logout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage(users: [],)),
          (route) => false, // Remove all previous routes
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Digimon", style:
        TextStyle
          (color: Colors.white,
            fontSize: 28,
            fontFamily: 'Payback'
        )),
        backgroundColor: Color(0xFF1976D2),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(widget.username, style: const TextStyle(color: Colors.white)),
              accountEmail: Text(widget.email, style: const TextStyle(color: Colors.white70)),
              currentAccountPicture: CircleAvatar(
                backgroundImage: widget.profilePicture.isNotEmpty
                    ? (kIsWeb
                    ? MemoryImage(Uint8List.fromList(widget.profilePicture.codeUnits)) // Web
                    : FileImage(File(widget.profilePicture)) as ImageProvider) // Mobile
                    : const AssetImage('assets/T.K.jpg'), // Default image
              ),

              decoration: const BoxDecoration(color: Color(0xFF0D47A1)),
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
              Navigator.push(context, MaterialPageRoute(builder: (context) =>  ProfilePage(username: widget.username,
                  email: widget.email,
                  profilePicture: widget.profilePicture)));
            }),
            _drawerItem(context, Icons.info, "About Page", () {
              Navigator.push(context, MaterialPageRoute(builder: (context) =>  AboutPage(
                username: widget.username,
                email: widget.email,
                profilePicture: widget.profilePicture,)));
            }),
            const Divider(), // Separator line
            _drawerItem(context, Icons.logout, "Logout", () {
              _logout(context);
            }),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, // Ensures full width
          children: [
            Image.asset(
              'assets/digimon_homepage.jpg', // Ensure correct path
              width: double.infinity,
              height: 585,
              fit: BoxFit.cover,
            ),

            // Welcome message container
            Container(
              color: Color(0xFF1976D2),
              padding: const EdgeInsets.all(16),
              alignment: Alignment.center, // Centers the text
              child: const Text(
                'WELCOME TO \nDIGIMON WORLD!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Payback',
                  fontSize: 40,
                  color: Color(0xFFFFFFFF),
                ),
              ),
            ),

            // Collect your Digimons section
            Container(
              color: Color(0xFFFFC107), // Updated background color
              padding: const EdgeInsets.all(16),
              alignment: Alignment.center,
              child: Column(
                children: [
                  const Text(
                    'COLLECT YOUR \nDIGIMONS FOR FREE!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontFamily: 'Oxanium',
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DigimonMarketplacePage(
                            ownedDigimons: ownedDigimons,
                            updateInventory: updateInventory,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF121212),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Go to Marketplace',
                      style: TextStyle(fontSize: 18, fontFamily: 'Poppins', fontWeight: FontWeight.w400, color: Color(0xFFFFFFFF)),
                    ),
                  ),
                ],
              ),
            ),

            // Check out your Digimons section
            Container(
              color: Color(0xFFD32F2F),
              padding: const EdgeInsets.all(16),
              alignment: Alignment.center,
              child: Column(
                children: [
                  const Text(
                    'GO CHECK OUT \nYOUR DIGIMONS!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontFamily: 'Oxanium',
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DigimonInventoryPage(
                            ownedDigimons: ownedDigimons,
                            updateInventory: updateInventory,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF121212),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Go to Inventory',
                      style: TextStyle(fontSize: 18, fontFamily: 'Poppins', fontWeight: FontWeight.w400, color: Color(0xFFFFFFFF)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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