class Contact {
  Contact({
    required this.name,
    required this.phone,
    required this.group,
    this.gender = 'Nam',
    this.favorite = false,
    this.note = '',
  });

  final String name;
  final String phone;
  final String group;
  final String gender;
  final String note;
  bool favorite;
}

const contactGroups = ['Gia đình', 'Bạn bè', 'Công việc', 'Khác'];
const contactGenders = ['Nam', 'Nữ', 'Khác'];

String? validateName(String? value) {
  if (value == null || value.trim().isEmpty) return 'Vui lòng nhập họ và tên';
  return null;
}

String? validatePhone(String? value, Set<String> phones) {
  final phone = value?.trim() ?? '';
  if (!RegExp(r'^0[0-9]{9}$').hasMatch(phone)) {
    return 'Số điện thoại phải có 10 chữ số và bắt đầu bằng 0';
  }
  if (phones.contains(phone)) return 'Số điện thoại đã tồn tại trong danh bạ';
  return null;
}

List<Contact> sampleContacts() => [
  Contact(name: 'Nguyễn Văn An', phone: '0901234567', group: 'Bạn bè'),
  Contact(
    name: 'Trần Thị Bình',
    phone: '0912345678',
    group: 'Gia đình',
    gender: 'Nữ',
    favorite: true,
  ),
  Contact(name: 'Lê Minh Châu', phone: '0987654321', group: 'Công việc'),
];
