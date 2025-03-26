import 'package:intl/intl.dart';

String formatDateTime(String dateTimeString) {
  DateTime dateTime = DateTime.parse(dateTimeString);
  return DateFormat('MMMM d, yyyy - h:mm a').format(dateTime);
}
