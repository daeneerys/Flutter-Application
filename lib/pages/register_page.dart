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
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  File? _selectedImage; // For mobile
  Uint8List? _webImage; // For web

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (kIsWeb) {
        // Convert to Uint8List for Web
        var bytes = await pickedFile.readAsBytes();
        setState(() {
          _webImage = bytes;
        });
      } else {
        // Use File for mobile
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    }
  }

  void _register() {
    String username = usernameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (username.isNotEmpty && email.isNotEmpty && password.isNotEmpty && (_selectedImage != null || _webImage != null)) {
      widget.users.add({
        'username': username,
        'email': email,
        'password': password,
        'profilePicture': kIsWeb
            ? String.fromCharCodes(_webImage!)  // Convert Uint8List to String
            : _selectedImage!.path  // Store file path for mobile
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
        const SnackBar(content: Text("All fields and profile picture are required!")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: "Username"),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            const SizedBox(height: 10),

            // Display selected image (Web or Mobile)
            _webImage != null
                ? Image.memory(_webImage!, height: 100, width: 100, fit: BoxFit.cover) // Web image
                : _selectedImage != null
                ? Image.file(_selectedImage!, height: 100, width: 100, fit: BoxFit.cover) // Mobile image
                : const Text("No image selected"), // Default text

            const SizedBox(height: 10),

            // Button to pick an image
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text("Pick Profile Picture"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _register,
              child: const Text("Register"),
            ),
          ],
        ),
      ),
    );
  }
}
