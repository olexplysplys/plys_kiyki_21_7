import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/student.dart';

class StudentsNotifier extends StateNotifier<List<Student>> {
  StudentsNotifier() : super([]);

  Student? _deletedStudent;
  int? _deletedIndex;

  void addStudent(Student student) {
    state = [...state, student];
  }

  void editStudent(Student updatedStudent, int index) {
    final updatedList = [...state];
    updatedList[index] = updatedStudent;
    state = updatedList;
  }

  void removeStudent(int index) {
    _deletedStudent = state[index];
    _deletedIndex = index;

    final updatedList = [...state];
    updatedList.removeAt(index);
    state = updatedList;
  }

  void undo() {
    if (_deletedStudent != null && _deletedIndex != null) {
      final updatedList = [...state];
      updatedList.insert(_deletedIndex!, _deletedStudent!);
      state = updatedList;

      _deletedStudent = null;
      _deletedIndex = null;
    }
  }

  bool canUndo() {
    return _deletedStudent != null && _deletedIndex != null;
  }
}

final studentsProvider =
    StateNotifierProvider<StudentsNotifier, List<Student>>((ref) {
  return StudentsNotifier();
});
