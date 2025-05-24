import 'package:flutter/material.dart';
import 'package:samx_flutter/screens/anlik_veri_sayfasi.dart';
import 'package:samx_flutter/screens/gunluk_veri_sayfasi.dart';
import 'package:samx_flutter/screens/raporlama_sayfasi.dart';

class AnaSayfa extends StatefulWidget {
  const AnaSayfa({super.key});

  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 100,
        centerTitle: true,
        title: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "SAMX Hava Durumu İstasyonları",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Color.fromARGB(255, 14, 13, 15),
                fontFamily: 'Poppins',
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 6),
            Text(
              "Anlık ve Günlük Hava Verileri",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color.fromARGB(255, 14, 13, 15),
                fontFamily: 'Poppins',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.deepPurple.shade400,
          indicatorWeight: 3,
          labelColor: Colors.deepPurple.shade600,
          unselectedLabelColor: Colors.deepPurple.shade200,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            fontFamily: 'Poppins',
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 14,
            fontFamily: 'Poppins',
          ),
          tabs: const [
            Tab(icon: Icon(Icons.access_time), text: "Anlık"),
            Tab(icon: Icon(Icons.calendar_today), text: "Günlük"),
            Tab(icon: Icon(Icons.bar_chart), text: "Raporlar"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          AnlikVeriSayfasi(),
          GunlukVeriSayfasi(),
          RaporlamaSayfasi(),
        ],
      ),
    );
  }
}
