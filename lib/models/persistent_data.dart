import 'package:tablething/models/establishment/establishment.dart';
import 'package:tablething/models/fetchable_package.dart';
import 'package:tablething/services/stripe/payment_method.dart';
import 'package:tablething/services/tablething/user.dart';

/// Used to store data across pages/routes
class PersistentData {
  FetchablePackage<String, Establishment> _selectedEstablishment;
  String _selectedTableId;
  bool _didScanCode;

  PaymentMethod _selectedPaymentMethod;

  FetchablePackage<String, Establishment> get selectedEstablishment => _selectedEstablishment;

  String get selectedTableId => _selectedTableId;

  bool get didScanCode => _didScanCode;

  PaymentMethod get selectedPaymentMethod => _selectedPaymentMethod;

  PersistentData();

  void setPaymentMethod(PaymentMethod paymentMethod) {
    _selectedPaymentMethod = paymentMethod;
  }

  void setScannedData(selectedEstablishment, selectedTableId, didScanCode) {
    _selectedEstablishment = selectedEstablishment;
    _selectedTableId = selectedTableId;
    _didScanCode = didScanCode;
  }
}
