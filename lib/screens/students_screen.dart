import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/student.dart';
import '../providers/students_provider.dart';
import '../widgets/student_item.dart';
import '../widgets/new_student.dart';

class StudentsScreen extends ConsumerWidget {
  const StudentsScreen({Key? key}) : super(key: key);

  void _addOrEditStudent(BuildContext context, WidgetRef ref,
      {Student? student, int? index}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return NewStudent(
          student: student,
          onSave: (newStudent) {
            if (student != null && index != null) {
              ref
                  .read(studentsProvider.notifier)
                  .editStudent(newStudent, index);
            } else {
              ref.read(studentsProvider.notifier).addStudent(newStudent);
            }
          },
        );
      },
    );
  }

  void _deleteStudent(BuildContext context, WidgetRef ref, int index) {
    ref.read(studentsProvider.notifier).removeStudent(index);
    final container = ProviderScope.containerOf(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Студента видалено'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            container.read(studentsProvider.notifier).undo();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final students = ref.watch(studentsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Студенти'),
      ),
      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {
          final student = students[index];
          return Dismissible(
            key: ValueKey(student),
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 20),
              child: const Icon(Icons.delete, color: Colors.white, size: 32),
            ),
            direction: DismissDirection.startToEnd,
            onDismissed: (_) => _deleteStudent(context, ref, index),
            child: InkWell(
              onTap: () => _addOrEditStudent(context, ref,
                  student: student, index: index),
              child: StudentItem(student: student),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrEditStudent(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }
}
