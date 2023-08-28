import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:tarefas/page/data_class.dart';

class TarefaRepository extends ChangeNotifier {
  List<TaskData> _tarefa = [];

  UnmodifiableListView<TaskData> get lista => UnmodifiableListView(_tarefa);

  saveAll(List<TaskData> tarefas) {
    tarefas.forEach((tarefa) {
      if (!_tarefa.contains(tarefa)) _tarefa.add(tarefa);
    });
    notifyListeners();
  }

  remove(TaskData tarefa) {
    _tarefa.remove(tarefa);
    notifyListeners();
  }
}
