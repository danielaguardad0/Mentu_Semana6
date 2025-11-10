import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mentu_app/domain/entities/task_entity.dart';
import 'package:mentu_app/presentation/providers/tasks_provider.dart';
import 'package:mentu_app/presentation/providers/subject_provider.dart';
// Necesario para isSameDay

const Color primaryColor = Colors.blue;
const Color cardBackgroundColor = Colors.white;

// 🛑 ELIMINADA la clase DateOption (ya no se usa la lógica dinámica compleja)

class TaskFormScreen extends ConsumerStatefulWidget {
  final TaskEntity? taskToEdit;

  const TaskFormScreen({super.key, this.taskToEdit});

  @override
  ConsumerState<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends ConsumerState<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Controladores y variables de estado
  late TextEditingController _titleController;
  late TextEditingController _subjectController;
  late String _selectedDueTime;
  late Color _selectedColor;

  // ✅ REVERSIÓN: La fecha es solo una etiqueta String
  late String _selectedDueDateLabel;
  late String _selectedSubject;

  // ✅ REVERSIÓN: Opciones estáticas (CRÍTICAS para la estabilidad del Dropdown)
  final List<String> _dueDateOptions = [
    'Today',
    'Tomorrow',
    'In two days',
    'Next Week',
  ];
  // Opciones estáticas para la HORA
  final List<String> _dueTimeOptions = [
    '11:30 AM',
    '2:00 PM',
    '4:00 PM',
    '6:00 PM',
    '8:00 PM'
  ];
  final List<Color> _colorOptions = [
    Colors.blue,
    Colors.pinkAccent,
    Colors.orange,
    const Color(0xFF4CAF50),
    Colors.purple
  ];

  // 💡 Función auxiliar para convertir la ETIQUETA a DateTime real (medianoche)
  DateTime _convertLabelToDateTime(String label) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (label.contains('Today')) return today;
    if (label.contains('Tomorrow')) return today.add(const Duration(days: 1));
    if (label.contains('In two days'))
      return today.add(const Duration(days: 2));
    if (label.contains('Next Week')) return today.add(const Duration(days: 7));

