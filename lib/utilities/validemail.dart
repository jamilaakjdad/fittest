bool isValidEmail(String email) {
  // Use a regular expression to validate the email format
  final RegExp emailRegex = RegExp(
    r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$',
  );
  return emailRegex.hasMatch(email);
}
