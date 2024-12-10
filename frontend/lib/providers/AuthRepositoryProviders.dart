import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping/repository/AuthRepository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});
