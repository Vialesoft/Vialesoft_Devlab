import 'package:flutter/material.dart';

import 'package:carbmate/features/foods/domain/food_repository.dart';
import 'package:carbmate/features/insulin_pens/insulin_pen_notifications.dart';

class InsulinPenScreen extends StatefulWidget {
  const InsulinPenScreen({super.key, required this.repository});

  final FoodRepository repository;

  @override
  State<InsulinPenScreen> createState() => _InsulinPenScreenState();
}

class _InsulinPenScreenState extends State<InsulinPenScreen> {
  final _notifications = InsulinPenNotifications();
  List<InsulinPen> _pens = const [];
  bool _isLoading = true;
  bool _isAdding = false;
  bool _notificationsDenied = false;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _loadPens();
  }

  Future<void> _loadPens() async {
    try {
      final pens = await widget.repository.loadInsulinPens();
      var notificationsAllowed = true;
      try {
        notificationsAllowed = await _notifications.notificationsEnabled();
      } catch (_) {
        notificationsAllowed = false;
      }
      if (!mounted) return;
      setState(() {
        _pens = pens..sort((a, b) => a.expiresOn.compareTo(b.expiresOn));
        _notificationsDenied = !notificationsAllowed;
        _isLoading = false;
        _loadError = null;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _loadError = 'No se pudieron cargar las lapiceras.';
      });
    }
  }

  Future<void> _addPen() async {
    final draft = await showDialog<_InsulinPenDraft>(
      context: context,
      builder: (_) => const _AddInsulinPenDialog(),
    );
    if (draft == null || !mounted) return;
    setState(() => _isAdding = true);
    try {
      final id = await widget.repository.addInsulinPen(
        draft.type,
        draft.openedOn,
      );
      final pen = InsulinPen(
        id: id,
        type: draft.type,
        openedOn: DateTime(
          draft.openedOn.year,
          draft.openedOn.month,
          draft.openedOn.day,
        ),
        shelfLifeDays: draft.type.shelfLifeDays,
      );
      var notificationsAllowed = false;
      var notificationSchedulingFailed = false;
      try {
        notificationsAllowed = await _notifications.requestPermission();
        if (notificationsAllowed) await _notifications.schedulePen(pen);
      } catch (_) {
        notificationSchedulingFailed = true;
      }
      if (!mounted) return;
      setState(() {
        _notificationsDenied = !notificationsAllowed;
        _isAdding = false;
      });
      await _loadPens();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            notificationSchedulingFailed
                ? 'Lapicera guardada, pero no se pudieron programar las alertas.'
                : notificationsAllowed
                ? 'Lapicera agregada.'
                : 'Lapicera guardada. Activa las notificaciones para recibir alertas.',
          ),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      setState(() => _isAdding = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo agregar la lapicera.')),
      );
    }
  }

  Future<void> _removePen(InsulinPen pen) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Quitar lapicera'),
        content: Text(
          '¿Querés quitar ${pen.type.label} del seguimiento y cancelar sus alertas?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Quitar'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    try {
      await widget.repository.deleteInsulinPen(pen.id);
      try {
        await _notifications.cancelPen(pen.id);
      } catch (_) {
        // The database remains authoritative if the OS cannot cancel alarms.
      }
      await _loadPens();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo quitar la lapicera.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Lapiceras de insulina')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _loadError != null
          ? Center(
              child: TextButton(
                onPressed: _loadPens,
                child: Text('$_loadError Reintentar'),
              ),
            )
          : Column(
              children: [
                if (_notificationsDenied)
                  MaterialBanner(
                    content: const Text(
                      'Las alertas están desactivadas. Podés habilitarlas en la configuración de Android.',
                    ),
                    leading: const Icon(Icons.notifications_off_outlined),
                    actions: [
                      TextButton(
                        onPressed: () async {
                          final messenger = ScaffoldMessenger.of(context);
                          await _notifications.openNotificationSettings();
                          final granted = await _notifications
                              .notificationsEnabled();
                          if (!mounted) return;
                          setState(() => _notificationsDenied = !granted);
                          if (granted) {
                            try {
                              await _notifications.scheduleAll(_pens);
                            } catch (_) {
                              if (!mounted) return;
                              messenger.showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'No se pudieron programar las alertas.',
                                  ),
                                ),
                              );
                            }
                          }
                        },
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                Expanded(
                  child: _pens.isEmpty
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(24),
                            child: Text(
                              'Todavía no hay lapiceras abiertas. Agrega una para empezar el seguimiento.',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : ListView.separated(
                          itemCount: _pens.length,
                          separatorBuilder: (_, _) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final pen = _pens[index];
                            final daysRemaining = pen.daysRemaining(
                              DateTime.now(),
                            );
                            final expiryText = daysRemaining < 0
                                ? 'Vencida hace ${-daysRemaining} ${-daysRemaining == 1 ? 'día' : 'días'}'
                                : daysRemaining == 0
                                ? 'Vence hoy'
                                : 'Quedan $daysRemaining ${daysRemaining == 1 ? 'día' : 'días'}';
                            final highlight = daysRemaining <= 5;
                            return ListTile(
                              leading: Icon(
                                Icons.medication_outlined,
                                color: highlight
                                    ? theme.colorScheme.error
                                    : theme.colorScheme.primary,
                              ),
                              title: Text(pen.type.label),
                              subtitle: Text(
                                'Abierta el ${_formatDate(pen.openedOn)} · Vence el ${_formatDate(pen.expiresOn)}',
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    expiryText,
                                    style: theme.textTheme.labelLarge?.copyWith(
                                      color: highlight
                                          ? theme.colorScheme.error
                                          : theme.colorScheme.onSurfaceVariant,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  IconButton(
                                    tooltip: 'Quitar del seguimiento',
                                    onPressed: () => _removePen(pen),
                                    color: theme.colorScheme.error,
                                    icon: const Icon(Icons.delete_outline),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        key: const Key('add-insulin-pen'),
        tooltip: 'Abrir lapicera',
        onPressed: _isAdding ? null : _addPen,
        child: _isAdding
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.add),
      ),
    );
  }
}

class _InsulinPenDraft {
  const _InsulinPenDraft(this.type, this.openedOn);

  final InsulinPenType type;
  final DateTime openedOn;
}

class _AddInsulinPenDialog extends StatefulWidget {
  const _AddInsulinPenDialog();

  @override
  State<_AddInsulinPenDialog> createState() => _AddInsulinPenDialogState();
}

class _AddInsulinPenDialogState extends State<_AddInsulinPenDialog> {
  InsulinPenType _type = InsulinPenType.toujeo;
  DateTime _openedOn = DateTime.now();

  Future<void> _selectDate() async {
    final today = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _openedOn,
      firstDate: DateTime(2000),
      lastDate: DateTime(today.year, today.month, today.day),
      helpText: 'Selecciona la fecha de apertura',
    );
    if (date != null) setState(() => _openedOn = date);
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Abrir lapicera'),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DropdownButtonFormField<InsulinPenType>(
          initialValue: _type,
          decoration: const InputDecoration(
            labelText: 'Insulina',
            border: OutlineInputBorder(),
          ),
          items: [
            for (final type in InsulinPenType.values)
              DropdownMenuItem(value: type, child: Text(type.label)),
          ],
          onChanged: (value) {
            if (value != null) setState(() => _type = value);
          },
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: _selectDate,
          icon: const Icon(Icons.calendar_today_outlined),
          label: Text('Abierta el ${_formatDate(_openedOn)}'),
        ),
        const SizedBox(height: 4),
        Text(
          'Vence el ${_formatDate(_openedOn.add(Duration(days: _type.shelfLifeDays)))} (${_type.shelfLifeDays} días después de abrirla).',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Cancelar'),
      ),
      FilledButton(
        onPressed: () => Navigator.of(context).pop(
          _InsulinPenDraft(
            _type,
            DateTime(_openedOn.year, _openedOn.month, _openedOn.day),
          ),
        ),
        child: const Text('Guardar'),
      ),
    ],
  );
}

String _formatDate(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '$day/$month/${date.year}';
}
