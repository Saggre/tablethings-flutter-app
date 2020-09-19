/// Checks on whether objects are null/empty/etc.
extension Nulls on Object {
  /// The following values are considered to be empty:
  /// "" (an empty string)
  /// 0 (0 as an integer)
  /// 0.0 (0 as a float)
  /// "0" (0 as a string)
  /// null
  /// false
  /// [] (an empty array)
  bool isAllEmpty() => this == null || this == '' || this == 0 || this == '0' || this == 0.0 || this == [] || this == false;
}
