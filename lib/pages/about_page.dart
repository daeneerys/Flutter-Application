import 'package:flutter/material.dart';
import 'dart:ui';
import 'home_page.dart';
import 'profile_page.dart';


class AboutPage extends StatelessWidget {
  final String username;
  final String email;
  final String profilePicture;

  const AboutPage({
    super.key,
    required this.username,
    required this.email,
    required this.profilePicture,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0D47A1),
      appBar: AppBar(
        title: Text("About Us", style: TextStyle(color: Colors.white,
            fontSize: 28,
            fontFamily: 'Payback')),
        backgroundColor: Color(0xFF1976D2),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    Image.asset(
                      'assets/about_digimon.jpg',

                    ),
                    SizedBox(height: 20),
                    //Center Text
                    Text(
                      "Welcome to the Digital World! Digimon World is your one stop for everything Digimon related."
                          " Whether you have a casual interest or an avid collector, Digimon World is guaranteed to have what you need.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    SizedBox(height: 30),

                    // Cards
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DigimonHomePage(username: username,
                            email: email,
                            profilePicture: profilePicture,)),
                        );
                      },
                      child: Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/about_marketCard.jpg',
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Meet the Digimon",
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Explore the different Digimon and their evolutions!",
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),

                    // Profile Page Card
                    GestureDetector(
                      // onTap: () {
                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute(builder: (context) => ProfilePage()),
                      //   );
                      // },
                      child: Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/about_profileCard.jpg',
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Discover the Digital World",
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Join our community of Digimon Tamers!",
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          //Icons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.facebook, color: Colors.white),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.link, color: Colors.white),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.camera, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),
          SizedBox(height: 20),

          // Footer Section
          Container(
            padding: EdgeInsets.all(12.0),
            width: double.infinity,
            color: Color(0xFF1565C0),
            child: Text(
              "© 2025 Digimon World. All rights reserved.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
