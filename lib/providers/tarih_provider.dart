import 'package:flutter/material.dart';

class TarihProvider with ChangeNotifier {
  DateTimeRange? _secilenAralik;
  DateTime _secilenGun = DateTime.now();  // Günlük veri sayfası için

  DateTimeRange? get secilenAralik => _secilenAralik;

  DateTime get secilenGun => _secilenGun; // Bu eksikti, ekledik

  void setSecilenAralik(DateTimeRange yeniAralik) {
    _secilenAralik = yeniAralik;
    notifyListeners();
  }

  void setSecilenGun(DateTime yeniGun) {
    _secilenGun = yeniGun;
    notifyListeners();
  }
}
