import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  Future<void> signOut();

  Future<UserModel?> getCurrentUserData();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.firebaseFirestore,
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
        throw ServerException('User tidak ditemukan');
      }

      // Update user profile with name
      await response.user!.updateDisplayName(name);

      // Create user profile document in Firestore
      await firebaseFirestore
          .collection('profiles')
          .doc(response.user!.uid)
          .set({
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
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      if (currentUser != null) {
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
      }

      return null;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
