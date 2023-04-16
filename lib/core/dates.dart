import 'package:intl/intl.dart';

import 'localisation.dart';

final DateFormat dateFormat = intl.date('EEE, d MMM');
final DateFormat timeFormat = intl.date().add_Hm();
final firstDate = DateTime(2015);
final lastDate = DateTime(2100);

DateTime Function(DateTime date) getAsDate = (date) {
  return DateTime(date.year, date.month, date.day);
};

String Function(DateTime date) formatAsDate = (date) {
  return dateFormat.format(date);
};
String Function(DateTime date) formatAsTime = (date) {
  return timeFormat.format(date);
};
