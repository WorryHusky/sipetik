import 'package:flutter/material.dart';
import 'package:sipetik/routes.dart';

class BookingDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> ticket;
  const BookingDetailsScreen({super.key, required this.ticket});

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  final List<TextEditingController> _passengerControllers = [TextEditingController()];

  @override
  Widget build(BuildContext context) {
    int totalPrice = widget.ticket['price'] * _passengerControllers.length;

    return Scaffold(
      backgroundColor: Colors.purple,
      appBar: AppBar(title: const Text("Data Penumpang"), backgroundColor: Colors.purple, foregroundColor: Colors.white),
      body: Container(
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        child: Column(
          children: [
            Text(widget.ticket['bus_name'], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _passengerControllers.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: TextField(
                    controller: _passengerControllers[index],
                    decoration: InputDecoration(labelText: "Nama Penumpang ${index + 1}", border: const OutlineInputBorder()),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total: Rp $totalPrice", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(onPressed: () => setState(() => _passengerControllers.add(TextEditingController())), icon: const Icon(Icons.add_circle, color: Colors.purple, size: 30)),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity, height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                onPressed: () {
                  int availableSeats = widget.ticket['seats_available'] ?? 30;
                  
                  if (_passengerControllers.length > availableSeats) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal: Sisa kursi hanya $availableSeats!')));
                    return; 
                  }

                  List<String> passengerNames = [];
                  for (var controller in _passengerControllers) {
                    if (controller.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal: Nama penumpang wajib diisi!')));
                      return;
                    }
                    passengerNames.add(controller.text.trim());
                  }

                  Navigator.pushNamed(context, AppRoutes.payment, arguments: {
                    'ticket_id': widget.ticket['id'],
                    'passenger_count': _passengerControllers.length,
                    'passenger_names': passengerNames,
                    'total_price': totalPrice,
                    'bus_name': widget.ticket['bus_name']
                  });
                },
                child: const Text("LANJUT KE PEMBAYARAN", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}