    // Fallback seguro: Hoy
    return today;
  }

  // 💡 Función auxiliar para obtener la etiqueta de una fecha de edición
  String _getLabelForDueDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final comparisonDate = DateTime(date.year, date.month, date.day);

    if (comparisonDate.isAtSameMomentAs(today)) return 'Today';
    if (comparisonDate.isAtSameMomentAs(today.add(const Duration(days: 1))))
      return 'Tomorrow';

    // Si no coincide con las opciones preestablecidas, devolvemos la primera opción estática.
    // Esto es un compromiso para mantener el Dropdown estable.
    return _dueDateOptions.first;
  }

  @override
  void initState() {
    super.initState();
    final isEditing = widget.taskToEdit != null;
    final task = widget.taskToEdit;

    _titleController =
        TextEditingController(text: isEditing ? task!.title : '');
    _subjectController =
        TextEditingController(text: isEditing ? task!.subject : '');

    _selectedDueTime = isEditing ? task!.dueTime : _dueTimeOptions.first;
    _selectedColor = isEditing ? task!.color : _colorOptions.first;

    // ✅ CORRECCIÓN CRÍTICA: Convertir el DateTime de la tarea a una etiqueta String válida
    _selectedDueDateLabel =
        isEditing ? _getLabelForDueDate(task!.dueDate) : _dueDateOptions.first;

    _selectedSubject = isEditing ? task!.subject : '';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subjectController.dispose();
    super.dispose();
  }

  void _saveTask() async {
    if (!_formKey.currentState!.validate()) return;

    final subjectToSave =
        (_selectedSubject == 'ADD_NEW' || _selectedSubject.isEmpty)
            ? _subjectController.text.trim()
            : _selectedSubject;

    if (subjectToSave.isEmpty) {
      _showSnackbar('Por favor, seleccione o ingrese un nombre de materia.',
          Colors.orange);
      return;
    }

    setState(() => _isLoading = true);
    final notifier = ref.read(tasksNotifierProvider.notifier);

    final realDueDate = _convertLabelToDateTime(_selectedDueDateLabel);

    try {
      await ref
          .read(subjectNotifierProvider.notifier)
          .addSubject(subjectToSave);

      if (widget.taskToEdit == null) {
        await notifier.createTask(
          _titleController.text.trim(),
          subjectToSave,
          _selectedDueTime,
          realDueDate,
        );
        _showSnackbar('Tarea creada exitosamente.', Colors.green);
      } else {
        final updatedTask = widget.taskToEdit!.copyWith(
          title: _titleController.text.trim(),
          subject: subjectToSave,
          dueTime: _selectedDueTime,
          dueDate: realDueDate,
          color: _selectedColor,
        );
        await notifier.updateTask(updatedTask);
        _showSnackbar('Tarea actualizada exitosamente.', Colors.green);
      }

      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      _showSnackbar('Error al guardar la tarea: $e', Colors.red);
      setState(() => _isLoading = false);
    }
  }

  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }

  // Lógica de selección/adición de materias (Mantenida)
  Widget _buildSubjectSelector(List<String> subjects) {
    final isAddingNew = _selectedSubject == 'ADD_NEW' ||
        (_selectedSubject.isEmpty && subjects.isEmpty);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isAddingNew || subjects.isEmpty)
          TextFormField(
            controller: _subjectController,
            decoration: _inputDecoration(
                'New Subject Name', Icons.book_outlined, primaryColor),
            validator: (v) =>
                v!.isEmpty ? 'Subject name cannot be empty' : null,
            onFieldSubmitted: (name) {
              if (name.isNotEmpty) {
                ref
                    .read(subjectNotifierProvider.notifier)
                    .addSubject(name.trim());
                setState(() => _selectedSubject = name.trim());
              }
            },
          )
        else
          DropdownButtonFormField<String>(
            value:
                subjects.contains(_selectedSubject) ? _selectedSubject : null,
            decoration: _inputDecoration(
                'Select Subject', Icons.book_outlined, primaryColor),
            items: [
              ...subjects
                  .map((s) => DropdownMenuItem(value: s, child: Text(s))),
              const DropdownMenuItem(
                  value: 'ADD_NEW',
                  child: Text('— Add New Subject —',
                      style: TextStyle(
                          fontStyle: FontStyle.italic, color: primaryColor))),
            ],
            onChanged: (v) {
              if (v == 'ADD_NEW') {
                setState(() {
                  _selectedSubject = 'ADD_NEW';
                  _subjectController.text = '';
                });
              } else if (v != null) {
                setState(() {
                  _selectedSubject = v;
                  _subjectController.text = v;
                });
              }
            },
            validator: (v) =>
                v == null ? 'Please select or add a subject.' : null,
          ),
        if (!isAddingNew &&
            _selectedSubject.isNotEmpty &&
            subjects.contains(_selectedSubject))
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: TextButton.icon(
              icon: const Icon(Icons.delete_forever, color: Colors.red),
              label: Text('Remove subject: $_selectedSubject',
                  style: const TextStyle(color: Colors.red)),
              onPressed: () async {
                final currentSubject = _selectedSubject;
                await ref
                    .read(subjectNotifierProvider.notifier)
                    .removeSubject(currentSubject);
                setState(() {
                  _selectedSubject = '';
                  _subjectController.text = '';
                });
                _showSnackbar(
                    'Materia removida. Tareas asociadas DEBEN ser reasignadas.',
                    Colors.redAccent);
              },
            ),
          ),
      ],
    );
  }

  // Dropdown genérico adaptado para Strings
  Widget _buildDropdownField(
      {required String label,
      required String currentValue, // Acepta String
      required List<String> items, // Acepta List<String>
      required void Function(String?) onChanged, // Acepta función de String?
      IconData? icon}) {
    return DropdownButtonFormField<String>(
      value: currentValue,
      decoration: _inputDecoration(label, icon!, primaryColor),
      items: items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, style: GoogleFonts.inter(fontSize: 14)),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (v) => v == null ? 'Required field.' : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.taskToEdit != null;
    final subjectsAsync = ref.watch(subjectNotifierProvider);

    final dateOptions = _dueDateOptions;

    return Scaffold(
      backgroundColor: cardBackgroundColor,
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Task' : 'New Task',
            style: GoogleFonts.lobster(fontSize: 24, color: Colors.black87)),
        backgroundColor: cardBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black54),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitleField(),
              const SizedBox(height: 20),
              _buildSubjectSelector(subjectsAsync),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                      child: _buildDropdownField(
                    label: 'Due Date',
                    currentValue: _selectedDueDateLabel,
                    items: dateOptions,
                    onChanged: (String? v) {
                      if (v != null) setState(() => _selectedDueDateLabel = v);
                    },
                    icon: Icons.calendar_today,
                  )),
                  const SizedBox(width: 15),
                  Expanded(
                      child: _buildDropdownField(
                    label: 'Due Time',
                    currentValue: _selectedDueTime,
                    items: _dueTimeOptions,
                    onChanged: (String? v) {
                      if (v != null) setState(() => _selectedDueTime = v);
                    },
                    icon: Icons.access_time,
                  )),
                ],
              ),
              const SizedBox(height: 30),
              _buildColorPicker(),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: _isLoading ? null : _saveTask,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 55),
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 3)
                    : Text(isEditing ? 'Save Changes' : 'Create Task',
                        style: GoogleFonts.inter(
                            fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleField() {
    return TextFormField(
      controller: _titleController,
      decoration: _inputDecoration('Task Title', Icons.title, primaryColor),
      validator: (v) => v!.isEmpty ? 'Title cannot be empty' : null,
      maxLines: 2,
    );
  }

  Widget _buildColorPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text("Task Color",
              style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87)),
        ),
        Wrap(
          spacing: 10,
          children: _colorOptions.map((color) {
            return GestureDetector(
              onTap: () => setState(() => _selectedColor = color),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: color,
                child: _selectedColor == color
                    ? const Icon(Icons.check, color: Colors.white, size: 18)
                    : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon, Color color) {
    return InputDecoration(
      labelText: label,
      labelStyle:
          TextStyle(color: color.withOpacity(0.8), fontWeight: FontWeight.w500),
      prefixIcon: Icon(icon, color: color),
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: color, width: 2),
      ),
    );
  }
}
