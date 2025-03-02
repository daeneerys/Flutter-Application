import 'dart:io'; // For File (Mobile)
import 'dart:typed_data'; // For Uint8List (Web)
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  final List<Map<String, String>> users;

  const RegisterPage({super.key, required this.users});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  File? _selectedImage; // For mobile
  Uint8List? _webImage; // For web

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (kIsWeb) {
        var bytes = await pickedFile.readAsBytes();
        setState(() {
          _webImage = bytes;
        });
      } else {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    }
  }

  void _register() {
    if (_formKey.currentState!.validate()) {
      String username = usernameController.text.trim();
      String email = emailController.text.trim();
      String password = passwordController.text.trim();

      if (_selectedImage != null || _webImage != null) {
        widget.users.add({
          'username': username,
          'email': email,
          'password': password,
          'profilePicture': kIsWeb
              ? String.fromCharCodes(_webImage!)
              : _selectedImage!.path,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Registration successful!")),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage(users: widget.users)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile picture is required!")),
        );
      }
    }
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';

    String pattern = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&#])[A-Za-z\d@$!%*?&#]{6,}$';
    RegExp regex = RegExp(pattern);

    if (!regex.hasMatch(value)) {
      return 'Password must be at least 6 characters and include\n'
          '1 uppercase, 1 lowercase, 1 number, and 1 special character';
    }
    return null;
  }


  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) return 'Username is required';
    if (value.length < 3) return 'Username must be at least 3 characters';

    // Check if username already exists
    bool usernameExists = widget.users.any((user) => user['username'] == value);
    if (usernameExists) return 'Username is already taken';

    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value)) return 'Invalid email format';

    bool emailExists = widget.users.any((user) => user['email'] == value);
    if (emailExists) return 'Email is already registered';

    return null;
  }
  //
  // String? _validatePassword(String? value) {
  //   if (value == null || value.isEmpty) return 'Password is required';
  //   if (value.length < 6) return 'Password must be at least 6 characters';
  //   return null;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/register_background.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          Center(
            child: Container(
              width: MediaQuery.of(context).size.width > 400 ? 400 : MediaQuery.of(context).size.width * 0.9,
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Digimon Logo
                    Image.asset(
                      "assets/login_logo.png",
                      width: 150,
                      height: 150,
                    ),
                    const SizedBox(height: 20),

                    // Username Field
                    TextFormField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        labelText: "Username",
                        prefixIcon: const Icon(Icons.person, color: Color(0xFF1565C0)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator: _validateUsername,
                    ),
                    const SizedBox(height: 15),

                    // Email Field
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        prefixIcon: const Icon(Icons.email, color: Color(0xFF1565C0)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator: _validateEmail,
                    ),
                    const SizedBox(height: 15),

                    // Password Field
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        prefixIcon: const Icon(Icons.lock, color: Color(0xFF1565C0)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator: _validatePassword,
                    ),
                    const SizedBox(height: 20),

                    // Profile Picture Upload Section
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                          image: _webImage != null
                              ? DecorationImage(image: MemoryImage(_webImage!), fit: BoxFit.cover)
                              : _selectedImage != null
                              ? DecorationImage(image: FileImage(_selectedImage!), fit: BoxFit.cover)
                              : null,
                        ),
                        child: _webImage == null && _selectedImage == null
                            ? const Center(child: Text("Tap to upload"))
                            : null,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Register Button
                    ElevatedButton(
                      onPressed: _register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D47A1),
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Register",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Login Redirect Link
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage(users: widget.users)),
                        );
                      },
                      child: const Text(
                        "Already have an account? Login here",
                        style: TextStyle(color: Color(0xFF0D47A1)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}