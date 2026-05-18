import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_clean_bloc/core/utils/show_snackbar.dart';
import 'package:todo_clean_bloc/features/schedules/domain/entities/literacy_schedule.dart';
import 'package:todo_clean_bloc/features/schedules/presentation/cubit/schedule_form_cubit.dart';
import 'package:todo_clean_bloc/init_dependency.dart';

class ScheduleFormPage extends StatelessWidget {
  /// null = create mode, non-null = edit mode
  final LiteracySchedule? schedule;

  const ScheduleFormPage({super.key, this.schedule});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<ScheduleFormCubit>(),
      child: _ScheduleFormView(schedule: schedule),
    );
  }
}

class _ScheduleFormView extends StatefulWidget {
  final LiteracySchedule? schedule;
  const _ScheduleFormView({this.schedule});

  @override
  State<_ScheduleFormView> createState() => _ScheduleFormViewState();
}

class _ScheduleFormViewState extends State<_ScheduleFormView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtrl;
  late final TextEditingController _descriptionCtrl;
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;

  bool get _isEdit => widget.schedule != null;

  @override
  void initState() {
    super.initState();
    final s = widget.schedule;
    _titleCtrl = TextEditingController(text: s?.title ?? '');
    _descriptionCtrl = TextEditingController(text: s?.description ?? '');
    _selectedDate = s?.scheduledDate ?? DateTime.now();

    if (s != null) {
      final parts = s.scheduledTime.split(':');
      _selectedTime = TimeOfDay(
        hour: int.tryParse(parts.first) ?? 0,
        minute: int.tryParse(parts.elementAtOrNull(1) ?? '0') ?? 0,
      );
    } else {
      _selectedTime = TimeOfDay.now();
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descriptionCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate);
    final timeStr =
        '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}';

    final cubit = context.read<ScheduleFormCubit>();
    if (_isEdit) {
      cubit.update(
        id: widget.schedule!.id,
        title: _titleCtrl.text.trim(),
        scheduledDate: dateStr,
        scheduledTime: timeStr,
        description: _descriptionCtrl.text.trim().isEmpty
            ? null
            : _descriptionCtrl.text.trim(),
      );
    } else {
      cubit.create(
        title: _titleCtrl.text.trim(),
        scheduledDate: dateStr,
        scheduledTime: timeStr,
        description: _descriptionCtrl.text.trim().isEmpty
            ? null
            : _descriptionCtrl.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ScheduleFormCubit, ScheduleFormState>(
      listener: (context, state) {
        if (state is ScheduleFormSuccess) {
          showModernSnackBar(
            context,
            _isEdit
                ? 'Jadwal berhasil diperbarui'
                : 'Jadwal berhasil ditambahkan',
            type: SnackBarType.success,
          );
          Navigator.of(context).pop(true);
        } else if (state is ScheduleFormFailure) {
          showModernSnackBar(context, state.message);
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(_isEdit ? 'Edit Jadwal' : 'Tambah Jadwal')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _titleCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Judul *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Judul wajib diisi'
                      : null,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Deskripsi (opsional)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                _DatePickerField(
                  label: 'Tanggal',
                  value: DateFormat(
                    'EEEE, d MMMM yyyy',
                    'id_ID',
                  ).format(_selectedDate),
                  onTap: _pickDate,
                ),
                const SizedBox(height: 16),
                _DatePickerField(
                  label: 'Waktu',
                  value: _selectedTime.format(context),
                  onTap: _pickTime,
                ),
                const SizedBox(height: 32),
                BlocBuilder<ScheduleFormCubit, ScheduleFormState>(
                  builder: (context, state) {
                    final isLoading = state is ScheduleFormLoading;
                    return ElevatedButton(
                      onPressed: isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(
                              _isEdit ? 'Simpan Perubahan' : 'Tambah Jadwal',
                            ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DatePickerField extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const _DatePickerField({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.calendar_today_outlined),
        ),
        child: Text(value),
      ),
    );
  }
}
