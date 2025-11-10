import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar custom dengan logo dan ikon notifikasi
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: Row(
          children: [
            Image.asset(
              'assets/logo.png', // ganti dengan logo kamu
              width : 35,
              height : 35,
            ),
            const SizedBox(width : 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Surat Warga',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Dinas Komunikasi dan Informatika',
                  style: TextStyle(fontSize: 10),
                ),
              ],
            ),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right : 16),
            child: Icon(Icons.notifications_none, size: 28),
          )
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Beranda',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height : 16),

            // Kartu informasi atas
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _infoCard(
                  icon: Icons.mail_outline,
                  title: 'Jumlah Keluaran baru',
                  value: '21',
                ),
                _infoCard(
                  icon: Icons.wb_sunny_outlined,
                  title: 'Info cuaca',
                  value: '35',
                ),
              ],
            ),
            const SizedBox(height : 20),

            // Tabel keluhan terakhir
            Container(
              width : double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Container(
                    width : double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: const BorderRadius.vertical(top : Radius.circular(12)),
                    ),
                    child: const Text(
                      'Keluhan Terakhir',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  DataTable(
                    columnSpacing: 16,
                    headingRowColor: MaterialStateColor.resolveWith((states) => Colors.grey[300]!),
                    columns: const [
                      DataColumn(label: Text('No')),
                      DataColumn(label: Text('Nama Warga')),
                      DataColumn(label: Text('Jenis Surat')),
                      DataColumn(label: Text('Status')),
                      DataColumn(label: Text('Tanggal')),
                      DataColumn(label: Text('Aksi')),
                    ],
                    rows: [
                      _dataRow(1, 'Anggun', 'Keluhan', 'Diproses', '23-03-24'),
                      _dataRow(2, 'Vira', 'Keluhan', 'Selesai', '25-09-25'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // Bottom navigation bar
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue[800],
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle, size: 35),
            label: 'Pengaduan Saya',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  // Widget kartu info
  Widget _infoCard({required IconData icon, required String title, required String value}) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.blue[800]),
            const SizedBox(height :8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height : 4),
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  // Baris tabel
  static DataRow _dataRow(int no, String nama, String jenis, String status, String tanggal) {
    return DataRow(cells: [
      DataCell(Text(no.toString())),
      DataCell(Text(nama)),
      DataCell(Text(jenis)),
      DataCell(Text(status)),
      DataCell(Text(tanggal)),
      DataCell(
        TextButton(
          onPressed: () {},
          child: const Text('Lihat Detail', style: TextStyle(color: Colors.blue)),
        ),
      ),
    ]);
  }
}
