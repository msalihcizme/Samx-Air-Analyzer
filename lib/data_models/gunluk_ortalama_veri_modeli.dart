class GunlukOrtalama {
  final String date;
  final double humidity;
  final double pressure;
  final double temperatureDht;

  GunlukOrtalama({
    required this.date,
    required this.humidity,
    required this.pressure,
    required this.temperatureDht,
  });

  factory GunlukOrtalama.fromMap(Map<dynamic, dynamic> map) {
    return GunlukOrtalama(
      date: map['date'] ?? '',
      humidity: (map['humidity'] ?? 0).toDouble(),
      pressure: (map['pressure'] ?? 0).toDouble(),
      temperatureDht: (map['temperature_dht'] ?? 0).toDouble(),
    );
  }
}
