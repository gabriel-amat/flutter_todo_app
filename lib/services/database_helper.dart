import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_list/models/task_model.dart';
import 'package:todo_list/models/todo_model.dart';

class DataBaseHelper {
  Future<Database> dataBase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'todo_app.db'),
      onCreate: (db, version) async {
        await db.execute(
            "CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, description TEXT)");
        await db.execute(
            "CREATE TABLE todo(id INTEGER PRIMARY KEY, taskId INTEGER, title TEXT, isDone INTEGER)");
      },
      version: 1,
    );
  }

  Future<void> addTodo(TodoModel todo) async {
    Database _db = await dataBase();
    await _db.insert(
      "todo",
      todo.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> addTask(TaskModel task) async {
    Database _db = await dataBase();
    return await _db.insert(
      "tasks",
      task.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateTaskTitle(int id, String title) async {
    Database _db = await dataBase();
    await _db.rawUpdate("UPDATE tasks SET title = '$title' WHERE id = '$id'");
  }

  Future<void> updateTodoItem(int id, int value) async {
    Database _db = await dataBase();
    await _db.rawUpdate("UPDATE todo SET isDone = '$value' WHERE id = '$id'");
  }

  Future<void> updateTaskDescription(int id, String value) async {
    Database _db = await dataBase();
    await _db
        .rawUpdate("UPDATE tasks SET description = '$value' WHERE id = '$id'");
  }

  Future<void> deleteTask(int taskId) async {
    Database _db = await dataBase();
    await _db
        .rawDelete("DELETE FROM tasks WHERE id = '$taskId'");
    await _db
        .rawDelete("DELETE FROM todo WHERE taskId = '$taskId'");
  }

  Future<void> deleteTodo(int id) async {
    Database _db = await dataBase();
    await _db.rawDelete("DELETE FROM todo WHERE id = '$id'");
  }

  Future<List<TaskModel>> getTasks() async {
    Database _db = await dataBase();
    var _res = await _db.query('tasks');
    return List<TaskModel>.from(
      _res.map(
        (e) {
          return TaskModel.fromJson(e);
        },
      ),
    );
  }

  Future<List<TodoModel>> getTodo(int taskId) async {
    Database _db = await dataBase();
    var _res = await _db.rawQuery("SELECT * FROM todo WHERE taskId = $taskId");
    return List<TodoModel>.from(
      _res.map(
        (e) {
          return TodoModel.fromJson(e);
        },
      ),
    );
  }
}
