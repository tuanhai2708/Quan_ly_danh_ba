import 'package:flutter_test/flutter_test.dart';
import 'package:quan_ly_danh_ba/contact.dart';

void main() {
  test('Tên không được bỏ trống hoặc chỉ có khoảng trắng', () {
    expect(validateName(null), isNotNull);
    expect(validateName('   '), isNotNull);
    expect(validateName(' Nguyễn Văn An '), isNull);
  });

  test('Điện thoại phải đúng định dạng và không trùng', () {
    final phones = {'0901234567'};
    for (final phone in [
      null,
      '',
      '09123',
      '09123456789',
      '1912345678',
      '091234567a',
      '+84912345678',
    ]) {
      expect(validatePhone(phone, phones), isNotNull, reason: '$phone');
    }
    expect(
      validatePhone('0901234567', phones),
      'Số điện thoại đã tồn tại trong danh bạ',
    );
    expect(validatePhone(' 0912345678 ', phones), isNull);
  });
}
