String getFirstName(String fullName) {
  if (fullName.isEmpty) {
    return 'N/A';
  }
  return fullName.split(' ')[0];
}

String getFirstandLastNameInitals(String fullName) {
  if (fullName.isEmpty) {
    return 'N/A';
  }
  if (fullName.split(' ').length == 1) {
    return fullName[0];
  }
  List<String> name = fullName.split(' ');
  return name[0][0] + name[1][0];
}