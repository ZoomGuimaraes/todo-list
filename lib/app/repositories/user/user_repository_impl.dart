import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo_list/app/exception/auth_exception.dart';

import 'package:todo_list/app/repositories/user/user_repository.dart';

class UserRepositoryImpl extends UserRepository {
  final FirebaseAuth _firebaseAuth;

  UserRepositoryImpl({
    required FirebaseAuth firebaseAuth,
  }) : _firebaseAuth = firebaseAuth;

  @override
  Future<User?> register(String email, String password) async {
    try {
      final userCredencial = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return userCredencial.user;
    } on FirebaseAuthException catch (e, s) {
      print(e);
      print(s);
      // email-already-exists
      if (e.code == 'email-already-in-use') {
        final loginTypes =
            await _firebaseAuth.fetchSignInMethodsForEmail(email);
        if (loginTypes.contains('password')) {
          throw AuthException(
              message:
                  'E-mail já foi utilizado, por favor escolha outro e-mail');
        } else {
          throw AuthException(
              message:
                  'Você se cadastrou no TodoList pelo Google, por favor utiliza a forma de login, Google!!!');
        }
      } else {
        throw AuthException(message: e.message ?? 'Erro ao registrar usuário');
      }
    }
  }

  @override
  Future<User?> login(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential.user;
    } on PlatformException catch (e, s) {
      print(e);
      print(s);
      throw AuthException(message: e.message ?? 'Erro ao realizar login!');
    } on FirebaseAuthException catch (e, s) {
      print(e);
      print(s);

      if (e.code == 'wrong-password') {
        throw AuthException(message: 'Login ou senha inválidos');
      }
      throw AuthException(message: e.message ?? 'Erro ao realizar login!');
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      final loginMethods =
          await _firebaseAuth.fetchSignInMethodsForEmail(email);

      if (loginMethods.contains('password')) {
        await _firebaseAuth.sendPasswordResetEmail(email: email);
      } else if (loginMethods.contains('google')) {
        throw AuthException(
            message:
                'Cadastro realizado com o google, não é possivél recuperar a senha');
      } else {
        throw AuthException(message: 'E-mail não cadastrado');
      }
    } on PlatformException catch (e, s) {
      print(e);
      print(s);
      throw AuthException(message: 'Erro ao recuperar senha');
    }
  }

  @override
  Future<User?> googleLogin() async {
    List<String>? loginMethods;

    try {
      final googleSingIN = GoogleSignIn();
      final googleUser = await googleSingIN.signIn();

      if (googleUser != null) {
        loginMethods =
            await _firebaseAuth.fetchSignInMethodsForEmail(googleUser.email);
        if (loginMethods.contains('password')) {
          throw AuthException(message: 'Usuário com cadastro por senha');
        } else {
          final googleAuth = await googleUser.authentication;
          final firebaseCredencial = GoogleAuthProvider.credential(
              accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
          final userCredencial =
              await _firebaseAuth.signInWithCredential(firebaseCredencial);
          return userCredencial.user;
        }
      }
    } on FirebaseAuthException catch (e, s) {
      print(e);
      print(s);

      if (e.code == 'account-exists-with-different-credential') {
        throw AuthException(
            message: '''Login inválido, você se registrou como os provedores:
            ${loginMethods?.join(',')}
            ''');
      } else {
        throw AuthException(message: 'Erro ao realizar login');
      }
    }
  }

  @override
  Future<void> logout() async {
    await GoogleSignIn().signOut();
    _firebaseAuth.signOut();
  }

  @override
  Future<void> updateDisplayName(String name) async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      await user.updateDisplayName(name);
      user.reload();
    }
  }
}
