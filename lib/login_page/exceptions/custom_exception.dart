class CustomException implements Exception {
  final String code;
  final String message;

  const CustomException({
    required this.code,
    required this.message,
  });

  @override
  String toString() {
    return 'CustomException{code: $code, message: $message}';
  }
}



// wrong-password
// email-already-in-use
