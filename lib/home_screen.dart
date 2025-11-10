import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/time_entry_provider.dart';
import 'providers/project_task_provider.dart';
import 'models/time_entry.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final projectTask = Provider.of<ProjectTaskProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Time Entries'),
        actions: [
          IconButton(
            icon: const Icon(Icons.folder),
            tooltip: 'Manage Projects & Tasks',
            onPressed: () => Navigator.pushNamed(context, '/manage'),
          ),
        ],
      ),
      body: Consumer<TimeEntryProvider>(
        builder: (context, provider, child) {
          if (provider.entries.isEmpty) {
            return const Center(child: Text('No time entries yet.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(8),
            itemCount: provider.entries.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final TimeEntry entry = provider.entries[index];
              final projectName = projectTask.getProjectNameById(entry.projectId);
              final taskName = projectTask.getTaskNameById(entry.taskId);
              final dateStr =
                  '${entry.date.day}/${entry.date.month}/${entry.date.year}';

              return ListTile(
                title: Text('$projectName • $taskName'),
                subtitle: Text('$dateStr • ${entry.totalTime.toStringAsFixed(2)} hrs\n${entry.notes}'),
                isThreeLine: true,
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () =>
                      context.read<TimeEntryProvider>().deleteEntry(entry.id),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/add'),
        child: const Icon(Icons.add),
        tooltip: 'Add Time Entry',
      ),
    );
  }
}
