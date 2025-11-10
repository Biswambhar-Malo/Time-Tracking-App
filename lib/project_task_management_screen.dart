import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/project_task_provider.dart';

class ProjectTaskManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Projects & Tasks')),
      body: Consumer<ProjectTaskProvider>(
        builder: (context, provider, child) {
          final projects = provider.projects;
          if (projects.isEmpty) {
            return const Center(child: Text('No projects yet.'));
          }
          return ListView.builder(
            itemCount: projects.length,
            itemBuilder: (context, i) {
              final p = projects[i];
              final tasks = provider.getTasksByProject(p.id);
              return ExpansionTile(
                title: Text(p.name),
                leading: const Icon(Icons.folder),
                children: [
                  if (tasks.isEmpty)
                    const ListTile(title: Text('No tasks')),
                  ...tasks.map(
                        (t) => ListTile(
                      leading: const Icon(Icons.task_alt_outlined),
                      title: Text(t.name),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () => provider.deleteTask(t.id),
                      ),
                    ),
                  ),
                  ButtonBar(
                    alignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        icon: const Icon(Icons.add),
                        label: const Text('Add Task'),
                        onPressed: () => _showAddTaskDialog(context, p.id),
                      ),
                      TextButton.icon(
                        icon: const Icon(Icons.delete_outline),
                        label: const Text('Delete Project'),
                        onPressed: () => provider.deleteProject(p.id),
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Project',
        child: const Icon(Icons.add),
        onPressed: () => _showAddProjectDialog(context),
      ),
    );
  }

  void _showAddProjectDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('New Project'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Project name'),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                context.read<ProjectTaskProvider>().addProject(name);
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context, String projectId) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('New Task'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Task name'),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                context.read<ProjectTaskProvider>().addTask(projectId, name);
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
