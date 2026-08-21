import '../datasources/base/scan_datasource.dart';
import '../models/scan_sample.dart';
import 'dart:io';

class ScanRepository {
  final ScanDataSource _datasource;

  ScanRepository(this._datasource);

  Future<ScanSample> predictImage(File image) {
    return _datasource.predictImage(image);
  }
}