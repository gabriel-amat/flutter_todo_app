class TodoModel {
  int? id;
  int? taskId;
  String? title;
  int? isDone;

  TodoModel({this.id, this.title, this.isDone, this.taskId});

  factory TodoModel.fromJson(Map<String, dynamic> json) => TodoModel(
        isDone: json["isDone"],
        taskId: json["taskId"],
        title: json["title"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "taskId": taskId,
        "title": title,
        "isDone": isDone,
      };
}
