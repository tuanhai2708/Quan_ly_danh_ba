import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quan_ly_danh_ba/contacts_page.dart';
import 'package:quan_ly_danh_ba/main.dart';

Future<void> login(WidgetTester tester) async {
  await tester.pumpWidget(const ContactsApp());
  await tester.enterText(find.byType(TextFormField).at(0), 'admin');
  await tester.enterText(find.byType(TextFormField).at(1), '123456');
  await tester.tap(find.text('Đăng nhập'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets(
    'Đăng nhập kiểm tra bỏ trống, sai tài khoản và xóa route đăng nhập',
    (tester) async {
      await tester.pumpWidget(const ContactsApp());
      await tester.tap(find.text('Đăng nhập'));
      await tester.pumpAndSettle();
      expect(find.text('Vui lòng nhập tên đăng nhập'), findsOneWidget);
      expect(find.text('Vui lòng nhập mật khẩu'), findsOneWidget);
      await tester.enterText(find.byType(TextFormField).at(0), 'admin');
      await tester.enterText(find.byType(TextFormField).at(1), 'sai');
      await tester.tap(find.text('Đăng nhập'));
      await tester.pumpAndSettle();
      expect(find.text('Sai tên đăng nhập hoặc mật khẩu'), findsOneWidget);
      await tester.enterText(find.byType(TextFormField).at(1), '123456');
      await tester.tap(find.text('Đăng nhập'));
      await tester.pumpAndSettle();
      expect(find.text('Nguyễn Văn An'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
      expect(find.text('1'), findsOneWidget);
      final context = tester.element(find.byType(ContactsPage));
      expect(Navigator.of(context).canPop(), isFalse);
    },
  );

  testWidgets('Thêm liên hệ kiểm tra dữ liệu và giữ đủ thông tin', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(420, 1100));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await login(tester);
    await tester.tap(find.text('Thêm liên hệ'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Lưu liên hệ'));
    await tester.pumpAndSettle();
    expect(find.text('Vui lòng nhập họ và tên'), findsOneWidget);
    expect(
      find.text('Số điện thoại phải có 10 chữ số và bắt đầu bằng 0'),
      findsOneWidget,
    );
    await tester.enterText(find.byType(TextFormField).at(0), '  Phạm Hà  ');
    await tester.enterText(find.byType(TextFormField).at(1), '0901234567');
    await tester.tap(find.text('Lưu liên hệ'));
    await tester.pumpAndSettle();
    expect(find.text('Số điện thoại đã tồn tại trong danh bạ'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).at(1), '0977777777');
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Công việc').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Nữ'));
    await tester.tap(find.text('Liên hệ yêu thích'));
    await tester.enterText(find.byType(TextFormField).at(2), 'Đồng nghiệp mới');
    await tester.tap(find.text('Lưu liên hệ'));
    await tester.pumpAndSettle();
    expect(find.text('4'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    await tester.tap(find.text('Phạm Hà'));
    await tester.pumpAndSettle();
    expect(find.text('0977777777'), findsOneWidget);
    expect(find.text('Công việc'), findsOneWidget);
    expect(find.text('Nữ'), findsOneWidget);
    expect(find.text('Đồng nghiệp mới'), findsOneWidget);
    expect(
      tester.widget<CheckboxListTile>(find.byType(CheckboxListTile)).value,
      isTrue,
    );
  });

  testWidgets(
    'Yêu thích cập nhật khi Back, xóa có thể hủy và xóa hết danh bạ',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(420, 1000));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await login(tester);
      await tester.tap(find.text('Nguyễn Văn An'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Liên hệ yêu thích'));
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.text('2'), findsOneWidget);
      for (final name in ['Nguyễn Văn An', 'Trần Thị Bình', 'Lê Minh Châu']) {
        await tester.tap(find.text(name));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Xóa liên hệ'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Hủy'));
        await tester.pumpAndSettle();
        expect(find.text(name), findsOneWidget);
        await tester.tap(find.text('Xóa liên hệ'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Xóa'));
        await tester.pumpAndSettle();
        expect(find.text(name), findsNothing);
      }
      expect(find.text('Chưa có liên hệ nào'), findsOneWidget);
      expect(find.text('0'), findsNWidgets(2));
    },
  );

  testWidgets('Gọi điện gửi đúng số và thông báo khi không mở được', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(420, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    const channel = MethodChannel('plugins.flutter.io/url_launcher');
    MethodCall? call;
    var succeeds = true;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (value) async {
          call = value;
          return succeeds;
        });
    addTearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
    });
    await login(tester);
    await tester.tap(find.text('Nguyễn Văn An'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Gọi điện'));
    await tester.pumpAndSettle();
    expect(call?.arguments['url'], 'tel:0901234567');
    succeeds = false;
    await tester.tap(find.text('Gọi điện'));
    await tester.pumpAndSettle();
    expect(
      find.text('Không mở được trình quay số trên thiết bị này'),
      findsOneWidget,
    );
  });

  testWidgets('Đăng nhập cuộn được khi bàn phím mở trên máy nhỏ', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 480));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    tester.view.viewInsets = const FakeViewPadding(bottom: 250);
    addTearDown(tester.view.resetViewInsets);
    await tester.pumpWidget(const ContactsApp());
    await tester.pump();
    await tester.ensureVisible(find.text('Đăng nhập'));
    expect(tester.takeException(), isNull);
  });
}
