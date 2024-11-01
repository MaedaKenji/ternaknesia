import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
        child: Column(
          children: [
            // Gambar Profil
            const CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(
                  'https://preview.redd.it/handsome-squidward-v0-x0y0u0c010bb1.jpg?width=640&crop=smart&auto=webp&s=021b409d0c1b121b7f109ffbc41ee3d2ed23f049'), // Gambar profil dari URL
            ),
            const SizedBox(height: 10),
            // Nama Pengguna
            const Text(
              'ATHA RAFIFI',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            // Informasi Email
            _buildInfoRow(
              icon: Icons.email,
              label: 'Email',
              value: 'athahahaha@gmail.com',
            ),
            const SizedBox(height: 20),
            // Informasi Telepon
            _buildInfoRow(
              icon: Icons.phone,
              label: 'Phone',
              value: '081 2123 5567',
            ),
            const SizedBox(height: 20),
            // Informasi Role
            _buildInfoRow(
              icon: Icons.work,
              label: 'Role',
              value: 'Peternak',
            ),
            const SizedBox(height: 20),
            // Informasi Lokasi Kandang
            _buildInfoRow(
              icon: Icons.location_on,
              label: 'Lokasi Kandang',
              value: 'Jl. Sawah Mangga 5 / Y-2',
            ),
            const SizedBox(height: 20),
            // Informasi Email Kedua (Opsional)
            _buildInfoRow(
              icon: Icons.email,
              label: 'Email',
              value: 'athahahaha@gmail.com',
            ),
            const SizedBox(height: 30),
            // Tombol Edit Profil
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  // Tambahkan aksi edit profil di sini
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Color(0xFFC35804),
                  side: const BorderSide(color: Color(0xFFC35804)),
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 30.0),
                ),
                child: const Text(
                  'EDIT PROFIL',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk membuat baris informasi
  Widget _buildInfoRow(
      {required IconData icon, required String label, required String value}) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                value,
                style: const TextStyle(fontSize: 16),
              ),
              const Divider(thickness: 1, color: Colors.grey),
            ],
          ),
        ),
      ],
    );
  }
}
