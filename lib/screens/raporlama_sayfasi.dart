import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/tarih_provider.dart';

class RaporlamaSayfasi extends StatefulWidget {
  const RaporlamaSayfasi({Key? key}) : super(key: key);

  @override
  State<RaporlamaSayfasi> createState() => _RaporlamaSayfasiState();
}

class _RaporlamaSayfasiState extends State<RaporlamaSayfasi> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  Future<Map<String, List<Map<String, dynamic>>>> _verileriGetir(
      DateTimeRange aralik) async {
    Map<String, List<Map<String, dynamic>>> tumVeriler = {};

    DateTime baslangic = aralik.start;
    DateTime bitis = aralik.end;

    for (DateTime gun = baslangic;
        !gun.isAfter(bitis);
        gun = gun.add(const Duration(days: 1))) {
      String gunStr = DateFormat('yyyy-MM-dd').format(gun);

      DataSnapshot snapshot =
          await _dbRef.child('saatlikOrtalama').child(gunStr).get();

      if (snapshot.exists) {
        Map<String, dynamic> saatlikVeriler =
            Map<String, dynamic>.from(snapshot.value as Map);

        List<Map<String, dynamic>> saatVeriListesi = [];

        for (int saat = 0; saat < 24; saat++) {
          String saatStr = saat.toString().padLeft(2, '0') + ':00';

          if (saatlikVeriler.containsKey(saatStr)) {
            Map<String, dynamic> tekSaatVerisi =
                Map<String, dynamic>.from(saatlikVeriler[saatStr]);

            double sicaklik = _toDouble(tekSaatVerisi['temperature_dht']);
            double nem = _toDouble(tekSaatVerisi['humidity']);
            double basinc = _toDouble(tekSaatVerisi['pressure']);

            saatVeriListesi.add({
              'saat': saat,
              'sicaklik': sicaklik,
              'nem': nem,
              'basinc': basinc,
            });
          }
        }

        tumVeriler[DateFormat('dd-MM-yyyy').format(gun)] = saatVeriListesi;
      }
    }

    return tumVeriler;
  }

  double _toDouble(dynamic val) {
    if (val == null) return 0.0;
    if (val is double) return val;
    if (val is int) return val.toDouble();
    if (val is String) return double.tryParse(val) ?? 0.0;
    return 0.0;
  }

  Future<void> _tarihAraligiSec(BuildContext context) async {
    final now = DateTime.now();
    final provider = Provider.of<TarihProvider>(context, listen: false);

    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: now,
      initialDateRange: provider.secilenAralik ??
          DateTimeRange(start: now.subtract(const Duration(days: 7)), end: now),
    );

    if (picked != null) {
      provider.setSecilenAralik(picked);
    }
  }

  String _tarihBasligi(DateTimeRange aralik) {
    final baslangicStr = DateFormat('dd.MM.yyyy').format(aralik.start);
    final bitisStr = DateFormat('dd.MM.yyyy').format(aralik.end);
    if (baslangicStr == bitisStr) {
      return '$baslangicStr tarihli grafiğiniz';
    } else {
      return '$baslangicStr - $bitisStr tarihli grafikleriniz';
    }
  }

  @override
  Widget build(BuildContext context) {
    final tarihProvider = Provider.of<TarihProvider>(context);
    final secilenTarihAraligi = tarihProvider.secilenAralik;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            snap: true,
            backgroundColor: Colors.white,
            elevation: 0,
            title: secilenTarihAraligi == null
                ? Text(
                    'Lütfen tarih aralığı seçiniz',
                    style: TextStyle(
                      fontWeight: FontWeight.w200,
                      fontStyle: FontStyle.normal,
                      fontSize: 14,
                      letterSpacing: 1.5,
                      foreground: Paint()
                        ..shader = const LinearGradient(
                          colors: <Color>[
                            Colors.black,
                            Colors.black,
                          ],
                        ).createShader(
                            const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                      shadows: [
                        Shadow(
                          color: Colors.deepPurple.shade100.withOpacity(0.7),
                          offset: const Offset(1, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  )
                : Text(
                    _tarihBasligi(secilenTarihAraligi),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
            actions: [
              IconButton(
                icon: Icon(Icons.date_range, color: Colors.deepPurple.shade400),
                onPressed: () => _tarihAraligiSec(context),
                tooltip: 'Tarih Aralığı Seç',
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: secilenTarihAraligi == null
                  ? const Center(child: Text(''))
                  : FutureBuilder<Map<String, List<Map<String, dynamic>>>>(
                      future: _verileriGetir(secilenTarihAraligi),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Hata: ${snapshot.error}'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(
                              child: Text(
                                  'Seçilen tarih aralığında veri bulunamadı.'));
                        }

                        final veriMap = snapshot.data!;
                        final tarihListesi = veriMap.keys.toList()
                          ..sort((a, b) {
                            DateTime dtA = DateFormat('dd-MM-yyyy').parse(a);
                            DateTime dtB = DateFormat('dd-MM-yyyy').parse(b);
                            return dtA.compareTo(dtB);
                          });

                        return Column(
                          children: tarihListesi.map((tarihStr) {
                            final veriListesi = veriMap[tarihStr]!;
                            return _veriKutusu(tarihStr, veriListesi);
                          }).toList(),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _veriKutusu(String tarih, List<Map<String, dynamic>> veriListesi) =>
      Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue.shade200),
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.blue.shade50,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat('dd.MM.yyyy')
                  .format(DateFormat('dd-MM-yyyy').parse(tarih)),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            _buildLineChart('Sıcaklık (°C)', veriListesi, 0, 50,
                Colors.redAccent, '°C', (item) => item['sicaklik'],
                tooltipLabel: 'Sıcaklık'),
            const SizedBox(height: 20),
            _buildLineChart('Nem (%)', veriListesi, 0, 100, Colors.green, '%',
                (item) => item['nem'],
                tooltipLabel: 'Nem'),
            const SizedBox(height: 20),
            _buildLineChart('Basınç (hPa)', veriListesi, 900, 1300, Colors.blue,
                'hPa', (item) => item['basinc'],
                yInterval: 100, tooltipLabel: 'Basınç'),
          ],
        ),
      );

  Widget _buildLineChart(
    String baslik,
    List<Map<String, dynamic>> veriListesi,
    double minY,
    double maxY,
    Color color,
    String yAxisSuffix,
    double Function(Map<String, dynamic>) valueSelector, {
    double yInterval = 10,
    required String tooltipLabel,
  }) {
    final spots = veriListesi
        .map((e) => FlSpot((e['saat'] as int).toDouble(), valueSelector(e)))
        .toList();

    return SizedBox(
      height: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(baslik,
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: color, fontSize: 16)),
          const SizedBox(height: 6),
          Expanded(
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: 23,
                minY: minY,
                maxY: maxY,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: color,
                    barWidth: 3,
                    dotData: FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: color.withOpacity(0.3),
                    ),
                  ),
                ],
                gridData: FlGridData(
                  show: true,
                  horizontalInterval: yInterval,
                  verticalInterval: 3,
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 3,
                      getTitlesWidget: (value, meta) {
                        final hour = value.toInt().toString().padLeft(2, '0');
                        return Text('$hour.00');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: yInterval,
                      reservedSize: 35,
                      getTitlesWidget: (value, meta) {
                        // Sadece basınç grafiğinde yAxisSuffix gösterme
                        final showSuffix = yAxisSuffix != 'hPa';
                        return Text(
                          '${value.toInt()}${showSuffix ? yAxisSuffix : ''}',
                          softWrap: false,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                        );
                      },
                    ),
                  ),
                  rightTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.black26),
                ),
                lineTouchData: LineTouchData(
                  enabled: true,
                  handleBuiltInTouches: true,
                  touchTooltipData: LineTouchTooltipData(
                    tooltipBgColor: Colors.black87,
                    tooltipRoundedRadius: 8,
                    tooltipPadding: const EdgeInsets.all(8),
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        final hour =
                            spot.x.toInt().toString().padLeft(2, '0') + ':00';
                        final value = spot.y.toStringAsFixed(1);

                        return LineTooltipItem(
                          'Saat: $hour\n$tooltipLabel: $value$yAxisSuffix',
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
