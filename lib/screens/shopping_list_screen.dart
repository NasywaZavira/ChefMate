import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/app_repository.dart';
import '../models/shopping_item.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  /// ID item yang sedang dihapus (lewat repository, ada jeda simulasi),
  /// supaya baris itu bisa menampilkan spinner & tombol hapusnya nonaktif
  /// sementara — ini juga mencegah dobel-tap memicu hapus dua kali.
  final Set<String> _deletingIds = {};

  Future<void> _openForm({ShoppingItem? existing}) async {
    final nameController = TextEditingController(text: existing?.name ?? '');
    final amountController = TextEditingController(text: existing?.amount ?? '');
    String? nameError;
    String? amountError;
    String? submitError;
    var saving = false;
    var simulateError = false;

    // Gaya pesan error di atas latar orange: putih tebal supaya terbaca.
    const errorStyle = TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white);

    await showDialog<void>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          Future<void> handleSave() async {
            final name = nameController.text.trim();
            final amount = amountController.text.trim();

            final nextNameError = name.isEmpty ? 'Nama bahan wajib diisi.' : null;
            final nextAmountError = amount.isEmpty ? 'Jumlah wajib diisi.' : null;
            if (nextNameError != null || nextAmountError != null) {
              setDialogState(() {
                nameError = nextNameError;
                amountError = nextAmountError;
              });
              return;
            }
            if (saving) return; // cegah submit ganda akibat ketukan berulang

            setDialogState(() {
              saving = true;
              nameError = null;
              amountError = null;
              submitError = null;
            });

            try {
              await appRepository.saveShoppingItem(
                name: name,
                amount: amount,
                existingId: existing?.id,
                sourceRecipeId: existing?.sourceRecipeId,
                simulateError: simulateError,
              );
              if (!context.mounted) return;
              Navigator.of(context).pop();
              if (!mounted) return;
              ScaffoldMessenger.of(this.context).showSnackBar(
                SnackBar(content: Text(existing == null ? 'Item ditambahkan.' : 'Item diperbarui.')),
              );
            } catch (e) {
              setDialogState(() {
                saving = false;
                submitError = e.toString().replaceFirst('Exception: ', '');
              });
            }
          }

          return AlertDialog(
            // Pop up berwarna orange terang
            backgroundColor: AppColors.orange,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            titleTextStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
            title: Text(existing == null ? 'Tambah Item' : 'Edit Item'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  enabled: !saving,
                  decoration: InputDecoration(
                    labelText: 'Nama bahan',
                    errorText: nameError,
                    errorStyle: errorStyle,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: amountController,
                  enabled: !saving,
                  decoration: InputDecoration(
                    labelText: 'Jumlah (mis. 2 buah)',
                    errorText: amountError,
                    errorStyle: errorStyle,
                  ),
                ),
                const SizedBox(height: 4),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  title: const Text(
                    'Simulasikan gagal (untuk demo/uji)',
                    style: TextStyle(fontSize: 11, color: Colors.white),
                  ),
                  value: simulateError,
                  activeThumbColor: Colors.white,
                  activeTrackColor: const Color(0xFFC2500A),
                  onChanged: saving ? null : (v) => setDialogState(() => simulateError = v),
                ),
                if (submitError != null) ...[
                  const SizedBox(height: 4),
                  Text(submitError!, style: errorStyle),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: saving ? null : () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  disabledForegroundColor: Colors.white54,
                ),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: saving ? null : handleSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.orange,
                  disabledBackgroundColor: Colors.white70,
                ),
                child: saving
                    ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.orange),
                )
                    : Text(submitError != null ? 'Coba lagi' : 'Simpan'),
              ),
            ],
          );
        },
      ),
    );
    if (mounted) setState(() {});
  }

  Future<void> _confirmDelete(ShoppingItem item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cream,
        title: const Text('Hapus item ini?'),
        content: Text(
          '"${item.name}" akan dihapus dari daftar belanja.',
          style: const TextStyle(fontSize: 13, color: AppColors.ink),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Batal')),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Hapus', style: TextStyle(color: AppColors.red)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await _delete(item);
  }

  Future<void> _delete(ShoppingItem item) async {
    if (_deletingIds.contains(item.id)) return; // cegah dobel-tap
    setState(() => _deletingIds.add(item.id));

    try {
      await appRepository.deleteShoppingItem(item.id);
      if (!mounted) return;
      setState(() => _deletingIds.remove(item.id));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item dihapus.')),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _deletingIds.remove(item.id));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          action: SnackBarAction(label: 'Coba lagi', onPressed: () => _delete(item)),
        ),
      );
    }
  }

  Future<void> _shareList() async {
    final items = appState.shoppingItems;
    if (items.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Daftar belanja masih kosong.')));
      return;
    }

    final buffer = StringBuffer('Daftar Belanja ChefMate\n');
    for (final item in items) {
      buffer.writeln('${item.checked ? '[x]' : '[ ]'} ${item.name} - ${item.amount}');
    }

    await Clipboard.setData(ClipboardData(text: buffer.toString()));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Daftar belanja disalin, siap dibagikan.')),
    );
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
              InkWell(
                onTap: _shareList,
                borderRadius: BorderRadius.circular(20),
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(Icons.ios_share_rounded, size: 20, color: AppColors.muted),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text('Belum dibeli (${unbought.length})',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.ink)),
          const SizedBox(height: 8),
          if (unbought.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Semua bahan sudah dibeli.', style: TextStyle(fontSize: 13, color: AppColors.muted)),
                  const SizedBox(height: 6),
                  TextButton.icon(
                    onPressed: () => _openForm(),
                    style: TextButton.styleFrom(padding: EdgeInsets.zero, alignment: Alignment.centerLeft),
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: const Text('Tambah bahan baru'),
                  ),
                ],
              ),
            )
          else
            ...unbought.map((i) => _ShoppingRow(
              item: i,
              isDeleting: _deletingIds.contains(i.id),
              onToggle: () {
                appState.toggleShoppingItem(i.id);
                setState(() {});
              },
              onEdit: () => _openForm(existing: i),
              onDelete: () => _confirmDelete(i),
            )),
          const SizedBox(height: 16),
          Text('Sudah dibeli (${bought.length})',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.muted)),
          const SizedBox(height: 8),
          if (bought.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 6),
              child: Text('Belum ada yang dicentang selesai dibeli.',
                  style: TextStyle(fontSize: 13, color: AppColors.muted)),
            )
          else
            ...bought.map((i) => _ShoppingRow(
              item: i,
              isDeleting: _deletingIds.contains(i.id),
              onToggle: () {
                appState.toggleShoppingItem(i.id);
                setState(() {});
              },
              onEdit: () => _openForm(existing: i),
              onDelete: () => _confirmDelete(i),
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
    this.isDeleting = false,
  });

  final ShoppingItem item;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool isDeleting;

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
      child: Opacity(
        opacity: isDeleting ? 0.5 : 1,
        child: Row(children: [
          InkWell(
            onTap: isDeleting ? null : onToggle,
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
              onTap: isDeleting ? null : onEdit,
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
          if (isDeleting)
            const SizedBox(
              width: 20,
              height: 20,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.red),
              ),
            )
          else
            IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline_rounded, size: 20, color: AppColors.red),
              splashRadius: 20,
            ),
        ]),
      ),
    );
  }
}