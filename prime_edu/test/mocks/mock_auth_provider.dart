import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prime_edu/models/user_model.dart';

class MockAuthProvider extends ChangeNotifier with Mock {
  UserModel? _currentUser;

  UserModel get currentUser => _currentUser ?? UserModel(
        id: 'test_user_1',
        name: 'Test User',
        email: 'test@example.com',
        userType: UserType.teacher,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

  set currentUser(UserModel user) {
    _currentUser = user;
    notifyListeners();
  }

  // Adicione outros métodos conforme necessário para os testes
}
