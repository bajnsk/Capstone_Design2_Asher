class CustomException implements Exception {
  final String code;
  final String message;

  const CustomException({
    required this.code,
    required this.message,
  });

  @override
  String toString() {
    return message;
  }
}



// wrong-password
// email-already-in-use
