class SaatlikOrtalama {
  final String hour;  
  final double humidity;
  final double pressure;
  final double temperatureDht;
  final int? timestamp;  

  SaatlikOrtalama({
    required this.hour,
    required this.humidity,
    required this.pressure,
    required this.temperatureDht,
    this.timestamp,
  });

  factory SaatlikOrtalama.fromMap(String hourKey, Map<dynamic, dynamic> map) {
    return SaatlikOrtalama(
      hour: hourKey,
      humidity: (map['humidity'] ?? 0).toDouble(),
      pressure: (map['pressure'] ?? 0).toDouble(),
      temperatureDht: (map['temperature_dht'] ?? 0).toDouble(),
      timestamp: map['timestamp'] != null ? (map['timestamp'] as int) : null,
    );
  }
}
