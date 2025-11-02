import 'package:flutter/material.dart';

class LiterationPage extends StatelessWidget {
  const LiterationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Literation Page'),
      ),
      body: const Center(
        child: Text('Welcome to the Literation Page!'),
      ),
    );
  }
}