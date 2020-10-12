import 'package:flutter_test/flutter_test.dart';
import 'package:tablethings/services/exceptions.dart';

void main() {
  test('Can catch exceptions?', () async {
    bool caught = false;

    Future<void> fut() async {
      throw TablethingsAPIException(500, []);
    }

    try {
      await fut();
    } on TablethingsAPIException catch (e) {
      caught = true;
    } catch (e) {
      fail('e');
    }

    expect(caught, true);
  });
}
