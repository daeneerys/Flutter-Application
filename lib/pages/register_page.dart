import 'dart:io'; // For File (Mobile)
import 'dart:typed_data'; // For Uint8List (Web)
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'login_page.dart';
import '../models/userinformation.dart';

class RegisterPage extends StatefulWidget {
  List<UserInformation> users = [];

  RegisterPage({super.key, required this.users});

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
    String username = usernameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String profilePicture = kIsWeb
        ? String.fromCharCodes(_webImage!)
        : _selectedImage!.path;

    if (_selectedImage != null || _webImage != null) {
      setState(() {
        widget.users.add(UserInformation(username, email, password, profilePicture));
      });

      usernameController.clear();
      emailController.clear();
      passwordController.clear();
      setState(() {
        _selectedImage = null;
        _webImage = null;
      });
    }
  }

  int searchUserIndex(String username) {
    return widget.users.indexWhere((user) => user.username == username);
  }

  void UpdateInfo() {
    int searchedUser = searchUserIndex(usernameController.text);
    if (searchedUser != -1) {
      setState(() {
        widget.users[searchedUser].username = usernameController.text;
        widget.users[searchedUser].email = emailController.text;
      });
    }
  }

  void DeleteInfo() {
    int searchedUser = searchUserIndex(usernameController.text);
    if (searchedUser != -1) {
      setState(() {
        widget.users.removeAt(searchedUser);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            TextField(controller: usernameController, decoration: InputDecoration(labelText: "Username")),
            TextField(controller: emailController, decoration: InputDecoration(labelText: "Email")),
            TextField(controller: passwordController, decoration: InputDecoration(labelText: "Password")),
            ElevatedButton(onPressed: _pickImage, child: Text("Pick Image")),
            ElevatedButton(onPressed: _register, child: Text("Register")),
            ElevatedButton(onPressed: UpdateInfo, child: Text("Update")),
            ElevatedButton(onPressed: DeleteInfo, child: Text("Delete")),
            Expanded(
              child: ListView.builder(
                itemCount: widget.users.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(widget.users[index].username),
                    subtitle: Text(widget.users[index].email),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
