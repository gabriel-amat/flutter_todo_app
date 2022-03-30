class TaskModel{
  final int? id;
  final String? title;
  final String? description;

  TaskModel({this.id, this.title, this.description});

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
    description: json["description"],
    title: json["title"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description
  };

   
}