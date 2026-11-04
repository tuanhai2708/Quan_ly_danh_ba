## Chạy ứng dụng

Cài Flutter stable với Dart từ 3.10 và Android SDK, mở emulator hoặc kết nối điện thoại rồi chạy:

```sh
flutter pub get
flutter run
```

Trên máy hiện tại, Flutter đã được chuẩn bị ở `/Users/tuanhai/.local/share/flutter`. Nếu terminal chưa nhận lệnh `flutter`, chạy:

```sh
export PATH="$HOME/.local/share/flutter/bin:$PATH"
```

Tài khoản đăng nhập:

- Tên đăng nhập: **admin**
- Mật khẩu: **123456**

Tài khoản được khai báo trong `lib/login_page.dart`.

Kiểm tra mã nguồn, chạy kiểm thử và tạo APK debug:

```sh
flutter analyze
flutter test
flutter build apk --debug
```

APK nằm tại `build/app/outputs/flutter-apk/app-debug.apk`.

## Chức năng

- Đăng nhập: kiểm tra bỏ trống và sai tài khoản; dùng `pushReplacement` để Back không quay lại đăng nhập.
- Danh sách: ba liên hệ mẫu, ảnh đại diện bằng chữ cái đầu của tên, nhóm, số điện thoại, dấu sao và thống kê tổng/yêu thích.
- Thêm: họ tên bắt buộc; số điện thoại gồm đúng 10 chữ số, bắt đầu bằng 0 và không trùng; chọn nhóm, giới tính, yêu thích và ghi chú.
- Chi tiết: hiển thị đầy đủ thông tin, bật/tắt yêu thích, mở trình quay số, quay lại và xác nhận xóa.
- Danh sách và thống kê cập nhật sau khi thêm, đổi yêu thích hoặc xóa. Có trạng thái danh sách rỗng.

Dữ liệu chỉ tồn tại trong bộ nhớ trong phiên chạy. Mở lại tiến trình ứng dụng sẽ trở về ba liên hệ mẫu. Đăng nhập là tài khoản cố định cho bài tập, không dùng máy chủ.

## Cấu trúc

| File | Nội dung |
| --- | --- |
| `lib/main.dart` | Theme, tiếng Việt, màn hình đầu tiên |
| `lib/contact.dart` | Contact, dữ liệu mẫu và kiểm tra dữ liệu |
| `lib/login_page.dart` | Đăng nhập |
| `lib/contacts_page.dart` | Danh sách và trạng thái danh bạ |
| `lib/add_contact_page.dart` | Form thêm liên hệ |
| `lib/contact_detail_page.dart` | Chi tiết, yêu thích, gọi điện, xóa |
| `lib/contact_avatar.dart` | Avatar dùng chung |

Mỗi màn hình dùng `StatefulWidget`. Danh sách giữ `List<Contact>`, nhận liên hệ mới và kết quả xóa qua `Navigator.pop`. Màn hình chi tiết cập nhật trực tiếp cờ `favorite`; danh sách gọi `setState` khi quay lại. Các phần UI riêng dùng private `StatelessWidget`, không tách bằng hàm `_build`.

Chỉ dùng thêm `url_launcher` để mở ứng dụng điện thoại với URI `tel:`. Thiết bị cần có trình quay số; nếu không mở được, ứng dụng hiển thị thông báo. Không yêu cầu quyền gọi điện trực tiếp.

Tài liệu tham khảo:

