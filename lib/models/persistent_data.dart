import 'package:tablething/models/establishment/establishment.dart';
import 'package:tablething/models/fetchable_package.dart';
import 'package:tablething/services/stripe/payment_method.dart';
import 'package:tablething/services/tablething/user.dart';

/// Used to store data across pages/routes
class PersistentData {
  String _selectedEstablishmentId;
  String _selectedTableId;
  bool _didScanCode;

  PaymentMethod _selectedPaymentMethod;

  String get selectedEstablishmentId => _selectedEstablishmentId;

  String get selectedTableId => _selectedTableId;

  bool get didScanCode => _didScanCode;

  PaymentMethod get selectedPaymentMethod => _selectedPaymentMethod;

  PersistentData();

  void setPaymentMethod(PaymentMethod paymentMethod) {
    _selectedPaymentMethod = paymentMethod;
  }

  void setScannedData(selectedEstablishmentId, selectedTableId, didScanCode) {
    _selectedEstablishmentId = selectedEstablishmentId;
    _selectedTableId = selectedTableId;
    _didScanCode = didScanCode;
  }
}
