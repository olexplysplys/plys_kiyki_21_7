import 'package:flutter/material.dart';
import '../models/student.dart';
import '../models/department.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/students_provider.dart';

class NewStudent extends ConsumerStatefulWidget {
  const NewStudent({
    super.key,
    this.curIndex
  });

  final int? curIndex;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NewStudentState();
}

class _NewStudentState extends ConsumerState<NewStudent> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController gradeController = TextEditingController();
  Department? selectedDepartment;
  Gender? selectedGender;

  @override
  void initState() {
    super.initState();
    if (widget.curIndex != null) {
      final student = ref.read(studentsProvider).studentList[widget.curIndex!];
      firstNameController.text = student.firstName;
      lastNameController.text = student.lastName;
      gradeController.text = student.grade.toString();
      selectedGender = student.gender;
      selectedDepartment = student.department;
    }
  }

  void saveStudent() async {
    final firstName = firstNameController.text;
    final lastName = lastNameController.text;
    final grade = int.tryParse(gradeController.text) ?? 0;

    
    if (widget.curIndex != null) {
      await ref.read(studentsProvider.notifier).editStudent(
            widget.curIndex!,
            firstName,
            lastName,
            selectedDepartment,
            selectedGender,
            grade,
          );
    } else {
      await ref.read(studentsProvider.notifier).addStudent(
            firstName,
            lastName,
            selectedDepartment,
            selectedGender,
            grade,
          );
    }

    if (!context.mounted) return;

    Navigator.of(context).pop();
  }

  void cancel() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(studentsProvider);
    if (state.requestingToNet) {
      return const Center(child: CircularProgressIndicator());
    }
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          top: 16.0,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: firstNameController,
              decoration: const InputDecoration(labelText: 'First Name'),
            ),
            TextField(
              controller: lastNameController,
              decoration: const InputDecoration(labelText: 'Last Name'),
            ),
            TextField(
              controller: gradeController,
              decoration: const InputDecoration(labelText: 'Grade'),
              keyboardType: TextInputType.number,
            ),
            DropdownButton<Department>(
              value: selectedDepartment,
              hint: const Text('Select Department'),
              items: Department.values.map((dept) {
                return DropdownMenuItem(
                  value: dept,
                  child: Row(
                    children: [
                      Icon(
                        departmentIcons[dept],
                        size: 24,
                        color: Colors.deepPurple,
                      ),
                      const SizedBox(width: 8),
                      Text(departmentNames[dept] ?? dept.toString().split('.').last),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) => setState(() => selectedDepartment = value),
            ),
            DropdownButton<Gender>(
              value: selectedGender,
              hint: const Text('Select Gender'),
              items: Gender.values.map((gen) {
                return DropdownMenuItem(
                  value: gen,
                  child: Text(gen.toString().split('.').last),
                );
              }).toList(),
              onChanged: (value) => setState(() => selectedGender = value),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: saveStudent,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text('Save'),
                ),
                TextButton(
                  onPressed: cancel,
                  child: const Text('Cancel', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
