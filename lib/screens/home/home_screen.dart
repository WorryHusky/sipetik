// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sipetik/routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final supabase = Supabase.instance.client;
  late Future<List<Map<String, dynamic>>> _ticketsFuture;
  String? userName;

  @override
  void initState() {
    super.initState();
    // Mengambil data tiket terbaru
    _ticketsFuture = supabase.from('tickets').select().order('created_at', ascending: false);
    // Mengambil nama user dari metadata Supabase Auth
    userName = supabase.auth.currentUser?.userMetadata?['name'] ?? "User";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple,
      appBar: AppBar(
        backgroundColor: Colors.purple,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Halo,", style: TextStyle(color: Colors.white70, fontSize: 14)),
            Text(userName ?? "User", style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          // Tombol Riwayat Pesanan
          IconButton(
            icon: const Icon(Icons.receipt_long, color: Colors.white),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.history),
          ),
          // Tombol Profil (Edit Nama & Logout)
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.white),
            onPressed: () {
              final editNameController = TextEditingController(text: userName);
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  title: Row(
                    children: [
                      CircleAvatar(backgroundColor: Colors.purple.shade100, child: const Icon(Icons.person, color: Colors.purple)),
                      const SizedBox(width: 12),
                      const Text("Profil Akun", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    ],
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Email: ${supabase.auth.currentUser?.email ?? '-'}", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      const SizedBox(height: 12),
                      TextField(
                        controller: editNameController,
                        decoration: const InputDecoration(labelText: "Nama Tampilan", border: OutlineInputBorder()),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context), 
                      child: const Text("BATAL", style: TextStyle(color: Colors.grey))
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                      onPressed: () async {
                        final newName = editNameController.text.trim();
                        if (newName.isNotEmpty) {
                          try {
                            // Update nama di metadata Supabase Auth
                            await supabase.auth.updateUser(UserAttributes(data: {'name': newName}));
                            setState(() => userName = newName);
                            if (mounted) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Nama berhasil diperbarui!")));
                            }
                          } catch (e) {
                            if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal update nama: $e")));
                          }
                        }
                      },
                      child: const Text("SIMPAN", style: TextStyle(color: Colors.white)),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade50, elevation: 0),
                      onPressed: () async {
                        await supabase.auth.signOut();
                        if (mounted) Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
                      },
                      child: const Text("LOGOUT", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        ),
        child: RefreshIndicator(
          onRefresh: () async {
            setState(() {
              _ticketsFuture = supabase.from('tickets').select().order('created_at', ascending: false);
            });
          },
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const Text("Jadwal Populer", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              FutureBuilder<List<Map<String, dynamic>>>(
                future: _ticketsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator(color: Colors.purple));
                  if (snapshot.hasError) return Center(child: Text("Error: ${snapshot.error}"));
                  if (!snapshot.hasData || snapshot.data!.isEmpty) return const Center(child: Text("Belum ada tiket tersedia."));

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final ticket = snapshot.data![index];
                      final seats = ticket['seats_available'] ?? 30; 

                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 3,
                        shadowColor: Colors.purple.withOpacity(0.1),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(ticket['bus_name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                    const SizedBox(height: 6),
                                    Text(ticket['route'], style: const TextStyle(color: Colors.purple, fontWeight: FontWeight.bold, fontSize: 14)),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        const Icon(Icons.access_time, size: 14, color: Colors.grey),
                                        const SizedBox(width: 4),
                                        Text(ticket['departure_time'], style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(Icons.event_seat, size: 14, color: seats < 10 ? Colors.red : Colors.orange),
                                        const SizedBox(width: 4),
                                        Text(
                                          "Sisa $seats kursi", 
                                          style: TextStyle(color: seats < 10 ? Colors.red : Colors.orange, fontSize: 12, fontWeight: FontWeight.bold)
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text("Rp ${ticket['price']}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                  const SizedBox(height: 12),
                                  ElevatedButton(
                                    onPressed: () => Navigator.pushNamed(context, AppRoutes.booking, arguments: ticket),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.purple,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    ),
                                    child: const Text("Pesan", style: TextStyle(color: Colors.white)),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}