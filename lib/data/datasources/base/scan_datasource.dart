import '../../models/scan_sample.dart';
import 'dart:io';

abstract interface class ScanDataSource {
  Future<ScanSample> predictImage(File image);
}