import 'package:flutter/material.dart';

import 'add_contact_page.dart';
import 'contact.dart';
import 'contact_avatar.dart';
import 'contact_detail_page.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  final _items = sampleContacts();

  Future<void> _add() async {
    final contact = await Navigator.of(context).push<Contact>(
      MaterialPageRoute(
        builder: (_) =>
            AddContactPage(phones: _items.map((item) => item.phone).toSet()),
      ),
    );
    if (!mounted || contact == null) return;
    setState(() => _items.add(contact));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Đã thêm liên hệ')));
  }

  Future<void> _open(Contact contact) async {
    final deleted = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => ContactDetailPage(contact: contact)),
    );
    if (!mounted) return;
    setState(() {
      if (deleted == true) _items.remove(contact);
    });
    if (deleted == true) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Đã xóa liên hệ')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final favorites = _items.where((item) => item.favorite).length;

    return Scaffold(
      appBar: AppBar(title: const Text('Danh bạ')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                  child: Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          count: _items.length,
                          label: 'Tổng liên hệ',
                          icon: Icons.people_outline,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          count: favorites,
                          label: 'Yêu thích',
                          icon: Icons.star_rounded,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _items.isEmpty
                      ? const _EmptyContacts()
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
                          itemCount: _items.length,
                          separatorBuilder: (_, index) =>
                              const SizedBox(height: 8),
                          itemBuilder: (_, index) => _ContactTile(
                            contact: _items[index],
                            onTap: () => _open(_items[index]),
                          ),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _add,
                      icon: const Icon(Icons.person_add_alt_1_outlined),
                      label: const Text('Thêm liên hệ'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.count,
    required this.label,
    required this.icon,
  });

  final int count;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card.filled(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: theme.colorScheme.primary),
            const SizedBox(height: 12),
            Text('$count', style: theme.textTheme.headlineMedium),
            const SizedBox(height: 4),
            Text(label, style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  const _ContactTile({required this.contact, required this.onTap});

  final Contact contact;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: ContactAvatar(name: contact.name),
        title: Text(
          contact.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text('${contact.phone}\n${contact.group}'),
        isThreeLine: true,
        trailing: contact.favorite
            ? const Icon(
                Icons.star_rounded,
                color: Color(0xFFB77912),
                semanticLabel: 'Yêu thích',
              )
            : const Icon(Icons.chevron_right_rounded),
        onTap: onTap,
      ),
    );
  }
}

class _EmptyContacts extends StatelessWidget {
  const _EmptyContacts();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.contact_page_outlined, size: 56),
            SizedBox(height: 16),
            Text('Chưa có liên hệ nào'),
            SizedBox(height: 8),
            Text('Thêm liên hệ đầu tiên của bạn.', textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
