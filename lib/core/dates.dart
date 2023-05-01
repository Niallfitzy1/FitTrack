import 'package:intl/intl.dart';

import 'localisation.dart';

final DateFormat timeFormat = intl.date().add_Hm();
final firstDate = DateTime(2015);
final lastDate = DateTime(2100);

DateTime Function(DateTime date) getAsDate = (date) {
  return DateTime(date.year, date.month, date.day);
};

String Function(DateTime date) formatAsRelativeDate = (date) {
  int relativeDays = date.difference(DateTime.now()).inDays.abs();

  if (relativeDays < 1) {
    return intl.date('HH:mm').format(date);
  }

  if (relativeDays < 7) {
    return intl.date('EEEE').format(date);
  }

  return intl.date('d MMM').format(date);
};

String Function(DateTime date) formatAsDate = (date) {
  int relativeDays = date.difference(DateTime.now()).inDays.abs();

  if (relativeDays < 7) {
    return intl.date('EEEE').format(date);
  }

  return intl.date('d MMM').format(date);
};

String Function(DateTime date) formatAsTime = (date) {
  return timeFormat.format(date);
};
