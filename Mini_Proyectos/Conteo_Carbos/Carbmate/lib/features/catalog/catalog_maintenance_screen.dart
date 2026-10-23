import 'package:flutter/material.dart';

import 'package:carbmate/features/foods/domain/food_repository.dart';

class CatalogMaintenanceScreen extends StatefulWidget {
  const CatalogMaintenanceScreen({
    super.key,
    required this.repository,
    required this.kind,
    required this.title,
    required this.icon,
  });

  final FoodRepository repository;
  final CatalogKind kind;
  final String title;
  final IconData icon;

  @override
  State<CatalogMaintenanceScreen> createState() =>
      _CatalogMaintenanceScreenState();
}

class _CatalogMaintenanceScreenState extends State<CatalogMaintenanceScreen> {
  List<MaintenanceCatalogEntry> _entries = const [];
  Object? _loadError;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    setState(() {
      _isLoading = true;
      _loadError = null;
    });
    try {
      final entries = await widget.repository.loadCatalogEntries(widget.kind);
      if (!mounted) return;
      setState(() {
        _entries = entries;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _loadError = error;
        _isLoading = false;
      });
    }
  }

  Future<void> _editEntry([MaintenanceCatalogEntry? entry]) async {
    final result = await showDialog<_CatalogDialogResult>(
      context: context,
      builder: (_) => _CatalogEntryDialog(
        entry: entry,
        isMeasure: widget.kind == CatalogKind.measures,
      ),
    );
    if (!mounted || result == null) return;

    try {
      if (result.action == _CatalogDialogAction.deleted && entry != null) {
        await widget.repository.deleteCatalogEntry(widget.kind, entry.id);
      } else if (result.action == _CatalogDialogAction.saved) {
        await widget.repository.saveCatalogEntry(
          kind: widget.kind,
          id: entry?.id,
          name: result.name!,
          note: result.note,
        );
      }
      await _loadEntries();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo guardar el cambio.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: _buildList(),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Agregar ${widget.title.toLowerCase()}',
        onPressed: () => _editEntry(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildList() {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    if (_loadError != null) {
      return Center(
        child: TextButton(
          onPressed: _loadEntries,
          child: const Text('No se pudo cargar. Reintentar'),
        ),
      );
    }
    if (_entries.isEmpty) {
      return Center(child: Text('Todavía no hay ${widget.title.toLowerCase()}'));
    }
    return ListView.separated(
      itemCount: _entries.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final entry = _entries[index];
        return ListTile(
          leading: Icon(widget.icon),
          title: Text(entry.name),
          subtitle: widget.kind == CatalogKind.measures && entry.note != null
              ? Text(entry.note!)
              : null,
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _editEntry(entry),
        );
      },
    );
  }
}

enum _CatalogDialogAction { saved, deleted }

class _CatalogDialogResult {
  const _CatalogDialogResult.deleted()
    : action = _CatalogDialogAction.deleted,
      name = null,
      note = null;

  const _CatalogDialogResult.saved(this.name, this.note)
    : action = _CatalogDialogAction.saved;

  final _CatalogDialogAction action;
  final String? name;
  final String? note;
}

class _CatalogEntryDialog extends StatefulWidget {
  const _CatalogEntryDialog({required this.entry, required this.isMeasure});

  final MaintenanceCatalogEntry? entry;
  final bool isMeasure;

  @override
  State<_CatalogEntryDialog> createState() => _CatalogEntryDialogState();
}

class _CatalogEntryDialogState extends State<_CatalogEntryDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _noteController;
  String? _validationMessage;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.entry?.name ?? '');
    _noteController = TextEditingController(text: widget.entry?.note ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.entry == null ? 'Agregar' : 'Editar'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: 'Nombre',
                errorText: _validationMessage,
              ),
              onChanged: (_) {
                if (_validationMessage != null) {
                  setState(() => _validationMessage = null);
                }
              },
            ),
            if (widget.isMeasure) ...[
              const SizedBox(height: 12),
              TextField(
                controller: _noteController,
                textCapitalization: TextCapitalization.sentences,
                minLines: 2,
                maxLines: 4,
                decoration: const InputDecoration(labelText: 'Nota'),
              ),
            ],
          ],
        ),
      ),
      actions: [
        if (widget.entry?.deletable ?? false)
          IconButton(
            tooltip: 'Eliminar',
            onPressed: _confirmDelete,
            color: Colors.red.shade700,
            icon: const Icon(Icons.delete_outline),
          ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(onPressed: _save, child: const Text('Guardar')),
      ],
    );
  }

  void _save() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _validationMessage = 'Ingresá un nombre.');
      return;
    }
    Navigator.pop(
      context,
      _CatalogDialogResult.saved(
        name,
        widget.isMeasure ? _noteController.text.trim() : null,
      ),
    );
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar elemento'),
        content: Text('¿Querés eliminar "${widget.entry!.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      Navigator.pop(context, const _CatalogDialogResult.deleted());
    }
  }
}
