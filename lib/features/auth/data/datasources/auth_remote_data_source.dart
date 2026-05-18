import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo_clean_bloc/core/error/exception.dart';
import 'package:todo_clean_bloc/features/auth/data/models/user_model.dart';

abstract interface class AuthRemoteDataSource {
  User? get currentUser => null;

  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<UserModel> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<UserModel> signInWithGoogle();

  Future<void> signOut();

  Future<UserModel?> getCurrentUserData();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;
  final GoogleSignIn googleSignIn;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.firebaseFirestore,
    required this.googleSignIn,
  });

  @override
  User? get currentUser => firebaseAuth.currentUser;

  @override
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (response.user == null) {
        throw ServerException('User tidak ditemukan');
      }
      return UserModel(
        id: response.user!.uid,
        email: response.user!.email ?? '',
        name: response.user!.displayName ?? '',
      );
    } on FirebaseAuthException catch (e) {
      throw ServerException(_mapFirebaseAuthError(e));
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (response.user == null) {
        throw ServerException('Gagal membuat akun');
      }

      await response.user!.updateDisplayName(name);

      await firebaseFirestore.collection('profiles').doc(response.user!.uid).set({
        'id': response.user!.uid,
        'name': name,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return UserModel(
        id: response.user!.uid,
        email: response.user!.email ?? '',
        name: name,
      );
    } on FirebaseAuthException catch (e) {
      throw ServerException(_mapFirebaseAuthError(e));
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        throw ServerException('Login Google dibatalkan');
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await firebaseAuth.signInWithCredential(credential);
      if (userCredential.user == null) {
        throw ServerException('User tidak ditemukan');
      }

      final user = userCredential.user!;

      // Upsert profile – only write if first time
      final profileDoc = await firebaseFirestore
          .collection('profiles')
          .doc(user.uid)
          .get();

      if (!profileDoc.exists) {
        await firebaseFirestore.collection('profiles').doc(user.uid).set({
          'id': user.uid,
          'name': user.displayName ?? '',
          'email': user.email ?? '',
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      return UserModel(
        id: user.uid,
        email: user.email ?? '',
        name: user.displayName ?? '',
      );
    } on FirebaseAuthException catch (e) {
      throw ServerException(_mapFirebaseAuthError(e));
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await Future.wait([
        firebaseAuth.signOut(),
        googleSignIn.signOut(),
      ]);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      if (currentUser == null) return null;

      final userData = await firebaseFirestore
          .collection('profiles')
          .doc(currentUser!.uid)
          .get();

      if (userData.exists) {
        final data = userData.data() ?? {};
        return UserModel(
          id: data['id'] ?? currentUser!.uid,
          email: currentUser!.email ?? '',
          name: data['name'] ?? '',
        );
      }

      return null;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  String _mapFirebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Email tidak terdaftar';
      case 'wrong-password':
        return 'Password salah';
      case 'invalid-credential':
        return 'Email atau password salah';
      case 'email-already-in-use':
        return 'Email sudah terdaftar';
      case 'weak-password':
        return 'Password terlalu lemah, minimal 6 karakter';
      case 'invalid-email':
        return 'Format email tidak valid';
      case 'user-disabled':
        return 'Akun dinonaktifkan';
      case 'too-many-requests':
        return 'Terlalu banyak percobaan, coba lagi nanti';
      case 'network-request-failed':
        return 'Tidak ada koneksi internet';
      case 'account-exists-with-different-credential':
        return 'Email sudah terdaftar dengan metode login lain';
      default:
        return e.message ?? 'Terjadi kesalahan autentikasi';
    }
  }
}
