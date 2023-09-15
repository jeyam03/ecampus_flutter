import 'package:ecampus_flutter/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:ecampus_flutter/screens/attendance.dart';
import 'package:ecampus_flutter/screens/ca_marks.dart';
import 'package:ecampus_flutter/screens/sem_results.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({
    Key? key,
    required this.studentName,
    required this.coreTitles,
    required this.coreMarks,
    required this.additionalTitles,
    required this.additionalMarks,
    required this.projectTitles,
    required this.projectMarks,
    required this.attendance,
    required this.courses,
    required this.lastUpdated,
    required this.prevSem,
    required this.semResults,
  }) : super(key: key);

  final String? studentName;
  final List<dynamic>? coreTitles;
  final List<dynamic>? coreMarks;
  final List<dynamic>? additionalTitles;
  final List<dynamic>? additionalMarks;
  final List<dynamic>? projectTitles;
  final List<dynamic>? projectMarks;
  final List<dynamic>? attendance;
  final List<dynamic>? courses;
  final Map<String, dynamic>? lastUpdated;
  final String? prevSem;
  final List<dynamic>? semResults;

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  int _currentIndex = 0;

  String? get studentName => widget.studentName;
  List<dynamic>? get coreTitles => widget.coreTitles;
  List<dynamic>? get coreMarks => widget.coreMarks;
  List<dynamic>? get additionalTitles => widget.additionalTitles;
  List<dynamic>? get additionalMarks => widget.additionalMarks;
  List<dynamic>? get projectTitles => widget.projectTitles;
  List<dynamic>? get projectMarks => widget.projectMarks;
  List<dynamic>? get attendance => widget.attendance;
  List<dynamic>? get courses => widget.courses;
  Map<String, dynamic>? get lastUpdated => widget.lastUpdated;
  String? get prevSem => widget.prevSem;
  List<dynamic>? get semResults => widget.semResults;

  List<Widget> _tabs = [];

  @override
  void initState() {
    super.initState();
    _tabs = [
      CaMarks(
        coreTitles: coreTitles,
        coreMarks: coreMarks,
        additionalTitles: additionalTitles,
        additionalMarks: additionalMarks,
        projectTitles: projectTitles,
        projectMarks: projectMarks,
      ),
      Attendance(
        attendance: attendance,
        courses: courses,
        lastUpdated: lastUpdated,
      ),
      SemResults(
        prevSem: prevSem,
        semResults: semResults,
      ),
      Profile(studentName: studentName),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentIndex == 0
            ? 'CA Marks'
            : _currentIndex == 1
                ? 'Attendance'
                : _currentIndex == 2
                    ? 'Sem Results'
                    : 'Profile'),
        automaticallyImplyLeading: false,
      ),
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'CA Marks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_available),
            label: 'Attendance',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Sem Results',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
