import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';

import '../components/menu_tile.dart';
import '../models/student.dart';
import '../models/faculty.dart';

import '../repositories/student_repository.dart';
import '../repositories/faculty_repository.dart';

final userProvider =
    StateNotifierProvider<UserProvider, UserState>((ref) => UserProvider(ref));

class UserState {
  final Student student;
  final Faculty faculty;
  final bool toggleSearch;
  final TextEditingController searchController;
  final List<MenuTile> menuTiles;

  UserState({
    required this.student,
    required this.faculty,
    required this.toggleSearch,
    required this.searchController,
    required this.menuTiles,
  });

  UserState copyWith({
    Student? student,
    Faculty? faculty,
    bool? toggleSearch,
    TextEditingController? searchController,
    List<MenuTile>? menuTiles,
  }) {
    return UserState(
        student: student ?? this.student,
        faculty: faculty ?? this.faculty,
        toggleSearch: toggleSearch ?? this.toggleSearch,
        searchController: searchController ?? this.searchController,
        menuTiles: menuTiles ?? this.menuTiles);
  }
}

class UserProvider extends StateNotifier<UserState> {
  UserProvider(Ref ref)
      : super(
          UserState(
            student: Student(
              id: '',
              name: '',
              email: '',
              rollNumber: '',
              about: '',
              profilePicURI: '',
              branch: '',
              graduationYear: null,
              skills: [],
              achievements: [],
              roles: [],
            ),
            faculty: Faculty(
              id: '',
              name: '',
              email: '',
              department: '',
              cabinNumber: '',
              courses: [],
            ),
            searchController: TextEditingController(),
            toggleSearch: false,
            menuTiles: [],
          ),
        );
  get searchController => state.searchController;

  get toggleSearch => state.toggleSearch;

  get menuTiles => state.menuTiles;

  final Logger _logger = Logger();

  void buildMenuTiles(BuildContext context) {
    List<MenuTile> menuTiles = [
      MenuTile(
        title: "View\nStudents",
        onTap: () => context.push('/user_home/view_students'),
        icon: Icons.add,
        primaryColor: Colors.greenAccent.shade100,
        secondaryColor: Colors.greenAccent.shade200,
      ),
      MenuTile(
        title: "View\nCourses",
        onTap: () => context.push('/user_home/view_courses'),
        icon: Icons.add,
        primaryColor: Colors.lightBlueAccent.shade100,
        secondaryColor: Colors.lightBlueAccent.shade200,
      ),
      MenuTile(
        title: "View\nFaculty",
        onTap: () => context.push('/user_home/view_faculty'),
        icon: Icons.add,
        primaryColor: Colors.orangeAccent.shade100,
        secondaryColor: Colors.orangeAccent.shade200,
      ),
      MenuTile(
        title: "View\nMess\nMenu",
        onTap: () => context.push('/user_home/view_menu'),
        icon: Icons.add,
        primaryColor: Colors.blueAccent.shade100,
        secondaryColor: Colors.blueAccent.shade200,
      ),
      MenuTile(
        title: "View\nRooms",
        onTap: () => context.push('/user_home/manage_rooms'),
        icon: Icons.add,
        primaryColor: Colors.tealAccent.shade100,
        secondaryColor: Colors.tealAccent.shade200,
      ),
      MenuTile(
        title: 'Room\nVacancy',
        onTap: () => context.push('/user_home/classroom_vacancy'),
        icon: Icons.add,
        primaryColor: Colors.pinkAccent.shade100,
        secondaryColor: Colors.pinkAccent.shade200,
      ),
      MenuTile(
        title: "Lost\n&\nFound",
        onTap: () => context.push('/user_home/lost_and_found'),
        primaryColor: Colors.orangeAccent.shade100,
        secondaryColor: Colors.orangeAccent.shade200,
        icon: Icons.search,
      ),
    ];
    String query = state.searchController.text;
    state = state.copyWith(
        menuTiles: menuTiles
            .where((element) =>
                element.title.toLowerCase().contains(query.toLowerCase()))
            .toList());
  }

  void toggleSearchBar() {
    state = state.copyWith(toggleSearch: !state.toggleSearch);
  }
}