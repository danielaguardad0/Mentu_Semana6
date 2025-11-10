

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mentu_app/domain/entities/task_entity.dart';
import 'package:mentu_app/presentation/providers/tasks_provider.dart';


const Color primaryColor = Colors.blue;
const Color cardBackgroundColor = Colors.white;

class TaskFormScreen extends ConsumerStatefulWidget {
  final TaskEntity? taskToEdit; 

  const TaskFormScreen({super.key, this.taskToEdit});

  @override
  ConsumerState<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends ConsumerState<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  
  late TextEditingController _titleController;
  late TextEditingController _subjectController;
  late String _selectedDueDate;
  late String _selectedDueTime;
  late Color _selectedColor;

  
  final List<String> _dueDateOptions = [
    'Today, Monday 17',
    'Thursday 18',
    'Friday 19',
    'Next Week'
  ];
  final List<String> _dueTimeOptions = [
    '11:30 AM',
    '2:00 PM',
    '4:00 PM',
    '6:00 PM'
  ];
  final List<Color> _colorOptions = [
    Colors.blue,
    Colors.pinkAccent,
    Colors.orange,
    const Color(0xFF4CAF50),
    Colors.purple
  ];

  @override
  void initState() {
    super.initState();
    final isEditing = widget.taskToEdit != null;
    final task = widget.taskToEdit;

    
    _titleController =
        TextEditingController(text: isEditing ? task!.title : '');
    _subjectController =
        TextEditingController(text: isEditing ? task!.subject : '');
    _selectedDueDate = isEditing ? task!.dueDate : _dueDateOptions.first;
    _selectedDueTime = isEditing ? task!.dueTime : _dueTimeOptions.first;
    _selectedColor = isEditing ? task!.color : _colorOptions.first;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subjectController.dispose();
    super.dispose();
  }

  void _saveTask() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final notifier = ref.read(tasksNotifierProvider.notifier);

    try {
      if (widget.taskToEdit == null) {
        
        await notifier.createTask(
          _titleController.text.trim(),
          _subjectController.text.trim(),
          _selectedDueTime,
          _selectedDueDate,
        );
        _showSnackbar('Tarea creada exitosamente.', Colors.green);
      } else {
        
        final updatedTask = widget.taskToEdit!.copyWith(
          title: _titleController.text.trim(),
          subject: _subjectController.text.trim(),
          dueTime: _selectedDueTime,
          dueDate: _selectedDueDate,
          color: _selectedColor,
        );
        await notifier.updateTask(
            updatedTask); 
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

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.taskToEdit != null;

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
              _buildSubjectField(),
              const SizedBox(height: 30),

              
              Row(
                children: [
                  Expanded(
                      child: _buildDropdownField(
                          'Due Date',
                          _selectedDueDate,
                          _dueDateOptions,
                          (v) => setState(() => _selectedDueDate = v!))),
                  const SizedBox(width: 15),
                  Expanded(
                      child: _buildDropdownField(
                          'Due Time',
                          _selectedDueTime,
                          _dueTimeOptions,
                          (v) => setState(() => _selectedDueTime = v!))),
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

  Widget _buildSubjectField() {
    return TextFormField(
      controller: _subjectController,
      decoration:
          _inputDecoration('Subject', Icons.book_outlined, primaryColor),
      validator: (v) => v!.isEmpty ? 'Subject cannot be empty' : null,
    );
  }

  Widget _buildDropdownField(String label, String currentValue,
      List<String> items, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: currentValue,
      decoration: _inputDecoration(label, Icons.calendar_today, primaryColor),
      items: items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, style: GoogleFonts.inter(fontSize: 14)),
        );
      }).toList(),
      onChanged: onChanged,
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
