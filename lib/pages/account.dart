import 'package:flutter/material.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent, // Set background to transparent.
      child: Center(
        child: Text(
          "Account Page",
          style: TextStyle(color: Colors.black, fontSize: 24),
        ),
      ),
    );
  }
}
