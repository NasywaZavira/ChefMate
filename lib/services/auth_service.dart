import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  AuthService({FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseAuth _firebaseAuth;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<User> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user;
    if (user == null) {
      throw StateError('Firebase did not return a user after sign-up.');
    }
    await user.updateDisplayName(name);
    return user;
  }

  Future<User> signIn({required String email, required String password}) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user;
    if (user == null) {
      throw StateError('Firebase did not return a user after sign-in.');
    }
    return user;
  }

  Future<void> signOut() => _firebaseAuth.signOut();
}

String authErrorMessage(FirebaseAuthException exception) {
  switch (exception.code) {
    case 'email-already-in-use':
      return 'Email ini sudah terdaftar. Silakan masuk.';
    case 'invalid-credential':
    case 'wrong-password':
    case 'user-not-found':
      return 'Email atau kata sandi salah.';
    case 'weak-password':
      return 'Kata sandi terlalu lemah. Gunakan minimal 6 karakter.';
    case 'invalid-email':
      return 'Format email tidak valid.';
    case 'user-disabled':
      return 'Akun ini telah dinonaktifkan.';
    case 'too-many-requests':
      return 'Terlalu banyak percobaan. Coba lagi nanti.';
    case 'network-request-failed':
      return 'Tidak dapat terhubung. Periksa koneksi internetmu.';
    case 'operation-not-allowed':
      return 'Metode email dan kata sandi belum diaktifkan di Firebase.';
    default:
      return exception.message ?? 'Autentikasi gagal. Coba lagi.';
  }
}
