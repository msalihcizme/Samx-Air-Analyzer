import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_database/firebase_database.dart';
import '../providers/tarih_provider.dart';
import '../widgets/gunluk_veri_karti.dart';
import '../data_models/gunluk_ortalama_veri_modeli.dart';
import '../data_models/saatlik_ortalama_veri_modeli.dart';

class GunlukVeriSayfasi extends StatefulWidget {
  const GunlukVeriSayfasi({super.key});

  @override
  State<GunlukVeriSayfasi> createState() => _GunlukVeriSayfasiState();
}

class _GunlukVeriSayfasiState extends State<GunlukVeriSayfasi> {
  final dbRef = FirebaseDatabase.instance.ref();
  GunlukOrtalama? gunlukOrtalama;
  List<SaatlikOrtalama> saatlikVeriler = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _verileriGetir();
  }

  Future<void> _verileriGetir() async {
    setState(() {
      isLoading = true;
    });

    final secilenTarih = Provider.of<TarihProvider>(context, listen: false).secilenGun;
    final tarihStr = "${secilenTarih.year.toString().padLeft(4, '0')}-${secilenTarih.month.toString().padLeft(2, '0')}-${secilenTarih.day.toString().padLeft(2, '0')}";

    // Günlük Ortalama Verisi
    final gunlukSnapshot = await dbRef.child('gunlukOrtalama').child(tarihStr).get();
    if (gunlukSnapshot.exists) {
      gunlukOrtalama = GunlukOrtalama.fromMap(gunlukSnapshot.value as Map<dynamic, dynamic>);
    } else {
      gunlukOrtalama = null;
    }

    // Saatlik Ortalama Verileri
    final saatlikSnapshot = await dbRef.child('saatlikOrtalama').child(tarihStr).get();
    if (saatlikSnapshot.exists) {
      final data = saatlikSnapshot.value as Map<dynamic, dynamic>;
      List<SaatlikOrtalama> tempSaatlik = [];
      data.forEach((key, value) {
        tempSaatlik.add(SaatlikOrtalama.fromMap(key.toString(), value as Map<dynamic, dynamic>));
      });
      tempSaatlik.sort((a, b) => a.hour.compareTo(b.hour));
      saatlikVeriler = tempSaatlik;
    } else {
      saatlikVeriler = [];
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _tarihSec(BuildContext context) async {
    final provider = Provider.of<TarihProvider>(context, listen: false);
    final secilen = await showDatePicker(
      context: context,
      initialDate: provider.secilenGun,
      firstDate: DateTime(2023, 1, 1),
      lastDate: DateTime.now(),
      locale: const Locale('tr'),
    );
    if (secilen != null) {
      provider.setSecilenGun(secilen);
      await _verileriGetir();
    }
  }

  String _saatFormatla(String hourKey) {
    // Örn: "00:00" veya "01-00" → "00.00" formatına çevir
    if (hourKey.length >= 5) {
      return hourKey.substring(0, 5).replaceAll('-', '.').replaceAll(':', '.');
    } else {
      return hourKey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final secilenTarih = Provider.of<TarihProvider>(context).secilenGun;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          margin: const EdgeInsets.only(bottom: 24),
          child: ListTile(
            leading: const Icon(Icons.calendar_today, color: Colors.deepPurple),
            title: Text(
              "${secilenTarih.day.toString().padLeft(2, '0')}.${secilenTarih.month.toString().padLeft(2, '0')}.${secilenTarih.year}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            trailing: TextButton(
              onPressed: () => _tarihSec(context),
              child: const Text("Tarih Seç"),
            ),
          ),
        ),
        if (gunlukOrtalama != null)
          Card(
            elevation: 6,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            margin: const EdgeInsets.only(bottom: 24),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text("Günlük Ortalama", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _statColumn("Sıcaklık", gunlukOrtalama!.temperatureDht, "°C", Icons.thermostat),
                      _statColumn("Nem", gunlukOrtalama!.humidity, "%", Icons.water_drop),
                      _statColumn("Basınç", gunlukOrtalama!.pressure, "hPa", Icons.speed),
                    ],
                  )
                ],
              ),
            ),
          )
        else
          const Center(child: Text("Günlük ortalama veri bulunamadı")),
        const Text("Saatlik Ortalamalar", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        saatlikVeriler.isNotEmpty
            ? Wrap(
                spacing: 12,
                runSpacing: 12,
                children: saatlikVeriler.map((e) {
                  return veriKarti_2(
                    saat: _saatFormatla(e.hour),
                    sicaklik: e.temperatureDht.toStringAsFixed(1),
                    nem: e.humidity.toStringAsFixed(1),  
                    basinc: e.pressure.toStringAsFixed(1),
                  );
                }).toList(),
              )
            : const Center(child: Text("Saatlik ortalama veri bulunamadı")),
      ],
    );
  }

  Widget _statColumn(String label, double value, String unit, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 28, color: Colors.deepPurple),
        const SizedBox(height: 4),
        Text("${value.toStringAsFixed(1)} $unit", style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(label),
      ],
    );
  }
}
