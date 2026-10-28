import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'contact.dart';

class AddContactPage extends StatefulWidget {
  const AddContactPage({super.key, required this.phones});

  final Set<String> phones;

  @override
  State<AddContactPage> createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _note = TextEditingController();
  String _group = contactGroups.first;
  String _gender = contactGenders.first;
  bool _favorite = false;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _note.dispose();
    super.dispose();
  }

  void _save() {
    if (!_form.currentState!.validate()) return;
    final contact = Contact(
      name: _name.text.trim(),
      phone: _phone.text.trim(),
      group: _group,
      gender: _gender,
      favorite: _favorite,
      note: _note.text.trim(),
    );
    Navigator.of(context).pop(contact);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thêm liên hệ')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Form(
              key: _form,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  TextFormField(
                    controller: _name,
                    decoration: const InputDecoration(
                      labelText: 'Họ và tên',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    validator: validateName,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _phone,
                    decoration: const InputDecoration(
                      labelText: 'Số điện thoại',
                      hintText: 'Ví dụ: 0901234567',
                      prefixIcon: Icon(Icons.phone_outlined),
                      errorMaxLines: 2,
                    ),
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) => validatePhone(value, widget.phones),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: _group,
                    decoration: const InputDecoration(
                      labelText: 'Nhóm',
                      prefixIcon: Icon(Icons.group_outlined),
                    ),
                    items: [
                      for (final group in contactGroups)
                        DropdownMenuItem(value: group, child: Text(group)),
                    ],
                    onChanged: (value) {
                      if (value != null) setState(() => _group = value);
                    },
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Giới tính',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  _GenderPicker(
                    value: _gender,
                    onChanged: (value) => setState(() => _gender = value),
                  ),
                  const SizedBox(height: 8),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    title: const Text('Liên hệ yêu thích'),
                    value: _favorite,
                    onChanged: (value) =>
                        setState(() => _favorite = value ?? false),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _note,
                    decoration: const InputDecoration(
                      labelText: 'Ghi chú (không bắt buộc)',
                      alignLabelWithHint: true,
                    ),
                    minLines: 3,
                    maxLines: 5,
                    keyboardType: TextInputType.multiline,
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: _save,
                    icon: const Icon(Icons.check_rounded),
                    label: const Text('Lưu liên hệ'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GenderPicker extends StatelessWidget {
  const _GenderPicker({required this.value, required this.onChanged});

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return RadioGroup<String>(
      groupValue: value,
      onChanged: (value) {
        if (value != null) onChanged(value);
      },
      child: Wrap(
        spacing: 8,
        children: [
          for (final gender in contactGenders)
            TextButton(
              onPressed: () => onChanged(gender),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Radio<String>(value: gender),
                  Text(gender),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
