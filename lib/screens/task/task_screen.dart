import 'package:flutter/material.dart';
import 'package:todo_list/models/task_model.dart';
import 'package:todo_list/models/todo_model.dart';
import 'package:todo_list/services/database_helper.dart';
import 'package:todo_list/shared/theme/app_colors.dart';
import 'package:todo_list/shared/widgets/floating_button.dart';
import 'package:todo_list/shared/widgets/todo_widget.dart';

class TaskScreen extends StatefulWidget {
  final TaskModel? task;

  const TaskScreen({Key? key, this.task}) : super(key: key);

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final DataBaseHelper _dbHelper = DataBaseHelper();
  final title = TextEditingController();
  final description = TextEditingController();
  final todo = TextEditingController();
  int taskId = 0;
  FocusNode? _titleFocus;
  FocusNode? _descriptionFocus;
  FocusNode? _todoFocus;
  bool _contentVisible = false;

  @override
  void initState() {
    if (widget.task != null) {
      _contentVisible = true;
      title.text = widget.task!.title ?? "";
      description.text = widget.task!.description ?? "";
      taskId = widget.task!.id!;
    }

    _titleFocus = FocusNode();
    _descriptionFocus = FocusNode();
    _todoFocus = FocusNode();

    if (widget.task == null) _titleFocus!.requestFocus();

    super.initState();
  }

  @override
  void dispose() {
    _titleFocus?.dispose();
    _descriptionFocus?.dispose();
    _todoFocus?.dispose();
    super.dispose();
  }

  //This create a new task
  Future<void> onTitleEdit(String text) async {
    if (widget.task == null) {
      taskId = await _dbHelper.addTask(TaskModel(title: text));
      setState(() => _contentVisible = true);
    } else {
      await _dbHelper.updateTaskTitle(taskId, text);
    }
    _descriptionFocus!.requestFocus();
  }

  Future<void> updateDescription(String text) async {
    if (taskId != 0) {
      await _dbHelper.updateTaskDescription(taskId, text);
    }
    _todoFocus!.requestFocus();
  }

  Future<void> createTodo(String text) async {
    if (taskId != 0) {
      await _dbHelper.addTodo(
        TodoModel(
          title: text,
          isDone: 0,
          taskId: taskId,
        ),
      );
      setState(() {});
      _todoFocus!.requestFocus();
    }
  }

  Future<void> updateTodoItem(TodoModel todo) async {
    if (todo.isDone == 0) {
      await _dbHelper.updateTodoItem(todo.id!, 1);
    } else {
      await _dbHelper.updateTodoItem(todo.id!, 0);
    }
    setState(() {});
  }

  Future<void> deleteTask() async {
    if (taskId != 0) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: const Text("Deseja excluir toda a tarefa?"),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: rosa,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text(
                "Cancelar",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                await _dbHelper.deleteTask(taskId);
                Navigator.pop(context, true);
              },
              child: const Text(
                "Sim, excluir",
                style: TextStyle(color: textBlue),
              ),
            ),
          ],
        ),
      ).then((value){
        if(value){
          Navigator.pop(context);
        }
      });
      
    }
  }

  Future<void> deleteItem(int id) async {
    await _dbHelper.deleteTodo(id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //AppBar
                Padding(
                  padding: const EdgeInsets.only(bottom: 12, top: 24),
                  child: Row(
                    children: [
                      const BackButton(color: gradientColor),
                      Expanded(
                        child: TextField(
                          controller: title,
                          focusNode: _titleFocus,
                          onSubmitted: (value) async {
                            if (value.isNotEmpty) {
                              onTitleEdit(value);
                            }
                          },
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: textBlue,
                          ),
                          decoration: const InputDecoration(
                            hintText: "Task title",
                            border: InputBorder.none,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                //Description
                Visibility(
                  visible: _contentVisible,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: TextField(
                      controller: description,
                      onSubmitted: (value) {
                        if (value.isNotEmpty) {
                          updateDescription(value);
                        }
                      },
                      focusNode: _descriptionFocus,
                      style: const TextStyle(
                        fontSize: 18,
                        color: textBlue,
                      ),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 24),
                        hintText: "Descrição da tarefa",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                //TodoList
                Visibility(
                  visible: _contentVisible,
                  child: Expanded(
                    child: FutureBuilder<List<TodoModel>>(
                      future: _dbHelper.getTodo(taskId),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(textBlue),
                            ),
                          );
                        } else if (snapshot.data!.isEmpty) {
                          return Center(
                            child: Image.asset(
                              "assets/images/empty_list.png",
                              height: 250,
                            ),
                          );
                        } else {
                          return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, i) {
                              return InkWell(
                                onTap: () {
                                  updateTodoItem(snapshot.data![i]);
                                },
                                child: TodoWidget(
                                  label: snapshot.data![i].title!,
                                  done: snapshot.data![i].isDone! == 1
                                      ? true
                                      : false,
                                  deleteTap: () => deleteItem(snapshot.data![i].id!),
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                ),
                //Input new todo
                Visibility(
                  visible: _contentVisible,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 25,
                          height: 25,
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: textGray,
                              width: 1.5,
                            ),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.grey,
                            size: 18,
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: todo,
                            focusNode: _todoFocus,
                            onSubmitted: (value) async {
                              if (value.isNotEmpty) {
                                await createTodo(value);
                                todo.clear();
                              }
                            },
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Crie um novo item",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            //Delete task
            Visibility(
              visible: _contentVisible,
              child: FloatingButton(
                onTap: deleteTask,
                rightPadding: 24,
                bottomPadding: 24,
                color: rosa,
                icon: Icons.delete_forever,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
