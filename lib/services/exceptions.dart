import 'package:tablethings/models/tablethings/tablethings_error.dart';

class TablethingsAPIException implements Exception {
  int code;
  List<TablethingsError> errors;

  TablethingsAPIException(this.code, this.errors);
}
