bool isNumeric(String s) {
  /// exepcts a string of length 1
  /// returns true if s is numeric, false otherwise
  assert(s.length == 1);
  return s.compareTo('0') >= 0 && s.compareTo('9') <= 0;
}