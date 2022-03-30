import 'package:flutter/material.dart';
import 'package:todo_list/shared/theme/app_colors.dart';

class TodoWidget extends StatelessWidget {
  final String label;
  final bool done;
  final VoidCallback deleteTap;

  const TodoWidget({
    Key? key,
    required this.deleteTap,
    required this.label,
    required this.done,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 24,
        right: 24,
        bottom: 8
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 25,
                  height: 25,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: done ? gradientColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                    border: done
                        ? null
                        : Border.all(
                            color: textGray,
                            width: 1.5,
                          ),
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                Flexible(
                  child: Text(
                    label,
                    style: TextStyle(
                        fontSize: 16,
                        color: done ? textBlue : textGray,
                        fontWeight: FontWeight.bold,
                        decoration: done ? TextDecoration.lineThrough : null),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: deleteTap,
            icon: const Icon(
              Icons.delete,
              color: rosa,
            ),
          )
        ],
      ),
    );
  }
}
