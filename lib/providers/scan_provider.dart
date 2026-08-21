import 'package:flutter/material.dart';
import '../data/models/scan_sample.dart';
import '../data/repositories/scan_repository.dart';
import 'dart:io';

enum ScanState { idle, scanning, done, error }

class ScanProvider extends ChangeNotifier {
  final ScanRepository _repository;

  ScanProvider(this._repository);

  ScanState _state = ScanState.idle;
  ScanSample? _lastSample;

  ScanState get state => _state;
  ScanSample? get lastSample => _lastSample;
  bool get isScanning => _state == ScanState.scanning;

  Future<ScanSample?> performScan(File image) async {
  _state = ScanState.scanning;
  _lastSample = null;
  notifyListeners();

  try {
    _lastSample = await _repository.predictImage(image);

    print("===== HASIL SCAN =====");
    print(_lastSample);

    _state = ScanState.done;
    notifyListeners();

    return _lastSample;
  } catch (e, stackTrace) {
    print("===== ERROR SCAN =====");
    print(e);
    print(stackTrace);

    _state = ScanState.error;
    notifyListeners();

    return null;
  }
}

  void reset() {
    _state = ScanState.idle;
    _lastSample = null;
    notifyListeners();
  }
}