- [url_launcher](https://pub.dev/packages/url_launcher)
- [Navigator](https://docs.flutter.dev/cookbook/navigation/navigation-basics)

## Bài nộp theo đề

Đề yêu cầu repository và báo cáo Word/PDF có ảnh chụp thực tế cùng mô tả cho cả bốn màn hình.

- Tên repository theo đề: `MSS# Quản lý danh bạ

Ứng dụng Flutter/Dart 3, giao diện Material 3 bằng tiếng Việt. Đây là bản chuyển thể chức năng từ đề bài `De_bai_Quan_ly_danh_ba.docx` theo yêu cầu dùng Flutter. Đề gốc yêu cầu Java/XML và Activity/Intent; bản này dùng Widget và Navigator

## Chạy ứng dụng

Cài Flutter stable với Dart từ 3.10 và Android SDK, mở emulator hoặc kết nối điện thoại rồi chạy:

```sh
flutter pub get
flutter run
```

Trên máy hiện tại, Flutter đã được chuẩn bị ở `/Users/tuanhai/.local/share/flutter`. Nếu terminal chưa nhận lệnh `flutter`, chạy:

```sh
export PATH="$HOME/.local/share/flutter/bin:$PATH"
```

Tài khoản đăng nhập:

- Tên đăng nhập: **admin**
- Mật khẩu: **123456**

Tài khoản được khai báo trong `lib/login_page.dart`.

Kiểm tra mã nguồn, chạy kiểm thử và tạo APK debug:

```sh
flutter analyze
flutter test
flutter build apk --debug
```

APK nằm tại `build/app/outputs/flutter-apk/app-debug.apk`.

## Chức năng

- Đăng nhập: kiểm tra bỏ trống và sai tài khoản; dùng `pushReplacement` để Back không quay lại đăng nhập.
- Danh sách: ba liên hệ mẫu, ảnh đại diện bằng chữ cái đầu của tên, nhóm, số điện thoại, dấu sao và thống kê tổng/yêu thích.
- Thêm: họ tên bắt buộc; số điện thoại gồm đúng 10 chữ số, bắt đầu bằng 0 và không trùng; chọn nhóm, giới tính, yêu thích và ghi chú.
- Chi tiết: hiển thị đầy đủ thông tin, bật/tắt yêu thích, mở trình quay số, quay lại và xác nhận xóa.
- Danh sách và thống kê cập nhật sau khi thêm, đổi yêu thích hoặc xóa. Có trạng thái danh sách rỗng.

Dữ liệu chỉ tồn tại trong bộ nhớ trong phiên chạy. Mở lại tiến trình ứng dụng sẽ trở về ba liên hệ mẫu. Đăng nhập là tài khoản cố định cho bài tập, không dùng máy chủ.

## Cấu trúc

| File | Nội dung |
| --- | --- |
| `lib/main.dart` | Theme, tiếng Việt, màn hình đầu tiên |
| `lib/contact.dart` | Contact, dữ liệu mẫu và kiểm tra dữ liệu |
| `lib/login_page.dart` | Đăng nhập |
| `lib/contacts_page.dart` | Danh sách và trạng thái danh bạ |
| `lib/add_contact_page.dart` | Form thêm liên hệ |
| `lib/contact_detail_page.dart` | Chi tiết, yêu thích, gọi điện, xóa |
| `lib/contact_avatar.dart` | Avatar dùng chung |

Mỗi màn hình dùng `StatefulWidget`. Danh sách giữ `List<Contact>`, nhận liên hệ mới và kết quả xóa qua `Navigator.pop`. Màn hình chi tiết cập nhật trực tiếp cờ `favorite`; danh sách gọi `setState` khi quay lại. Các phần UI riêng dùng private `StatelessWidget`, không tách bằng hàm `_build`.

Chỉ dùng thêm `url_launcher` để mở ứng dụng điện thoại với URI `tel:`. Thiết bị cần có trình quay số; nếu không mở được, ứng dụng hiển thị thông báo. Không yêu cầu quyền gọi điện trực tiếp.

Tài liệu tham khảo:

- [url_launcher](https://pub.dev/packages/url_launcher)
- [Navigator](https://docs.flutter.dev/cookbook/navigation/navigation-basics)

## Bài nộp theo đề
- Tên repository theo đề: `TH_APP_2810`
- Tên sinh viên: Trần Tuấn Hải
- MSV: B24DCCC102
