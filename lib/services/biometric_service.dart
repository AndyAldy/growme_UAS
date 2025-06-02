import 'package:local_auth/local_auth.dart';

class BiometricService {
  final _auth = LocalAuthentication();

  Future<bool> authenticate() async {
    final canCheck = await _auth.canCheckBiometrics;
    if (!canCheck) return false;
    return await _auth.authenticate(localizedReason: 'Gunakan sidik jari untuk login');
  }
}
