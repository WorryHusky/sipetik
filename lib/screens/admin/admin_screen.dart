// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sipetik/routes.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final supabase = Supabase.instance.client;
  late Future<List<Map<String, dynamic>>> _ticketsFuture;

  @override
  void initState() {
    super.initState();
    _fetchTickets();
  }

  void _fetchTickets() {
    setState(() {
      _ticketsFuture = supabase.from('tickets').select().order('created_at', ascending: false);
    });
  }

  // Fungsi memunculkan form Tambah/Edit Jadwal
  void _showTicketForm({Map<String, dynamic>? existingTicket}) {
    final busController = TextEditingController(text: existingTicket?['bus_name']);
    final routeController = TextEditingController(text: existingTicket?['route']);
    final timeController = TextEditingController(text: existingTicket?['departure_time']);
    final priceController = TextEditingController(text: existingTicket?['price']?.toString());
    final seatsController = TextEditingController(text: existingTicket?['seats_available']?.toString() ?? '30');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(existingTicket == null ? "Tambah Jadwal Baru" : "Edit Jadwal"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: busController, decoration: const InputDecoration(labelText: "Nama Bus")),
              TextField(controller: routeController, decoration: const InputDecoration(labelText: "Rute (SBY - JKT)")),
              TextField(controller: timeController, decoration: const InputDecoration(labelText: "Jam Berangkat")),
              TextField(controller: priceController, decoration: const InputDecoration(labelText: "Harga"), keyboardType: TextInputType.number),
              TextField(controller: seatsController, decoration: const InputDecoration(labelText: "Jumlah Kursi"), keyboardType: TextInputType.number),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
            onPressed: () async {
              final data = {
                'bus_name': busController.text,
                'route': routeController.text,
                'departure_time': timeController.text,
                'price': int.tryParse(priceController.text) ?? 0,
                'seats_available': int.tryParse(seatsController.text) ?? 30,
              };

              if (existingTicket == null) {
                await supabase.from('tickets').insert(data); // Create
              } else {
                await supabase.from('tickets').update(data).eq('id', existingTicket['id']); // Update
              }

              if (mounted) Navigator.pop(context);
              _fetchTickets(); // Refresh list
            },
            child: const Text("Simpan", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _deleteTicket(String id) async {
    await supabase.from('tickets').delete().eq('id', id);
    _fetchTickets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Panel - Jadwal", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black87,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await supabase.auth.signOut();
              if (mounted) Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
            },
          )
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _ticketsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (!snapshot.hasData || snapshot.data!.isEmpty) return const Center(child: Text("Belum ada jadwal."));

          final tickets = snapshot.data!;
          return ListView.builder(
            itemCount: tickets.length,
            itemBuilder: (context, index) {
              final ticket = tickets[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text("${ticket['bus_name']} (${ticket['route']})", style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("Rp ${ticket['price']} | Sisa ${ticket['seats_available']} kursi"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _showTicketForm(existingTicket: ticket)),
                      IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _deleteTicket(ticket['id'])),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        onPressed: () => _showTicketForm(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}