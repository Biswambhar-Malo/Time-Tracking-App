import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/time_entry.dart';
import 'providers/time_entry_provider.dart';
import 'providers/project_task_provider.dart';

class AddTimeEntryScreen extends StatefulWidget {
  @override
  State<AddTimeEntryScreen> createState() => _AddTimeEntryScreenState();
}

class _AddTimeEntryScreenState extends State<AddTimeEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  String? projectId;
  String? taskId;
  double? totalTime;
  DateTime date = DateTime.now();
  String notes = '';

  @override
  Widget build(BuildContext context) {
    final pt = Provider.of<ProjectTaskProvider>(context);
    final tasksForProject =
    projectId == null ? <dynamic>[] : pt.getTasksByProject(projectId!);

    return Scaffold(
      appBar: AppBar(title: const Text('Add Time Entry')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: projectId,
                decoration: const InputDecoration(labelText: 'Project'),
                items: pt.projects
                    .map((p) => DropdownMenuItem(
                  value: p.id,
                  child: Text(p.name),
                ))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    projectId = val;
                    taskId = null; // reset task when project changes
                  });
                },
                validator: (v) => v == null || v.isEmpty ? 'Select a project' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: taskId,
                decoration: const InputDecoration(labelText: 'Task'),
                items: tasksForProject
                    .map<DropdownMenuItem<String>>(
                      (t) => DropdownMenuItem(
                    value: t.id,
                    child: Text(t.name),
                  ),
                )
                    .toList(),
                onChanged: (val) => setState(() => taskId = val),
                validator: (v) => v == null || v.isEmpty ? 'Select a task' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration:
                const InputDecoration(labelText: 'Total Time (hours)'),
                keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter total time';
                  }
                  final d = double.tryParse(value);
                  if (d == null || d <= 0) {
                    return 'Enter a valid number > 0';
                  }
                  return null;
                },
                onSaved: (value) => totalTime = double.parse(value!.trim()),
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Notes'),
                maxLines: 3,
                validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Please enter notes' : null,
                onSaved: (v) => notes = v!.trim(),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Date: ${date.day}/${date.month}/${date.year}',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.date_range),
                    label: const Text('Pick date'),
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: date,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) setState(() => date = picked);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text('Save Entry'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      final id = DateTime.now().microsecondsSinceEpoch.toString();
                      context.read<TimeEntryProvider>().addTimeEntry(
                        TimeEntry(
                          id: id,
                          projectId: projectId!,
                          taskId: taskId!,
                          totalTime: totalTime!,
                          date: date,
                          notes: notes,
                        ),
                      );
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
