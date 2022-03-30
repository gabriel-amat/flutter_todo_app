import 'package:flutter/material.dart';
import 'package:todo_list/shared/theme/app_colors.dart';

class TaskCardWidget extends StatelessWidget {
  final String? label;
  final String? content;
  final VoidCallback? onTap;

  const TaskCardWidget({
    Key? key,
    required this.onTap,
    required this.label,
    this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          vertical: 32,
          horizontal: 24,
        ),
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: branco,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label ?? "Sem titulo",
              style: const TextStyle(
                color: textBlue,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              content ?? "(Sem descrição)",
              style: const TextStyle(
                color: textGray,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
