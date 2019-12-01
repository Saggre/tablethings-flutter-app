import 'package:tablething/models/establishment/establishment.dart';
import 'package:tablething/models/fetchable_package.dart';

/// Used to store data across pages/routes
class PersistentData {
  FetchablePackage<String, Establishment> _selectedEstablishment;
  String _selectedTableId;
  bool _didScanCode;

  FetchablePackage<String, Establishment> get selectedEstablishment => _selectedEstablishment;

  String get selectedTableId => _selectedTableId;

  bool get didScanCode => _didScanCode;

  PersistentData();

  void setData(selectedEstablishment, selectedTableId, didScanCode) {
    this._selectedEstablishment = selectedEstablishment;
    this._selectedTableId = selectedTableId;
    this._didScanCode = didScanCode;
  }
}
