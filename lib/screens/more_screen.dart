
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('More'), backgroundColor: Colors.white),
      body: const Center(child: Text('More Options', style: TextStyle(fontSize: 20))),
    );
  }
}
