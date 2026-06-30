extension Datehelpers on DateTime {
  String toDateFormat_11jan2025() {
    int currentYear = DateTime.now().year;
    if (day == DateTime.now().day &&
        month == DateTime.now().month &&
        year == currentYear) {
      return "Today";
    }
    if (day+1 == DateTime.now().day &&
        month == DateTime.now().month &&
        year == currentYear) {
      return "Yesterday";
    }
    return "$day ${monthName(month).substring(0, 3)} ${currentYear == year ? "" : year.toString()}";
  }

  DateTime removeTimePart() {
    return DateTime(year, month, day);
  }

  String getMonthName() {
    return monthName(month);
  }
}

// extension Datehelpers on DateTime {

// }

extension Datehelpers2 on int {}

String monthName(int month) {
  const months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];

  return months[month - 1];
}
