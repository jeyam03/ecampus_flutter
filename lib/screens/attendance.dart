import 'package:flutter/material.dart';
import 'package:ecampus_flutter/functions/string_extension.dart';

class Attendance extends StatefulWidget {
  const Attendance({
    Key? key,
    required this.attendance,
    required this.courses,
    required this.lastUpdated,
  }) : super(key: key);

  final List<dynamic>? attendance;
  final List<dynamic>? courses;
  final Map<String, dynamic>? lastUpdated;

  @override
  _AttendanceState createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  List<dynamic>? get attendance => widget.attendance;
  List<dynamic>? get courses => widget.courses;
  Map<String, dynamic>? get lastUpdated => widget.lastUpdated;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text(
                  'Last\nUpdated',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w200,
                  ),
                ),
                const SizedBox(width: 16),
                Row(
                  children: [
                    Text(
                      lastUpdated!['date']!,
                      style: const TextStyle(
                        fontSize: 72,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lastUpdated!['month']!,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        Text(
                          lastUpdated!['year']!,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ]),
            ),
            const SizedBox(height: 16),
            if (attendance != null)
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: attendance!.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 2.5,
                ),
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Theme.of(context).cardColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          attendance![index][0],
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Text(
                          courses![courses!.indexWhere((element) => element[0] == attendance![index][0])][1].toString().toTitleCase(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          height: 42,
                          alignment: Alignment.centerLeft,
                          child: FractionallySizedBox(
                            widthFactor: int.parse(attendance![index][5]) / 100,
                            child: Container(
                              height: double.infinity,
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: int.parse(attendance![index][5]) <= 85 ? Colors.red[700] : Colors.green[800]),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${attendance![index][4]} / ${attendance![index][1]}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    '${attendance![index][5]}%',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
