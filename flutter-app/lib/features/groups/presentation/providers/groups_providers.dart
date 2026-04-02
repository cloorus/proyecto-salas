import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/groups_repository.dart';
import '../../data/repositories/groups_repository_impl.dart';

final groupsRepositoryProvider = Provider<GroupsRepository>((ref) {
  return GroupsRepositoryImpl();
});
