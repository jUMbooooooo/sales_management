import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserNotifier extends StateNotifier<User?> {
  UserNotifier() : super(null);

  void setUser(User? user) {
    state = user;
  }
}

final userProvider =
    StateNotifierProvider<UserNotifier, User?>((ref) => UserNotifier());
