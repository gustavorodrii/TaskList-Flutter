import 'package:flutter/material.dart';
import 'package:tarefas/config/custom_colors.dart';
import 'package:tarefas/page/home_page.dart';
import 'package:tarefas/page/data_class.dart';

class RegisterItem extends StatefulWidget {
  const RegisterItem({super.key, required this.onAddTask});
  final Function(TaskData taskData) onAddTask;

  @override
  State<RegisterItem> createState() => _RegisterItemState();
}

class _RegisterItemState extends State<RegisterItem> {
  TextEditingController taskNameController = TextEditingController();
  List<String> selectedTags = [];
  bool? isChecked = false;
  DateTime dateTime = DateTime(2023, 06, 1, 12, 00);

  String taskName = '';
  List<String> taskTags = [];

  void addTask() async {
    taskName = taskNameController.text;
    taskTags = List.from(selectedTags);

    if (taskName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'O nome da tarefa é obrigatório',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (taskTags.length > 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Você só pode adicionar até 2 tags',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    TaskData taskData = TaskData(
      taskName: taskName,
      tags: taskTags,
      dateTime: dateTime,
      isNoDateAndTime: isChecked ?? false,
    );

    widget.onAddTask(taskData);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(taskData: taskData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final hours = dateTime.hour.toString().padLeft(2, '0');
    final minutes = dateTime.minute.toString().padLeft(2, '0');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Tarefa'),
        backgroundColor: Colors.transparent,
      ),
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Text('Nome da Tarefa'),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 50,
                      child: TextFormField(
                        controller: taskNameController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 0.8, color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFFa2dfc0),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Row(
                      children: [
                        Text('Selecione a Tag'),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      children: [
                        _buildTagChips(),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Row(
                      children: [
                        Text('Selecione o Dia e Horário da Tarefa'),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              final date = await pickDate();
                              if (date == null) return;

                              final newDateTime = DateTime(
                                date.year,
                                date.month,
                                date.day,
                                dateTime.hour,
                                dateTime.minute,
                              );

                              setState(() => dateTime = newDateTime);
                            },
                            child: Text(
                              '${dateTime.day}/${dateTime.month}/${dateTime.year}',
                            ),
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.grey),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              final time = await pickTime();
                              if (time == null) return;
                              final newDateTime = DateTime(
                                dateTime.year,
                                dateTime.month,
                                dateTime.day,
                                time.hour,
                                time.minute,
                              );
                              setState(() => dateTime = newDateTime);
                            },
                            child: Text('$hours:$minutes'),
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.grey),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Checkbox(
                          value: isChecked,
                          activeColor: CustomColors.customContrastColor,
                          onChanged: (newBool) {
                            setState(() {
                              isChecked = newBool;
                            });
                          },
                        ),
                        Text('Não quero marcar data e horário'),
                      ],
                    ),
                    FloatingActionButton.extended(
                      onPressed: addTask,
                      label: Text('Adicionar Tarefa'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<TimeOfDay?> pickTime() => showTimePicker(
        context: context,
        initialTime: TimeOfDay(
          hour: dateTime.hour,
          minute: dateTime.minute,
        ),
      );

  Future<DateTime?> pickDate() => showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: DateTime(1950),
        lastDate: DateTime(2100),
      );

  Widget _buildTagChips() {
    List<String> tags = [
      'Escola',
      'Trabalho',
      'Faculdade',
      'Importante',
    ];

    List<Widget> chips = [];
    for (String tag in tags) {
      chips.add(
        ChoiceChip(
          label: Text(tag),
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          selected: selectedTags.contains(tag),
          selectedColor: CustomColors.customContrastColor,
          backgroundColor: Colors.grey,
          onSelected: (bool selected) {
            setState(() {
              if (selected) {
                selectedTags.add(tag);
              } else {
                selectedTags.remove(tag);
              }
            });
          },
        ),
      );
    }

    return Wrap(
      spacing: 5.0,
      children: chips,
    );
  }
}
