import 'package:flutter/material.dart';

import '../models/shopping_item.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  Future<void> _openForm({ShoppingItem? existing}) async {
    final nameController = TextEditingController(text: existing?.name ?? '');
    final amountController = TextEditingController(text: existing?.amount ?? '');
    String? error;

    await showDialog<void>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: AppColors.cream,
          title: Text(existing == null ? 'Tambah Item' : 'Edit Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nama bahan'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: amountController,
                decoration: const InputDecoration(labelText: 'Jumlah (mis. 2 buah)'),
              ),
              if (error != null) ...[
                const SizedBox(height: 8),
                Text(error!, style: const TextStyle(fontSize: 12, color: AppColors.red)),
              ],
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Batal')),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim();
                final amount = amountController.text.trim();
                if (name.isEmpty || amount.isEmpty) {
                  setDialogState(() => error = 'Nama dan jumlah wajib diisi.');
                  return;
                }
                if (existing == null) {
                  appState.addShoppingItem(name: name, amount: amount);
                } else {
                  appState.updateShoppingItem(existing.id, name: name, amount: amount);
                }
                Navigator.of(context).pop();
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final items = appState.shoppingItems;
    final unbought = items.where((i) => !i.checked).toList();
    final bought = items.where((i) => i.checked).toList();

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Daftar belanja', style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 22)),
              const Icon(Icons.ios_share_rounded, size: 20, color: AppColors.muted),
            ],
          ),
          const SizedBox(height: 16),
          Text('Belum dibeli (${unbought.length})',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.ink)),
          const SizedBox(height: 8),
          if (unbought.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 6),
              child: Text('Semua bahan sudah dibeli.', style: TextStyle(fontSize: 13, color: AppColors.muted)),
            )
          else
            ...unbought.map((i) => _ShoppingRow(
                  item: i,
                  onToggle: () {
                    appState.toggleShoppingItem(i.id);
                    setState(() {});
                  },
                  onEdit: () => _openForm(existing: i),
                  onDelete: () {
                    appState.deleteShoppingItem(i.id);
                    setState(() {});
                  },
                )),
          const SizedBox(height: 16),
          Text('Sudah dibeli (${bought.length})',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.muted)),
          const SizedBox(height: 8),
          ...bought.map((i) => _ShoppingRow(
                item: i,
                onToggle: () {
                  appState.toggleShoppingItem(i.id);
                  setState(() {});
                },
                onEdit: () => _openForm(existing: i),
                onDelete: () {
                  appState.deleteShoppingItem(i.id);
                  setState(() {});
                },
              )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.orange,
        onPressed: () => _openForm(),
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
    );
  }
}

class _ShoppingRow extends StatelessWidget {
  const _ShoppingRow({
    required this.item,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  final ShoppingItem item;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final checked = item.checked;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(children: [
        InkWell(
          onTap: onToggle,
          customBorder: const CircleBorder(),
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: checked ? AppColors.green : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: checked ? AppColors.green : AppColors.line, width: 1.4),
            ),
            child: checked ? const Icon(Icons.check_rounded, size: 14, color: Colors.white) : null,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: onEdit,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TextStyle(
                    fontSize: 13,
                    color: checked ? AppColors.muted : AppColors.ink,
                    decoration: checked ? TextDecoration.lineThrough : null,
                  ),
                ),
                Text(item.amount, style: const TextStyle(fontSize: 11, color: AppColors.muted)),
              ],
            ),
          ),
        ),
        IconButton(
          onPressed: onDelete,
          icon: const Icon(Icons.delete_outline_rounded, size: 20, color: AppColors.red),
          splashRadius: 20,
        ),
      ]),
    );
  }
}