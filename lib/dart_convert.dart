// not used in main app.  Just checking I'm converting dates correctly

import 'package:intl/intl.dart' as intl;

void main() {
 String date = "25 May 1977";
  
 var dt = intl.DateFormat('d MMMM y').parse(date);
  
 print(dt);
}