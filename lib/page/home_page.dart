import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tarefas/config/custom_colors.dart';
import 'package:tarefas/page/favoritos.dart';
import 'package:tarefas/page/feitos.dart';
import 'package:tarefas/page/perfil.dart';
import 'package:tarefas/page/register_item.dart';
import 'package:tarefas/page/tags.dart';
import 'package:tarefas/page/data_class.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.taskData});
  final TaskData? taskData;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<TaskData> taskList = [];

  @override
  void initState() {
    super.initState();
    if (widget.taskData != null) {
      taskList.add(widget.taskData!);
    }
    loadTaskData();
  }

  void loadTaskData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? taskListJson = prefs.getStringList('taskList');
    if (taskListJson != null) {
      List<TaskData> tasks = taskListJson
          .map((taskDataJson) => TaskData.fromJson(jsonDecode(taskDataJson)))
          .toList();

      setState(() {
        taskList = tasks;
      });
    }

    if (widget.taskData != null && !taskList.contains(widget.taskData!)) {
      setState(() {
        taskList.add(widget.taskData!);
      });

      List<String> updatedTaskListJson =
          taskList.map((taskData) => jsonEncode(taskData.toJson())).toList();
      await prefs.setStringList('taskList', updatedTaskListJson);
    }
  }

  void saveTaskList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> taskListJson =
        taskList.map((taskData) => jsonEncode(taskData.toJson())).toList();
    await prefs.setStringList('taskList', taskListJson);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu'),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 20),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: taskList.length,
                itemBuilder: (context, index) {
                  final taskData = taskList[index];

                  return Dismissible(
                    key: Key(taskData.taskName),
                    background: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Container(
                        alignment: Alignment.centerRight,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Icon(Icons.delete_forever),
                        ),
                      ),
                    ),
                    onDismissed: (direction) {
                      setState(() {
                        taskList.removeAt(index);
                      });
                      saveTaskList();
                    },
                    child: Card(
                      color: Colors.white, // Cor de fundo do Card
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(color: Colors.grey, width: 0.5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ), // Espaçamento interno do Card
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Text(
                                    taskData.taskName,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.timer,
                                          color: Colors.black,
                                        ),
                                        SizedBox(width: 4),
                                        Container(
                                          color: Colors.grey.shade400,
                                          padding: const EdgeInsets.all(8),
                                          child: Text(
                                            '${taskData.dateTime.day}/${taskData.dateTime.month}/${taskData.dateTime.year}',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (taskData.isNoDateAndTime)
                                      Container(
                                        color: Colors.grey.shade400,
                                        padding: const EdgeInsets.all(8),
                                        child: Text(
                                          'Sem data e horário',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            Row(
                              children: [
                                const Icon(
                                  Icons.bookmarks_sharp,
                                  color: Colors.black,
                                ),
                                const SizedBox(width: 4),
                                ...taskData.tags.map((tag) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: CustomColors
                                          .customContrastColor, // Fundo da tag
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    margin: const EdgeInsets.only(
                                        right: 8), // Espaçamento entre as tags
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                      vertical: 4,
                                    ), // Espaçamento interno da tag
                                    child: Text(
                                      tag,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ), // Cor do texto da tag
                                    ),
                                  );
                                }).toList(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      drawer: NavigationDrawer(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RegisterItem(
                onAddTask: (TaskData taskData) {},
              ),
            ),
          );
        },
        label: const Text('Nova Tarefa'),
        icon: const Icon(Icons.add),
        elevation: 2,
      ),
    );
  }
}

class NavigationDrawer extends StatelessWidget {
  NavigationDrawer({Key? key}) : super(key: key);

  final user = FirebaseAuth.instance.currentUser!;

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) => Drawer(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              buildHeader(context),
              buildMenuItems(context),
            ],
          ),
        ),
      );

  Widget buildHeader(BuildContext context) => Material(
        color: Colors.grey,
        child: InkWell(
          onTap: () {},
          child: Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
              bottom: 24,
            ),
            child: Column(
              children: [
                Container(
                  width: 104,
                  height: 104,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('assets/pic1.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  user.email!,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  Widget buildMenuItems(BuildContext context) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Wrap(
          runSpacing: 16,
          children: [
            ListTile(
              leading: Icon(
                Icons.home_outlined,
                color: CustomColors.customContrastColor,
              ),
              title: const Text('Menu'),
              onTap: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => HomePage())),
            ),
            ListTile(
              leading: Icon(
                Icons.favorite_border,
                color: CustomColors.customContrastColor,
              ),
              title: const Text('Favoritos'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const FavoritosPage()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.done_all_outlined,
                color: CustomColors.customContrastColor,
              ),
              title: const Text('Feitos'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const FeitosPage()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.bookmarks_sharp,
                color: CustomColors.customContrastColor,
              ),
              title: const Text('Tags'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => TagsPage()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.person,
                color: CustomColors.customContrastColor,
              ),
              title: const Text('Perfil'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const PerfilPage()));
              },
            ),
            Divider(
              thickness: 1,
              color: CustomColors.customContrastColor,
            ),
            ListTile(
              leading: Icon(
                Icons.logout,
                color: CustomColors.customContrastColor,
              ),
              title: const Text('Sair da Conta'),
              onTap: signUserOut,
            ),
          ],
        ),
      );
}
