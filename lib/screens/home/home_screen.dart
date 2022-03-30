import 'package:flutter/material.dart';
import 'package:todo_list/models/task_model.dart';
import 'package:todo_list/shared/widgets/floating_button.dart';
import 'package:todo_list/shared/widgets/task_card_widget.dart';
import 'package:todo_list/shared/theme/app_colors.dart';

import '../../services/database_helper.dart';
import '../task/task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DataBaseHelper _dbHelper = DataBaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          color: brancoEscuro,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 25),
                    child: FlutterLogo()
                  ),
                  Expanded(
                    child: FutureBuilder<List<TaskModel>>(
                      future: _dbHelper.getTasks(),
                      initialData: const [],
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(textBlue),
                            ),
                          );
                        } else if (snapshot.data!.isEmpty) {
                          return Center(
                            child: Column( 
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Crie sua primeira lista!",
                                  style: TextStyle(
                                    color: azul,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Image.asset("assets/images/create_list.png",
                                  height: 250,
                                ),
                              ],
                            ),
                          );
                        }
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, i) {
                            return TaskCardWidget(
                              label: snapshot.data![i].title,
                              content: snapshot.data![i].description,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TaskScreen(
                                      task: snapshot.data![i],
                                    ),
                                  ),
                                ).then((value){
                                   setState(() {});
                                });
                              },
                            );
                          },
                        );
                      },
                    ),
                  )
                ],
              ),
              FloatingButton(
                color: azul,
                icon: Icons.add,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TaskScreen(),
                    ),
                  ).then((value) {
                    setState(() {});
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
