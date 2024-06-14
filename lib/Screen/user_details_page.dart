import 'package:chatt_app/Screen/Services/auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDetailsPage extends StatelessWidget {
  final String name;
  final AuthServices _authService = AuthServices();

  UserDetailsPage({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    User? user = _authService.getCurrentUser();
    print("User details: ${user?.displayName}, ${user?.email}");

    return Scaffold(
      appBar: AppBar(
        title: Text('User Details'),
      ),
      body: user != null
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    backgroundImage: AssetImage("images/3135715.png"),
                    radius: 60,
                  ),
                  Text('Name: ${name}', style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 8),
                  Text('Email: ${user.email}', style: TextStyle(fontSize: 18)),
                ],
              ),
            )
          : Center(
              child: Text('No user logged in'),
            ),
    );
  }
}
