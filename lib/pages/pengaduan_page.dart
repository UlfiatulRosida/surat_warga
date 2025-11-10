import 'package:flutter/material.dart';

class PengaduanPage extends StatelessWidget {
  const PengaduanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Halaman Pengaduan'),
      ),
      body: const Center(
        child: Text(
          'Ini adalah halaman pengaduan.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
