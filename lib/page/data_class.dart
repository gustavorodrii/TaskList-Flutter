import 'package:flutter/material.dart';

class TaskData {
  String taskName;
  List<String> tags;
  DateTime dateTime;
  bool isNoDateAndTime;
  bool completed;

  Map<String, dynamic> toJson() {
    return {
      'taskName': taskName,
      'tags': tags,
      'dateTime': dateTime.toIso8601String(),
      'isNoDateAndTime': isNoDateAndTime,
    };
  }

  static TaskData fromJson(Map<String, dynamic> json) {
    return TaskData(
      taskName: json['taskName'],
      tags: List<String>.from(json['tags']),
      dateTime: DateTime.parse(json['dateTime']),
      isNoDateAndTime: json['isNoDateAndTime'],
    );
  }

  TaskData({
    required this.taskName,
    required this.tags,
    required this.dateTime,
    required this.isNoDateAndTime,
    this.completed = false,
  });
}

class TaskDataProvider extends ChangeNotifier {
  List<TaskData> feitosList = [];

  void addFeitos(TaskData taskData) {
    feitosList.add(taskData);
    notifyListeners();
  }
}
