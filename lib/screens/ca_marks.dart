import 'package:flutter/material.dart';
import 'package:ecampus_flutter/components/ca_marks_grid.dart';
import 'package:ecampus_flutter/components/project_marks_grid.dart';

class CaMarks extends StatefulWidget {
  const CaMarks({
    Key? key,
    required this.coreTitles,
    required this.coreMarks,
    required this.additionalTitles,
    required this.additionalMarks,
    required this.projectTitles,
    required this.projectMarks,
  }) : super(key: key);

  final List<dynamic>? coreTitles;
  final List<dynamic>? coreMarks;
  final List<dynamic>? additionalTitles;
  final List<dynamic>? additionalMarks;
  final List<dynamic>? projectTitles;
  final List<dynamic>? projectMarks;

  @override
  _CaMarksState createState() => _CaMarksState();
}

class _CaMarksState extends State<CaMarks> {
  List<dynamic>? get coreTitles => widget.coreTitles;
  List<dynamic>? get coreMarks => widget.coreMarks;
  List<dynamic>? get additionalTitles => widget.additionalTitles;
  List<dynamic>? get additionalMarks => widget.additionalMarks;
  List<dynamic>? get projectTitles => widget.projectTitles;
  List<dynamic>? get projectMarks => widget.projectMarks;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CaMarksGrid(
              marks: coreMarks,
              titles: coreTitles,
              core: true,
            ),
            const SizedBox(height: 16),
            CaMarksGrid(
              marks: additionalMarks,
              titles: additionalTitles,
            ),
            const SizedBox(height: 16),
            ProjectMarksGrid(
              marks: projectMarks,
              titles: projectTitles,
            ),
          ],
        ),
      ),
    );
  }
}
