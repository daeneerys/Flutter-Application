import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final String username;
  final String email;
  final String profilePicture;

  const ProfilePage({
    super.key,
    required this.username,
    required this.email,
    required this.profilePicture, // Pass profile picture correctly
  });

  final double coverHeight = 200; // Reduced cover height
  final double profileHeight = 120; // Reduced profile height

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Profile",
            style: TextStyle(color: Colors.white, fontSize: 28, fontFamily: 'Payback')),
        backgroundColor: const Color(0xFF1976D2),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          buildTop(),
          buildContent(),
        ],
      ),
    );
  }

  Widget buildTop() {
    final bottom = profileHeight / 2;
    final top = coverHeight - profileHeight;
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        buildCoverImage(),
        Positioned(
          top: top,
          child: buildProfileImage(),
        ),
      ],
    );
  }

  Widget buildCoverImage() => Container(
    color: Colors.grey,
    child: Image(
      image: const AssetImage('assets/TK_background.jpg'), // Digimon cover image
      width: double.infinity,
      height: coverHeight,
      fit: BoxFit.cover,
    ),
  );


  Widget buildProfileImage() => CircleAvatar(
    radius: profileHeight / 2,
    backgroundColor: Colors.grey.shade800,
    backgroundImage: profilePicture.isNotEmpty
        ? (kIsWeb
        ? MemoryImage(Uint8List.fromList(profilePicture.codeUnits)) // Web
        : FileImage(File(profilePicture)) as ImageProvider) // Mobile
        : const AssetImage('assets/T.K.jpg'), // Default image
  );

  Widget buildContent() => Column(
    children: [
      const SizedBox(height: 16),
      Text(
        username, // Display logged-in user's name
        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      Text(
        email, // Display logged-in user's email
        style: const TextStyle(fontSize: 20, color: Colors.black),
      ),
      const SizedBox(height: 8),
      const Text(
        'The Hope of the DigiDestined', // Taki's title
        style: TextStyle(fontSize: 20, color: Colors.black),
      ),
      const SizedBox(height: 16),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Text(
          'Takaishi Takeru, also known as T.K., is one of the DigiDestined from the first season of Digimon Adventure. He is the bearer of the Crest of Hope and the partner of Patamon.', // Taki's bio
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
        ),
      ),
      const SizedBox(height: 16),
      buildSocialButtons(),
      const SizedBox(height: 16),
      buildInfo(),
    ],
  );

  Widget buildSocialButtons() => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      buildSocialButton(Icons.favorite, Colors.pink, () {
        // Handle favorite tap
      }),
      const SizedBox(width: 16),
      buildSocialButton(Icons.mail, Colors.red, () {
        // Handle Email tap
      }),
      const SizedBox(width: 16),
      buildSocialButton(Icons.chat, Colors.blue, () {
        // Handle chat tap
      }),
    ],
  );

  Widget buildSocialButton(IconData icon, Color color, VoidCallback onTap) =>
      InkWell(
        onTap: onTap,
        child: CircleAvatar(
          radius: 24,
          backgroundColor: color,


          child: Icon(icon, color: Colors.white),
        ),
      );

  Widget buildInfo() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 32),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'About',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'T.K. is a kind and courageous boy who always tries to help others. His Digimon partner, Patamon, digivolves into Angemon, a powerful angel Digimon.',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 16),
        const Text(
          'Partner',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Patamon',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
        const Text(
          'Digivolution: Angemon',
          style: TextStyle(fontSize: 16),
        ),
      ],
    ),
  );
}
