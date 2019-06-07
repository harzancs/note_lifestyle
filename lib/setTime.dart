import 'package:intl/intl.dart';

DateTime now = DateTime.now();
String formattedDate = DateFormat('dd/MM/yyyy').format(now);
 class setTime {
    String datetime = formattedDate ;
    setTime() : super();
 }