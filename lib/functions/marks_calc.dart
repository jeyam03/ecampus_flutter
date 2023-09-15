double gpaCalculator(results) {
  int totalCredits = 0;
  int totalPoints = 0;
  for (var result in results) {
    totalCredits += int.parse(result[3]);
    totalPoints += int.parse(result[3]) * (int.tryParse(result[4].split(' ')[0].toString()) ?? 0);
  }
  return totalPoints / totalCredits;
}

double caAverage(caMarks) {
  double avg = 0;

  double ca1 = double.tryParse(caMarks[2]) ?? 0;
  double ca2 = double.tryParse(caMarks[3]) ?? 0;
  double ca3 = double.tryParse(caMarks[4]) ?? 0;

  List<double> caList = [ca1, ca2, ca3];
  caList.sort((a, b) => b.compareTo(a));
  avg = (caList[0] + caList[1]) / 2;
  return avg;
}

double totalCaMarks(marks) {
  double totalMarks = 0;

  double caAvg = caAverage(marks);
  double tut1 = double.tryParse(marks[6]) ?? 0;
  double tut2 = double.tryParse(marks[7]) ?? 0;
  double ap = double.tryParse(marks[8]) ?? 0;

  totalMarks = caAvg + tut1 + tut2 + ap;
  return totalMarks;
}

double projectMarks(marks) {
  double totalMarks = 0;

  double r1g = double.tryParse(marks[2]) ?? 0;
  double r2g = double.tryParse(marks[3]) ?? 0;
  double r3g = double.tryParse(marks[4]) ?? 0;
  double r4g = double.tryParse(marks[5]) ?? 0;

  totalMarks = r1g + r2g + r3g + r4g;
  return totalMarks;
}
