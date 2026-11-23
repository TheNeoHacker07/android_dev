import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

/// Passwords are never stored as plain text. We store a random salt and
/// sha256(salt + password). To check a login we hash the typed password with
/// the same salt and compare the results.
// ponytail: plain sha256 is fine for a local study app; a real backend would
// use a slow hash (bcrypt/argon2) on the server.

String newSalt() {
  final random = Random.secure();
  final bytes = List<int>.generate(16, (_) => random.nextInt(256));
  return base64Url.encode(bytes);
}

String hashPassword(String password, String salt) =>
    sha256.convert(utf8.encode('$salt:$password')).toString();
