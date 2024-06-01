import 'dart:math';

String generateVerificationCode() {
  Random random = Random();
  String code = '';

  for (int i = 0; i < 6; i++) {
    code += random.nextInt(10).toString(); // Generate a random 6-digit code
  }

  return code;
}

DateTime generateExpirationTime() {
  return DateTime.now().add(Duration(minutes: 10)); // Set expiry time to 10 minutes from now
}
