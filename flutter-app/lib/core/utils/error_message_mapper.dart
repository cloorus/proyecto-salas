import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../features/groups/data/repositories/groups_repository_impl.dart';

/// Maps error codes to localized messages
class ErrorMessageMapper {
  static String mapGroupsError(String errorCode, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    switch (errorCode) {
      case GroupsErrorMessages.groupNotFound:
        return l10n.groupNotFound;
      case GroupsErrorMessages.cannotAddToAllGroup:
        return l10n.cannotAddToAllGroup;
      case GroupsErrorMessages.deviceAlreadyInGroup:
        return l10n.deviceAlreadyInGroup;
      case GroupsErrorMessages.cannotRemoveFromAllGroup:
        return l10n.cannotRemoveFromAllGroup;
      case GroupsErrorMessages.deviceNotInGroup:
        return l10n.deviceNotInGroup;
      case GroupsErrorMessages.nameCannotBeEmpty:
        return l10n.nameCannotBeEmpty;
      case GroupsErrorMessages.groupNameAlreadyExists:
        return l10n.groupNameAlreadyExists;
      case GroupsErrorMessages.cannotModifyAllGroup:
        return l10n.cannotModifyAllGroup;
      case GroupsErrorMessages.cannotDeleteAllGroup:
        return l10n.cannotDeleteAllGroup;
      default:
        return l10n.generalError;
    }
  }
}