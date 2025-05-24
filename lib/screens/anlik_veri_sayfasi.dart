import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../widgets/anlik_veri_karti.dart';

class AnlikVeriSayfasi extends StatefulWidget {
  const AnlikVeriSayfasi({super.key});

  @override
  State<AnlikVeriSayfasi> createState() => _AnlikVeriSayfasiState();
}

class _AnlikVeriSayfasiState extends State<AnlikVeriSayfasi> {
  final dbRef = FirebaseDatabase.instance.ref().child("sensorData");
  double? sicaklik, nem, basinc;
  String? yagmur, toprak;

  @override
  void initState() {
    super.initState();
    dbRef.onValue.listen((e) {
      final m = e.snapshot.value as Map?;
      if (m != null && m.isNotEmpty) {
        final last = m.entries.last.value;
        setState(() {
          sicaklik = (last['temperature_dht'] ?? 0).toDouble();
          nem = (last['humidity'] ?? 0).toDouble();
          basinc = (last['pressure'] ?? 0).toDouble();
          yagmur = (last['rain'] ?? "Hesaplanamadı").toString();
          toprak = (last['soil'] ?? "Hesaplanamadı").toString();
        });
      }
    });
  }

  String _getWeekDayName(DateTime dt) {
    const weekdays = [
      "Pazartesi",
      "Salı",
      "Çarşamba",
      "Perşembe",
      "Cuma",
      "Cumartesi",
      "Pazar"
    ];
    return weekdays[dt.weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final weekDayName = _getWeekDayName(now);
    final time = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
    final date = "${now.day.toString().padLeft(2, '0')}.${now.month.toString().padLeft(2, '0')}.${now.year}";

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            floating: true,
            snap: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: Column(
              children: [
                Text(
                  "$weekDayName • $time",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[900],
                  ),
                ),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  VeriKarti("Sıcaklık", sicaklik, "°C", Icons.thermostat, Colors.redAccent),
                  const SizedBox(height: 16),
                  VeriKarti("Nem", nem, "%", Icons.water_drop, Colors.blueAccent),
                  const SizedBox(height: 16),
                  VeriKarti("Basınç", basinc, "hPa", Icons.speed, Colors.green),
                  const SizedBox(height: 16),
                  VeriKartiDegeriMetinOlanlar("Yağmur", yagmur, Icons.umbrella, Colors.indigo),
                  const SizedBox(height: 16),
                  VeriKartiDegeriMetinOlanlar("Toprak", toprak, Icons.grass, Colors.brown),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
