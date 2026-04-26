import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final supabase = Supabase.instance.client;
  late Future<List<Map<String, dynamic>>> _historyFuture;

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  void _fetchHistory() {
    final userId = supabase.auth.currentUser!.id;
    _historyFuture = supabase
        .from('bookings')
        .select('*, tickets(bus_name, route, departure_time)')
        .eq('user_id', userId)
        .order('created_at', ascending: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat Pesanan", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _historyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator(color: Colors.purple));
          if (snapshot.hasError) return Center(child: Text("Error: ${snapshot.error}"));
          if (!snapshot.hasData || snapshot.data!.isEmpty) return const Center(child: Text("Belum ada riwayat pesanan."));

          final bookings = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              final ticket = booking['tickets']; 
              
              final date = DateTime.parse(booking['created_at']).toLocal();
              final dateString = "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}";

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 2,
                child: InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                      builder: (context) {
                        List<dynamic> names = booking['passenger_names'] ?? [];
                        // Fix: Ditambah SingleChildScrollView biar bisa di-scroll kalau namanya banyak
                        return SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Detail E-Ticket", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                const Divider(height: 30),
                                Text("Bus: ${ticket['bus_name']} (${ticket['route']})", style: const TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                const Text("Daftar Penumpang:", style: TextStyle(color: Colors.grey)),
                                ...names.map((name) => Text("- $name", style: const TextStyle(fontSize: 16))),
                                const Divider(height: 30),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Subtotal:", style: TextStyle(color: Colors.grey)),
                                    Text("Rp ${booking['total_price']}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.purple)),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () => Navigator.pop(context),
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                                    child: const Text("TUTUP", style: TextStyle(color: Colors.white)),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(ticket['bus_name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const Text("LUNAS", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text("Rute: ${ticket['route']} (${ticket['departure_time']})", style: const TextStyle(color: Colors.grey)),
                        const SizedBox(height: 4),
                        Text("Waktu Transaksi: $dateString", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                        const Divider(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Total: Rp ${booking['total_price']}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.purple)),
                            const Text("Lihat Detail >", style: TextStyle(color: Colors.purple, fontSize: 12, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}