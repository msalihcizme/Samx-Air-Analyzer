import 'package:flutter/material.dart';

class veriKarti_2 extends StatelessWidget {
  final String saat;
  final String sicaklik;
  final String nem;
  final String basinc;

  const veriKarti_2({
    super.key,
    required this.saat,
    required this.sicaklik,
    required this.nem,
    required this.basinc,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.deepPurple.shade100, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            saat,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple.shade700,
            ),
          ),
          const SizedBox(height: 10),
          _iconSatiri(Icons.thermostat, "$sicaklik °C", Colors.redAccent),
          const SizedBox(height: 6),
          _iconSatiri(Icons.water_drop, "$nem %", Colors.blueAccent),
          const SizedBox(height: 6),
          _iconSatiri(Icons.speed, "$basinc hPa", Colors.teal),
        ],
      ),
    );
  }

  Widget _iconSatiri(IconData icon, String metin, Color renk) {
    return Row(
      children: [
        Icon(icon, size: 18, color: renk),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            metin,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
