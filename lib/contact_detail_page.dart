import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import 'contact.dart';
import 'contact_avatar.dart';

class ContactDetailPage extends StatefulWidget {
  const ContactDetailPage({super.key, required this.contact});

  final Contact contact;

  @override
  State<ContactDetailPage> createState() => _ContactDetailPageState();
}

class _ContactDetailPageState extends State<ContactDetailPage> {
  bool _calling = false;

  Future<void> _call() async {
    setState(() => _calling = true);
    var launched = false;
    try {
      launched = await launchUrl(
        Uri(scheme: 'tel', path: widget.contact.phone),
        mode: LaunchMode.externalApplication,
      );
    } on PlatformException {
      launched = false;
    }
    if (!mounted) return;
    setState(() => _calling = false);
    if (!launched) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Không mở được trình quay số trên thiết bị này'),
        ),
      );
    }
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa liên hệ?'),
        content: Text('Bạn muốn xóa ${widget.contact.name} khỏi danh bạ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Hủy'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
    if (!mounted || confirmed != true) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final contact = widget.contact;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Chi tiết liên hệ')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Center(child: ContactAvatar(name: contact.name, radius: 44)),
                const SizedBox(height: 16),
                Text(
                  contact.name,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                Card.filled(
                  margin: EdgeInsets.zero,
                  child: Column(
                    children: [
                      _InfoTile(
                        icon: Icons.phone_outlined,
                        label: 'Số điện thoại',
                        value: contact.phone,
                      ),
                      _InfoTile(
                        icon: Icons.group_outlined,
                        label: 'Nhóm',
                        value: contact.group,
                      ),
                      _InfoTile(
                        icon: Icons.person_outline,
                        label: 'Giới tính',
                        value: contact.gender,
                      ),
                      _InfoTile(
                        icon: Icons.notes_rounded,
                        label: 'Ghi chú',
                        value: contact.note.isEmpty
                            ? 'Chưa có ghi chú'
                            : contact.note,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                CheckboxListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                  controlAffinity: ListTileControlAffinity.leading,
                  title: const Text('Liên hệ yêu thích'),
                  value: contact.favorite,
                  onChanged: (value) =>
                      setState(() => contact.favorite = value ?? false),
                ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: _calling ? null : _call,
                  icon: const Icon(Icons.call_outlined),
                  label: const Text('Gọi điện'),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Quay lại'),
                ),
                const SizedBox(height: 12),
                TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor: theme.colorScheme.error,
                  ),
                  onPressed: _delete,
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Xóa liên hệ'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label, style: Theme.of(context).textTheme.labelLarge),
      subtitle: Text(value, style: Theme.of(context).textTheme.bodyLarge),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    );
  }
}
