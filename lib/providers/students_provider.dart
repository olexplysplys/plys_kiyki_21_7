import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/student.dart';

class StudentsState {
  final List<Student> studentList;
  final bool requestingToNet;
  final String? failedStr;

  StudentsState({
    required this.studentList,
    required this.requestingToNet,
    this.failedStr,
  });

  StudentsState copyWith({
    List<Student>? students,
    bool? isLoading,
    String? errorMessage,
  }) {
    return StudentsState(
      studentList: students ?? this.studentList,
      requestingToNet: isLoading ?? this.requestingToNet,
      failedStr: errorMessage ?? this.failedStr,
    );
  }
}

class StudentsNotifier extends StateNotifier<StudentsState> {
  StudentsNotifier() : super(StudentsState(studentList: [], requestingToNet: false));

  Student? _removedStudent;
  int? _removedIndex;

  Future<void> loadStudents() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final students = await Student.remoteGetList();
      state = state.copyWith(students: students, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load students: $e',
      );
    }
  }

  Future<void> addStudent(
    String firstName,
    String lastName,
    department,
    gender,
    int grade,
  ) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      final student = await Student.remoteCreate(
          firstName, lastName, department, gender, grade);
      state = state.copyWith(
        students: [...state.studentList, student],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to add student: $e',
      );
    }
  }

  Future<void> editStudent(
    int index,
    String firstName,
    String lastName,
    department,
    gender,
    int grade,
  ) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final updatedStudent = await Student.remoteUpdate(
        state.studentList[index].id,
        firstName,
        lastName,
        department,
        gender,
        grade,
      );
      final updatedList = [...state.studentList];
      updatedList[index] = updatedStudent;
      state = state.copyWith(students: updatedList, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to edit student: $e',
      );
    }
  }

  void removeStudent(int index) {
    _removedStudent = state.studentList[index];
    _removedIndex = index;
    final updatedList = [...state.studentList];
    updatedList.removeAt(index);
    state = state.copyWith(students: updatedList);
  }

  void undo() {
    if (_removedStudent != null && _removedIndex != null) {
      final updatedList = [...state.studentList];
      updatedList.insert(_removedIndex!, _removedStudent!);
      state = state.copyWith(students: updatedList);
    }
  }

  Future<void> erase() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      if (_removedStudent != null) {
        await Student.remoteDelete(_removedStudent!.id);
        _removedStudent = null;
        _removedIndex = null;
      }
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to delete student: $e',
      );
    }
  }
}

final studentsProvider =
    StateNotifierProvider<StudentsNotifier, StudentsState>((ref) {

  final notifier = StudentsNotifier();
  notifier.loadStudents();
  return notifier;
});
