import 'package:flutter/material.dart';
import '../models/project.dart';
import '../models/task.dart';

class ProjectTaskProvider with ChangeNotifier {
  final List<Project> _projects = [
    Project(id: 'p1', name: 'Project 1'),
    Project(id: 'p2', name: 'Project 2'),
  ];

  final List<Task> _tasks = [
    Task(id: 't1', projectId: 'p1', name: 'Task 1'),
    Task(id: 't2', projectId: 'p1', name: 'Task 2'),
    Task(id: 't3', projectId: 'p2', name: 'Task A'),
  ];

  List<Project> get projects => List.unmodifiable(_projects);
  List<Task> get tasks => List.unmodifiable(_tasks);

  List<Task> getTasksByProject(String projectId) =>
      _tasks.where((t) => t.projectId == projectId).toList();

  String getProjectNameById(String id) =>
      _projects.firstWhere((p) => p.id == id, orElse: () => Project(id: id, name: 'Unknown')).name;

  String getTaskNameById(String id) =>
      _tasks.firstWhere((t) => t.id == id, orElse: () => Task(id: id, projectId: '', name: 'Unknown')).name;

  void addProject(String name) {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    _projects.add(Project(id: id, name: name));
    notifyListeners();
  }

  void deleteProject(String id) {
    _projects.removeWhere((p) => p.id == id);
    _tasks.removeWhere((t) => t.projectId == id); // cascade delete tasks
    notifyListeners();
  }

  void addTask(String projectId, String name) {
    if (_projects.any((p) => p.id == projectId) == false) return;
    final id = DateTime.now().microsecondsSinceEpoch.toString();
    _tasks.add(Task(id: id, projectId: projectId, name: name));
    notifyListeners();
  }

  void deleteTask(String taskId) {
    _tasks.removeWhere((t) => t.id == taskId);
    notifyListeners();
  }
}
