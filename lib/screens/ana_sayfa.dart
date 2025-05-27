import 'package:flutter/material.dart';
import 'package:samx_flutter/screens/anlik_veri_sayfasi.dart';
import 'package:samx_flutter/screens/gunluk_veri_sayfasi.dart';
import 'package:samx_flutter/screens/raporlama_sayfasi.dart';

class AnaSayfa extends StatefulWidget {
  const AnaSayfa({super.key});

  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa>
    with SingleTickerProviderStateMixin {
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
        toolbarHeight: 110,
        centerTitle: true,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.grey.shade100.withOpacity(0.5),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.deepPurple.shade200.withOpacity(0.6),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurple.shade100.withOpacity(0.25),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [
                    Colors.deepPurple.shade400.withOpacity(0.8),
                    Colors.deepPurple.shade700.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(
                    Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                child: Text(
                  "SAMX",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins',
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Hava Durumu İstasyonları",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Poppins',
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.deepPurple.shade400,
          indicatorWeight: 2,
          labelColor: Colors.deepPurple.shade500,
          unselectedLabelColor: Colors.grey.shade500,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            fontFamily: 'Poppins',
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 13,
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
