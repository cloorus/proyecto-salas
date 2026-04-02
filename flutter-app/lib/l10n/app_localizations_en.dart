// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'BGnius VITA';

  @override
  String get loginTitle => 'Welcome';

  @override
  String get loginEmailHint => 'Email';

  @override
  String get loginPasswordHint => 'Password';

  @override
  String get loginShowPassword => 'Show';

  @override
  String get loginHidePassword => 'Hide';

  @override
  String get loginRememberMe => 'Remember me';

  @override
  String get loginForgotPassword => 'Forgot my password';

  @override
  String get loginButton => 'Sign In';

  @override
  String get loginCreateAccount => 'Create Account';

  @override
  String get loginLibraryLink => 'Library';

  @override
  String get loginSuccess => 'Welcome to BGnius VITA';

  @override
  String get loginInvalidCredentials => 'Invalid email or password';

  @override
  String get validationRequiredField => 'This field is required';

  @override
  String get validationInvalidEmail => 'Invalid email format';

  @override
  String get validationPasswordRequired => 'Password is required';

  @override
  String get generalError => 'An unexpected error occurred';

  @override
  String get generalLoading => 'Loading...';

  @override
  String get validationEmailRequired => 'Email is required';

  @override
  String get validationPasswordMinLength =>
      'Password must be at least 8 characters';

  @override
  String get validationPasswordUppercase =>
      'Must contain at least one uppercase letter';

  @override
  String get validationPasswordLowercase =>
      'Must contain at least one lowercase letter';

  @override
  String get validationPasswordNumber => 'Must contain at least one number';

  @override
  String get validationPasswordSymbol =>
      'Must contain at least one special symbol';

  @override
  String get validationPasswordsNoMatch => 'Passwords do not match';

  @override
  String get validationConfirmPassword => 'Confirm your password';

  @override
  String get registerTitle => 'Create User';

  @override
  String get registerNameLabel => 'Name';

  @override
  String get registerNameHint => 'Full name';

  @override
  String get registerEmailLabel => 'Email';

  @override
  String get registerEmailHint => 'you@email.com';

  @override
  String get registerAddressLabel => 'Address';

  @override
  String get registerAddressHint => '123 Street';

  @override
  String get registerCountryLabel => 'Country';

  @override
  String get registerCountryHint => 'Select country';

  @override
  String get registerLanguageLabel => 'Language';

  @override
  String get registerLanguageHint => 'Select language';

  @override
  String get registerPasswordLabel => 'Password';

  @override
  String get registerPasswordHint => 'Minimum 8 characters';

  @override
  String get registerConfirmPasswordLabel => 'Repeat Password';

  @override
  String get registerConfirmPasswordHint => 'Confirm your password';

  @override
  String get registerPhonePrefixLabel => 'Prefix';

  @override
  String get registerPhoneLabel => 'Phone';

  @override
  String get registerPhoneHint => '3001234567';

  @override
  String get registerAcceptTerms => 'I accept terms and conditions';

  @override
  String get registerButton => 'Link User';

  @override
  String get registerAlreadyHaveAccount => 'Already have an account? ';

  @override
  String get registerLoginLink => 'Login';

  @override
  String get registerErrorTerms => 'You must accept terms and conditions';

  @override
  String get registerErrorPasswordMismatch => 'Passwords do not match';

  @override
  String get registerSuccess => 'Account created successfully';

  @override
  String get registerError => 'Error creating account';

  @override
  String get forgotPasswordTitle => 'Reset Password';

  @override
  String get forgotPasswordEmailHint => 'Email/User';

  @override
  String get forgotPasswordGetCodeButton => 'Get temporary code';

  @override
  String get forgotPasswordTimeRemaining => 'Time remaining';

  @override
  String get forgotPasswordTimeRemainingOf => 'of temporary password';

  @override
  String get forgotPasswordNewPasswordHint => 'New Password';

  @override
  String get forgotPasswordRepeatPasswordHint => 'Repeat New Password';

  @override
  String get forgotPasswordCodeHint => 'Enter temporary code';

  @override
  String get forgotPasswordResetButton => 'Reset Password';

  @override
  String get forgotPasswordErrorEmail => 'Enter your email';

  @override
  String forgotPasswordCodeSent(String email) {
    return 'Code sent to $email';
  }

  @override
  String get forgotPasswordErrorPasswordMismatch => 'Passwords do not match';

  @override
  String get forgotPasswordSuccess => 'Password reset successfully';

  @override
  String get eventLogTitle => 'Event Log';

  @override
  String get eventLogDownload => 'Download logs';

  @override
  String eventLogDownloading(int count) {
    return 'Downloading $count logs...';
  }

  @override
  String get eventLogEmpty => 'No events recorded';

  @override
  String get deviceInfoTitle => 'Device Information';

  @override
  String get deviceInfoSerialLabel => 'Serial No.:';

  @override
  String get deviceInfoNameLabel => 'Name:';

  @override
  String get deviceInfoVersionLabel => 'Current Version:';

  @override
  String get deviceInfoTotalCyclesLabel => 'Total Cycles:';

  @override
  String get deviceInfoActivationDateLabel => 'Activation Date:';

  @override
  String get deviceInfoStatusLabel => 'Status';

  @override
  String get deviceInfoUpdateBtn => 'Update device';

  @override
  String get deviceInfoOneMaintenance => '1 maintenance';

  @override
  String get deviceInfoGroupLabel => 'Group:';

  @override
  String get deviceInfoFavoriteLabel => 'Favorite:';

  @override
  String get deviceInfoTechnicianLabel => 'Assigned Technician:';

  @override
  String get deviceInfoPhotoLabel => 'Photo:';

  @override
  String get deviceInfoYes => 'Yes';

  @override
  String get deviceInfoNo => 'No';

  @override
  String get deviceInfoCustomPhoto => 'Custom';

  @override
  String get deviceInfoDefaultPhoto => 'Default';

  @override
  String get deviceAllDetailsTitle => 'All Details';

  @override
  String get deviceInfoSectionGeneral => 'General';

  @override
  String get deviceInfoSectionConfig => 'VITA Configuration';

  @override
  String get deviceInfoSectionOther => 'Others';

  @override
  String get deviceInfoSectionIdentity => 'Identification';

  @override
  String get deviceInfoSectionOperational => 'Operational Configuration';

  @override
  String get deviceInfoSectionPhysical => 'Physical Information';

  @override
  String get deviceInfoSectionMaintenance => 'Maintenance';

  @override
  String get deviceInfoModelLabel => 'Model:';

  @override
  String get deviceInfoDescriptionLabel => 'Description:';

  @override
  String get deviceInfoMacLabel => 'MAC Address:';

  @override
  String get deviceInfoHwVersionLabel => 'Hardware Version:';

  @override
  String get deviceInfoFwVersionLabel => 'Firmware Version:';

  @override
  String get deviceInfoAutoCloseLabel => 'Auto-close:';

  @override
  String get deviceInfoMaxOpenTimeLabel => 'Max. Open Time:';

  @override
  String get deviceInfoPedestrianTimeoutLabel => 'Pedestrian Timeout:';

  @override
  String get deviceInfoEmergencyModeLabel => 'Emergency Mode:';

  @override
  String get deviceInfoAutoLampLabel => 'Auto-On Lamp:';

  @override
  String get deviceInfoMaintenanceModeLabel => 'Maintenance Mode:';

  @override
  String get deviceInfoLockedLabel => 'Locked:';

  @override
  String get deviceInfoInstallationDateLabel => 'Installation Date:';

  @override
  String get deviceInfoWarrantyDateLabel => 'Warranty Expiration:';

  @override
  String get deviceInfoScheduledMaintLabel => 'Scheduled Maintenance:';

  @override
  String get deviceInfoMaintNotesLabel => 'Maintenance Notes:';

  @override
  String get deviceInfoPowerTypeLabel => 'Power Type:';

  @override
  String get deviceInfoMotorTypeLabel => 'Motor Type:';

  @override
  String get deviceInfoOpeningPhotocellLabel => 'Opening Photocell:';

  @override
  String get deviceInfoClosingPhotocellLabel => 'Closing Photocell:';

  @override
  String get deviceInfoSecondsSuffix => ' sec';

  @override
  String get deviceInfoViewAllDetailsBtn => 'View all details';

  @override
  String get deviceAddTitle => 'Add Device';

  @override
  String get deviceScanBtn => 'Scan QR / Wifi';

  @override
  String get deviceFormNameLabel => 'Name *';

  @override
  String get deviceFormLocationLabel => 'Location *';

  @override
  String get deviceFormSerialLabel => 'Serial Number *';

  @override
  String get deviceFormMacLabel => 'MAC Address *';

  @override
  String get deviceFormProgressTitle => 'Form Progress';

  @override
  String deviceFormProgressCount(int completed) {
    return '$completed of 7 sections';
  }

  @override
  String get deviceFormSectionBasic => 'Basic Information';

  @override
  String get deviceFormSectionId => 'Identification';

  @override
  String get deviceFormSectionConfig => 'Operational Config';

  @override
  String get deviceFormSectionPhysical => 'Physical Info';

  @override
  String get deviceFormSectionMaintenance => 'Maintenance';

  @override
  String get deviceFormSectionVita => 'VITA Config';

  @override
  String get deviceFormNamePlaceholder => 'Device Name';

  @override
  String get deviceFormLocationPlaceholder => 'Select Location';

  @override
  String get deviceFormDescriptionLabel => 'Description';

  @override
  String get deviceFormDescriptionPlaceholder => 'Description (optional)';

  @override
  String get deviceFormModelLabel => 'Model *';

  @override
  String get deviceFormModelPlaceholder => 'Select Model';

  @override
  String get deviceFormSubmitCreate => 'Create Device';

  @override
  String get deviceFormSubmitUpdate => 'Save Changes';

  @override
  String get deviceFormCancel => 'Cancel';

  @override
  String get deviceFormErrorRequired => 'Please complete all required fields';

  @override
  String get deviceFormErrorLocation => 'Select a location';

  @override
  String get deviceFormErrorModel => 'Select a model';

  @override
  String deviceFormErrorSave(Object error) {
    return 'Error saving: $error';
  }

  @override
  String get deviceFormStatusLabel => 'Status';

  @override
  String get deviceFormStatusPlaceholder => 'Select status';

  @override
  String get deviceFormTypeLabel => 'Device Type';

  @override
  String get deviceFormTypePlaceholder => 'Select type';

  @override
  String get deviceFormPhotoLabel => 'Device Photo';

  @override
  String get deviceFormPhotoHint => 'Tap to add a photo';

  @override
  String deviceInfoSignalStrength(int percentage) {
    return '$percentage% signal';
  }

  @override
  String deviceInfoSecondsValue(Object seconds) {
    return '$seconds sec';
  }

  @override
  String get groupsStatusReady => 'Ready';

  @override
  String get groupsErrorSelectGroupFirst => 'Select a group first';

  @override
  String get groupsErrorTodosReadonly =>
      'Cannot manually add devices to ALL group';

  @override
  String get groupsErrorSelectDeviceAdd => 'Select a device to add';

  @override
  String get groupsErrorDeviceAlreadyInGroup =>
      'Device is already in this group';

  @override
  String groupsSuccessDeviceAdded(String deviceName, String groupName) {
    return 'Device \"$deviceName\" added to $groupName';
  }

  @override
  String get groupsTitle => 'Groups Management';

  @override
  String get groupsSubtitleDevicesInGroup => 'Devices in this group';

  @override
  String groupsControlPrefix(String deviceName) {
    return 'Control: $deviceName';
  }

  @override
  String get groupsButtonMoreDetails => 'More details and settings';

  @override
  String get groupsSubtitleAddMore => 'Add more devices';

  @override
  String get groupsDropdownHint => 'Select to add...';

  @override
  String get groupsDropdownEmpty => 'No devices available';

  @override
  String get groupsButtonAdd => 'Add to this group';

  @override
  String get groupsInfoTodosTitle => 'Automatic Group \"ALL\"';

  @override
  String get groupsInfoTodosBody =>
      'This group automatically includes all your devices. You cannot manually add or remove devices here.';

  @override
  String get groupsEmptyList => 'No devices in this group';

  @override
  String get groupCreateTitle => 'Create New Group';

  @override
  String get groupEditTitle => 'Edit Group';

  @override
  String get groupNameLabel => 'Group Name';

  @override
  String get groupDescLabel => 'Description (Optional)';

  @override
  String get groupDeleteConfirmTitle => 'Delete Group?';

  @override
  String get groupDeleteConfirmBody => 'This action cannot be undone.';

  @override
  String get deviceRemoveConfirmTitle => 'Remove Device?';

  @override
  String get deviceRemoveConfirmBody =>
      'Are you sure you want to remove this device from the group?';

  @override
  String get groupsBtnCancel => 'Cancel';

  @override
  String get groupsBtnCreate => 'Create';

  @override
  String get groupsBtnSave => 'Save';

  @override
  String get groupsBtnRemove => 'Remove';

  @override
  String get groupsBtnDelete => 'Delete';

  @override
  String get groupsTitleSimple => 'Groups';

  @override
  String get groupsButtonCreateAction => 'Create Group';

  @override
  String get groupsSubsectionDevices => 'Devices';

  @override
  String get groupsSuccessCreated => 'Group created successfully';

  @override
  String get groupsSuccessUpdated => 'Group updated';

  @override
  String get groupsSuccessDeleted => 'Group deleted';

  @override
  String get groupsSuccessDeviceRemoved => 'Device removed from group';

  @override
  String get generalRetry => 'Retry';

  @override
  String get provisioningScanTitle => 'Scanning for Devices';

  @override
  String get provisioningScanSubtitle =>
      'Ensure your device is in setup mode (LED blinking).';

  @override
  String get provisioningScanningText => 'Scanning...';

  @override
  String get provisioningDeviceFound => 'Device Detected';

  @override
  String get provisioningConnectBtn => 'Connect';

  @override
  String get provisioningWifiTitle => 'Connect to Wi-Fi';

  @override
  String get provisioningWifiSubtitle => 'Enter credentials for the device.';

  @override
  String get provisioningSsidLabel => 'Network Name (SSID)';

  @override
  String get provisioningPasswordLabel => 'Wi-Fi Password';

  @override
  String get provisioningSendBtn => 'Send Configuration';

  @override
  String get provisioningSuccessTitle => 'Configuration Successful!';

  @override
  String get provisioningSuccessBody => 'Device connected successfully.';

  @override
  String get provisioningManualModeBtn => 'Not showing up? Manual Setup (AP)';

  @override
  String get provisioningErrorConnection => 'Could not connect to device';

  @override
  String get provisioningErrorWifi => 'Incorrect password or Wi-Fi not found';

  @override
  String get devicesListTitle => 'Devices';

  @override
  String get devicesTabDevices => 'Devices';

  @override
  String get devicesTabOthers => 'Others';

  @override
  String get deviceStatusOpening => 'Opening...';

  @override
  String get deviceStatusClosing => 'Closing...';

  @override
  String get deviceStatusPaused => 'Paused';

  @override
  String get deviceStatusPedestrianActive => 'Pedestrian Mode Active';

  @override
  String get deviceStatusReady => 'Ready';

  @override
  String deviceAutoCloseCountdown(int seconds) {
    return 'Auto-close in: $seconds s';
  }

  @override
  String get emptyListMessage => 'No items';

  @override
  String get scanDevicesTitle => 'Add Device';

  @override
  String get scanDeviceLabel => 'Device:';

  @override
  String get scanDeviceState => 'State:';

  @override
  String get scanDeviceDetail => 'Detail:';

  @override
  String get scanButtonScan => 'Scan';

  @override
  String get scanWifiNetworksDetected => 'Wi-Fi Networks Detected';

  @override
  String get scanVitaDevicesAvailable => 'VITA\'S available';

  @override
  String get scanVitaDevices => 'VITA Devices';

  @override
  String get scanSerialNumberHint => 'Link by Serial Number';

  @override
  String get scanSerialNumberLabel => 'Serial Number';

  @override
  String get scanButtonAdd => 'Add';

  @override
  String scanCompletedMessage(int count) {
    return 'Scan completed - $count networks found';
  }

  @override
  String get scanSelectDeviceError =>
      'Select a VITA device or enter a serial number';

  @override
  String scanDeviceAddedSuccess(String deviceId) {
    return 'Device $deviceId added';
  }

  @override
  String get parametersTitle => 'Device\nParameters';

  @override
  String get parametersDeviceLabel => 'Device:';

  @override
  String get parametersModelLabel => 'Model:';

  @override
  String get parametersSerialLabel => 'Serial No:';

  @override
  String get parametersStateLabel => 'State:';

  @override
  String get parametersDetailLabel => 'Detail:';

  @override
  String get parametersConfigSection => 'Config Parameters:';

  @override
  String get parametersNotificationsSection => 'Notifications Config:';

  @override
  String get parametersAutoClose => 'Auto Close';

  @override
  String get parametersCourtesyLight => 'Courtesy Light';

  @override
  String get parametersAutoCloseTime => 'Time before auto-closing';

  @override
  String get parametersLockDevice => 'Lock Device';

  @override
  String get parametersKeepOpen => 'Keep Open';

  @override
  String get parametersDisconnectionReminder => 'Disconnection Reminder';

  @override
  String get parametersOpenDoorReminder => 'Open Door Reminder';

  @override
  String get parametersForcedOpeningAlarm => 'Forced Opening Alarm';

  @override
  String get parametersPhotocellBlocked => 'Photocell Blocked';

  @override
  String get parametersOpeningNotAllowed => 'Opening Not Allowed';

  @override
  String get parametersUpdateAvailable => 'Update Available';

  @override
  String get parametersMaintenanceRequest => 'Maintenance Request';

  @override
  String get parametersOpenDoorReminderTime => 'Open Door Reminder Time';

  @override
  String get parametersConnectionFailureTime => 'Connection Failure Time';

  @override
  String get parametersPhotocellBlockedTime => 'Photocell Blocked Time';

  @override
  String get parametersUpdateButton => 'Update Parameters';

  @override
  String get parametersUpdatedSuccess => 'Parameters updated successfully';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsSelectCountry => 'Select Country';

  @override
  String get settingsSelectLanguage => 'Select Language';

  @override
  String get settingsSelectEnvironment => 'Select Environment';

  @override
  String get settingsCountryCostaRica => 'Costa Rica';

  @override
  String get settingsCountryMexico => 'Mexico';

  @override
  String get settingsCountrySpain => 'Spain';

  @override
  String get settingsLanguageSpanish => 'Español';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsEnvironmentProduction => 'Production';

  @override
  String get settingsEnvironmentStaging => 'Staging';

  @override
  String get settingsEnvironmentDevelopment => 'Development';

  @override
  String get settingsProfileSection => 'User Profile';

  @override
  String get settingsAppearanceSection => 'Appearance';

  @override
  String get settingsAccessibilitySection => 'Accessibility';

  @override
  String get settingsSecuritySection => 'Security';

  @override
  String get settingsServerSection => 'Server Configuration';

  @override
  String get settingsInfoSection => 'Information';

  @override
  String get settingsFieldName => 'Name';

  @override
  String get settingsFieldPhone => 'Phone';

  @override
  String get settingsFieldEmail => 'Email';

  @override
  String get settingsFieldAddress => 'Address';

  @override
  String get settingsFieldCountry => 'Country';

  @override
  String get settingsFieldLanguage => 'Language';

  @override
  String get settingsDarkMode => 'Dark Mode';

  @override
  String get settingsFontSize => 'Font Size';

  @override
  String get settingsHighContrast => 'High Contrast';

  @override
  String get settingsReduceMotion => 'Reduce Motion';

  @override
  String get settingsCurrentPassword => 'Current Password';

  @override
  String get settingsNewPassword => 'New Password';

  @override
  String get settingsRepeatPassword => 'Repeat Password';

  @override
  String get settingsBiometrics => 'Enable Biometrics';

  @override
  String get settingsBiometricsSubtitle => 'Use fingerprint or face to sign in';

  @override
  String get settingsEnvironment => 'Environment';

  @override
  String get settingsServerUrl => 'Server URL';

  @override
  String get settingsAppVersion => 'App Version';

  @override
  String get settingsTermsConditions => 'Terms and Conditions';

  @override
  String get settingsPrivacyPolicy => 'Privacy Policy';

  @override
  String get settingsSaveChanges => 'Save Changes';

  @override
  String get settingsChangeButton => 'Change';

  @override
  String get settingsChangePhoto => 'Change photo';

  @override
  String get settingsPhotoCamera => 'Camera';

  @override
  String get settingsPhotoGallery => 'Gallery';

  @override
  String get settingsPhotoRemove => 'Remove photo';

  @override
  String get settingsPhotoUpdated => 'Profile photo updated';

  @override
  String get settingsPhotoRemoved => 'Profile photo removed';

  @override
  String get settingsUpdatedSuccess => 'Settings updated successfully';

  @override
  String get bottomNavDevices => 'Devices';

  @override
  String get msgInvalidCredentials => 'Invalid email or password';

  @override
  String get msgSessionExpired => 'Your session has expired';

  @override
  String get msgEmailAlreadyExists => 'This email is already registered';

  @override
  String get msgPasswordMismatch => 'Passwords do not match';

  @override
  String get msgLoginSuccess => 'Welcome to BGnius VITA';

  @override
  String get msgRegisterSuccess => 'Account created successfully';

  @override
  String get msgLogoutSuccess => 'Session closed';

  @override
  String get msgPasswordResetSent => 'A link has been sent to your email';

  @override
  String get msgDeviceNotFound => 'Device not found';

  @override
  String get msgDeviceOffline => 'Device is offline';

  @override
  String get msgCommandFailed => 'Could not execute command';

  @override
  String get msgDeviceAdded => 'Device added successfully';

  @override
  String get msgDeviceUpdated => 'Device updated';

  @override
  String get msgDeviceDeleted => 'Device deleted';

  @override
  String get msgCommandSuccess => 'Command executed successfully';

  @override
  String get msgUserNotFound => 'User not found';

  @override
  String get msgUserAdded => 'User added successfully';

  @override
  String get msgUserUpdated => 'User updated';

  @override
  String get msgUserDeleted => 'User deleted';

  @override
  String get msgPermissionGranted => 'Permission granted';

  @override
  String get msgPermissionRevoked => 'Permission revoked';

  @override
  String get msgUserLinked => 'User linked successfully';

  @override
  String get msgGroupCreated => 'Group created successfully';

  @override
  String get msgGroupUpdated => 'Group updated';

  @override
  String get msgGroupDeleted => 'Group deleted';

  @override
  String get msgDeviceAddedToGroup => 'Device added to group';

  @override
  String get msgDeviceRemovedFromGroup => 'Device removed from group';

  @override
  String get msgRequiredField => 'This field is required';

  @override
  String get msgInvalidFormat => 'Invalid format entered';

  @override
  String get msgServerError => 'Server error occurred';

  @override
  String get msgConnectionError => 'Could not connect to server';

  @override
  String get msgUnknownError => 'An unexpected error occurred';

  @override
  String get msgNoData => 'No data available';

  @override
  String get msgLoading => 'Loading...';

  @override
  String get msgRetry => 'Retry';

  @override
  String get msgCancel => 'Cancel';

  @override
  String get msgAccept => 'Accept';

  @override
  String get msgSave => 'Save';

  @override
  String get msgDelete => 'Delete';

  @override
  String get msgEdit => 'Edit';

  @override
  String get msgAdd => 'Add';

  @override
  String get msgConfirm => 'Confirm';

  @override
  String get msgYes => 'Yes';

  @override
  String get msgNo => 'No';

  @override
  String get msgConfirmDelete => 'Are you sure you want to delete this item?';

  @override
  String get msgConfirmDeleteDevice => 'Do you want to delete this device?';

  @override
  String get msgConfirmDeleteUser => 'Do you want to delete this user?';

  @override
  String get msgConfirmLogout => 'Do you want to sign out?';

  @override
  String get msgCannotUndo => 'This action cannot be undone';

  @override
  String get msgMinPasswordLength => 'Password must be at least 8 characters';

  @override
  String get msgInvalidEmail => 'Invalid email format';

  @override
  String get msgInvalidPhone => 'Invalid phone format';

  @override
  String get msgInvalidSerialNumber => 'Invalid serial number';

  @override
  String get navDevices => 'Devices';

  @override
  String get navGroups => 'Groups';

  @override
  String get navUsers => 'Users';

  @override
  String get navSettings => 'Settings';

  @override
  String get sharedUsersTitle => 'Registered\nUsers';

  @override
  String get sharedUsersDeviceLabel => 'Device:';

  @override
  String get sharedUsersModelLabel => 'Model:';

  @override
  String get sharedUsersSerialLabel => 'Serial No:';

  @override
  String get sharedUsersStatusLabel => 'Status:';

  @override
  String get sharedUsersDetailLabel => 'Detail:';

  @override
  String get sharedUsersSearchHint => 'Search user';

  @override
  String get sharedUsersEmptyList => 'No registered users';

  @override
  String get sharedUsersLinkButton => 'Link User';

  @override
  String get deviceEditTitle => 'Edit Device';

  @override
  String get deviceEditSuccessMessage => 'Device updated successfully';

  @override
  String get deviceEditErrorLoading => 'Error loading';

  @override
  String get deviceControlTitle => 'Device Detail';

  @override
  String get deviceControlButtonOpen => 'Open';

  @override
  String get deviceControlButtonPause => 'Pause';

  @override
  String get deviceControlButtonClose => 'Close';

  @override
  String get deviceControlButtonPedestrian => 'Pedestrian';

  @override
  String get deviceControlButtonLock => 'Lock';

  @override
  String get deviceControlButtonLight => 'Light';

  @override
  String get deviceControlButtonSwitch => 'Switch';

  @override
  String get deviceControlStatusOpening => 'Opening gate...';

  @override
  String get deviceControlStatusPausing => 'Pausing...';

  @override
  String get deviceControlStatusClosing => 'Closing gate...';

  @override
  String get deviceControlStatusPedestrian => 'Pedestrian opening...';

  @override
  String get deviceControlStatusLocked => 'Device Locked';

  @override
  String get deviceControlStatusLightOn => 'Light on';

  @override
  String get deviceControlStatusSwitchActive => 'Switch activated';

  @override
  String deviceControlAutoCloseCountdown(Object seconds) {
    return 'Auto-close in: $seconds s';
  }

  @override
  String get deviceControlLinkEdit => 'Edit Device';

  @override
  String get deviceControlLinkUsers => 'Users with Access';

  @override
  String get deviceControlLinkParams => 'Parameters';

  @override
  String get deviceControlLinkEvents => 'Event Log';

  @override
  String get deviceControlLinkContact => 'Technical Contact';

  @override
  String get deviceControlLinkInfo => 'Device Information';

  @override
  String get technicalContactTitle => 'Technical Contact';

  @override
  String get technicalContactDeviceLabel => 'Device:';

  @override
  String get technicalContactModelLabel => 'Model:';

  @override
  String get technicalContactSerialLabel => 'Serial No:';

  @override
  String get technicalContactStatusLabel => 'Status:';

  @override
  String get technicalContactDetailLabel => 'Detail:';

  @override
  String get technicalContactTechDataTitle => 'Technician Data';

  @override
  String get technicalContactNameHint => 'Username';

  @override
  String get technicalContactEmailHint => 'Email';

  @override
  String get technicalContactCountryHint => 'Country';

  @override
  String get technicalContactPhoneHint => 'Phone';

  @override
  String get technicalContactAiDescription =>
      'Our AI periodically reviews your automation, analyzes its performance and detects possible signs of wear or failures. Based on this, it informs you when your system needs maintenance.';

  @override
  String get technicalContactAiPermissionText =>
      'Allow AI to inform me when maintenance is required.';

  @override
  String get technicalContactNotesTitle => 'Notes';

  @override
  String get technicalContactDeleteButton => 'Delete';

  @override
  String get technicalContactSaveButton => 'Save';

  @override
  String get technicalContactDeleteDialogTitle => 'Delete Contact';

  @override
  String get technicalContactDeleteDialogContent =>
      'Are you sure you want to delete this technical contact?';

  @override
  String get technicalContactCancelButton => 'Cancel';

  @override
  String get technicalContactSaveSuccess =>
      'Technical contact saved successfully';

  @override
  String get technicalContactDeleteSuccess => 'Technical contact deleted';

  @override
  String get technicalContactMaintenanceInfo =>
      'Contacting maintenance - Coming soon';

  @override
  String get linkVirtualUserTitle => 'Link virtual user';

  @override
  String get linkVirtualUserEmailLabel => 'Email/User';

  @override
  String get linkVirtualUserEmailHint => 'Email/User';

  @override
  String get linkVirtualUserLabelLabel => 'Label';

  @override
  String get linkVirtualUserLabelHint => 'Label';

  @override
  String get linkVirtualUserAddButton => 'Add User to List';

  @override
  String get linkVirtualUserNewUserName => 'New User';

  @override
  String get linkVirtualUserErrorEmail => 'Please enter email or user';

  @override
  String get linkVirtualUserSuccess => 'User added. Configure permissions.';

  @override
  String get deviceControlSimpleTitle => 'Controls';

  @override
  String get deviceControlLocationTitle => 'Location';

  @override
  String get deviceControlDescriptionTitle => 'Description';

  @override
  String get deviceControlStatusTitle => 'Status';

  @override
  String get usersScreenTitle => 'Users with Access';

  @override
  String get usersScreenDeviceLabel => 'Device:';

  @override
  String get usersScreenModelLabel => 'Model:';

  @override
  String get usersScreenSerialLabel => 'Serial No:';

  @override
  String get usersScreenStatusLabel => 'Status:';

  @override
  String get usersScreenDetailLabel => 'Detail:';

  @override
  String get usersScreenAvailableUsersTitle => 'Available Users:';

  @override
  String get usersScreenLinkButton => 'Link Existing User';

  @override
  String get usersScreenErrorSelectUsers => 'Select at least one user';

  @override
  String usersScreenSuccessLinked(Object count) {
    return '$count user(s) linked successfully';
  }

  @override
  String usersScreenEditInfo(Object name) {
    return 'Edit $name - Coming soon';
  }

  @override
  String get userAccessScreenTitle => 'Users with Access';

  @override
  String get userAccessDeviceLabel => 'Device:';

  @override
  String get userAccessModelLabel => 'Model:';

  @override
  String get userAccessSerialLabel => 'Serial No:';

  @override
  String get userAccessStatusLabel => 'Status:';

  @override
  String get userAccessDetailLabel => 'Detail:';

  @override
  String get userAccessLinkedUsersTitle => 'Currently Linked Users';

  @override
  String get userAccessLinkedUsersDesc =>
      'These users can already access this device';

  @override
  String get userAccessAvailableUsersTitle => 'Users Available for Linking';

  @override
  String get userAccessAvailableUsersDesc =>
      'Select users to give them access to this device';

  @override
  String get userAccessSearchHint => 'Search user...';

  @override
  String get userAccessTooltipAdmin => 'Administrator';

  @override
  String get userAccessTooltipUnlink => 'Unlink';

  @override
  String get userAccessEditButton => 'Edit';

  @override
  String get userAccessErrorAdminUnlink =>
      'You cannot unlink the administrator';

  @override
  String get userAccessErrorSelectUsers => 'Select at least one user';

  @override
  String get userAccessUnlinkDialogTitle => 'Unlink User';

  @override
  String userAccessUnlinkDialogContent(Object name) {
    return 'Do you want to unlink $name?';
  }

  @override
  String get userAccessCancelButton => 'Cancel';

  @override
  String get userAccessUnlinkButton => 'Unlink';

  @override
  String userAccessSuccessUnlinked(Object name) {
    return '$name unlinked';
  }

  @override
  String userAccessSuccessLinked(Object count) {
    return '$count user(s) linked successfully';
  }

  @override
  String userAccessEditInfo(Object name) {
    return 'Edit $name - Coming soon';
  }

  @override
  String userAccessLinkButtonSingle(Object count) {
    return 'Link Existing User ($count)';
  }

  @override
  String userAccessLinkButtonPlural(Object count) {
    return 'Link Existing Users ($count)';
  }

  @override
  String get userRolesTitle => 'User roles\nin device';

  @override
  String get userRolesDeviceLabel => 'Device:';

  @override
  String get userRolesModelLabel => 'Model:';

  @override
  String get userRolesSerialLabel => 'Serial No:';

  @override
  String get userRolesStatusLabel => 'Status:';

  @override
  String get userRolesDetailLabel => 'Detail:';

  @override
  String get userRolesSelectedUserLabel => 'Selected User';

  @override
  String get userRolesEmailLabel => 'Email';

  @override
  String get userRolesNewUserDefault => 'New User';

  @override
  String get userRolesPermissionsTitle => 'Permissions and Roles';

  @override
  String get userRolesAssignButton => 'Assign Roles';

  @override
  String get userRolesPermissionOpen => 'Open';

  @override
  String get userRolesPermissionClose => 'Close';

  @override
  String get userRolesPermissionPause => 'Stop/Pause';

  @override
  String get userRolesPermissionPedestrian => 'Pedestrian';

  @override
  String get userRolesPermissionLock => 'Lock';

  @override
  String get userRolesPermissionLight => 'Light';

  @override
  String get userRolesPermissionSwitch => 'Relay/Switch';

  @override
  String get userRolesPermissionControlPanel => 'Control Panel';

  @override
  String get userRolesPermissionReports => 'Reports';

  @override
  String get userRolesPermissionViewContact => 'View Contact';

  @override
  String get userRolesPermissionViewParams => 'View Parameters';

  @override
  String get userRolesPermissionEditDevice => 'Edit Device';

  @override
  String get userRolesPermissionAssignUsers => 'Assign Users';

  @override
  String get userRolesErrorNoPermissions => 'Select at least one permission';

  @override
  String get userRolesSuccessAssigned =>
      'Roles assigned and user linked successfully';

  @override
  String get userRolesErrorUnknownDevice => 'Could not link: Unknown device';

  @override
  String get deviceFormGallery => 'Gallery';

  @override
  String get deviceFormCamera => 'Camera';

  @override
  String get deviceFormDeletePhoto => 'Delete Photo';

  @override
  String get deviceFormDeleteDevice => 'Delete Device';

  @override
  String get generalDelete => 'Delete';

  @override
  String get deviceFormDeleteConfirmMessage =>
      'Are you sure you want to delete this device and all its associated data? This action cannot be undone.';

  @override
  String get deviceFormSelectImage => 'Select Image';

  @override
  String get deviceFormTakePhoto => 'Take Photo';

  @override
  String get deviceFormImageLoadedSuccess => 'Image loaded successfully';

  @override
  String deviceFormImageLoadError(String error) {
    return 'Error loading image: $error';
  }

  @override
  String get deviceFormDeletedSuccess => 'Device deleted successfully';

  @override
  String get blePairingTitle => 'BLE Pairing';

  @override
  String get bleScanStepTitle => 'Scan devices';

  @override
  String get bleScanStepDescription =>
      'Search for nearby VITA devices. Make sure the device is in pairing mode (blue LED blinking).';

  @override
  String get bleScanButtonStart => 'Start scanning';

  @override
  String get bleScanningText => 'Scanning devices...';

  @override
  String get bleDeviceListStepTitle => 'Select device';

  @override
  String bleDeviceListFound(int count) {
    return 'Found $count devices';
  }

  @override
  String get bleConnectionStepTitle => 'Connecting';

  @override
  String get bleConnectingText => 'Connecting to device...';

  @override
  String get bleDeviceInfoTitle => 'Device information';

  @override
  String get bleConfigureButton => 'Configure';

  @override
  String get bleConfigStepTitle => 'Configuration';

  @override
  String get bleConfigStepDescription =>
      'Set up the initial data for your VITA device.';

  @override
  String get bleConfigDeviceNameLabel => 'Device name';

  @override
  String get bleConfigDeviceNameHint => 'Ex: Main Gate';

  @override
  String get bleConfigLocationLabel => 'Location';

  @override
  String get bleConfigLocationHint => 'Ex: Main entrance';

  @override
  String get bleConfigDescriptionLabel => 'Description';

  @override
  String get bleConfigDescriptionHint => 'Additional description (optional)';

  @override
  String get bleConfigDeviceTypeLabel => 'Device type';

  @override
  String get bleConfigTypeGate => 'Gate';

  @override
  String get bleConfigTypeDoor => 'Door';

  @override
  String get bleConfigTypeBarrier => 'Barrier';

  @override
  String get bleConfigSaveButton => 'Save configuration';

  @override
  String get bleConfigDeviceNameRequired => 'Device name is required';

  @override
  String get bleConfiguringText => 'Configuring device...';

  @override
  String get bleSuccessStepTitle => 'Completed';

  @override
  String get bleSuccessMessage => 'Device paired successfully!';

  @override
  String bleSuccessDeviceConfigured(String deviceName) {
    return 'Device \'$deviceName\' has been configured correctly.';
  }

  @override
  String get bleSuccessGoToDevices => 'Go to my devices';

  @override
  String get bleInfoSerial => 'Serial No.';

  @override
  String get bleInfoFirmware => 'Firmware';

  @override
  String get bleInfoModel => 'Model';

  @override
  String get bleInfoMotor => 'Motor';

  @override
  String get bleErrorGeneric => 'Error during pairing process';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get markAllAsRead => 'Mark all as read';

  @override
  String get noNotifications => 'No notifications';

  @override
  String minutesAgo(String minutes) {
    return '${minutes}m ago';
  }

  @override
  String hoursAgo(String hours) {
    return '${hours}h ago';
  }

  @override
  String daysAgo(String days) {
    return '${days}d ago';
  }

  @override
  String get justNow => 'Just now';

  @override
  String get deviceOffline => 'Device offline';

  @override
  String get deviceOnline => 'Device online';

  @override
  String get actionExecuted => 'Action executed';

  @override
  String get statusChange => 'Status change';

  @override
  String get notificationPreferences => 'Notification Preferences';

  @override
  String get notificationPreferencesDescription =>
      'Configure which notifications you want to receive for each device';

  @override
  String get notificationTypes => 'Notification types';

  @override
  String get notifyActions => 'Notify actions';

  @override
  String get notifyActionsDescription => 'When someone operates the device';

  @override
  String get notifyOffline => 'Notify offline';

  @override
  String get notifyOfflineDescription => 'When the device goes offline';

  @override
  String get notifyStatusChange => 'Notify status changes';

  @override
  String get notifyStatusChangeDescription => 'When motor status changes';

  @override
  String get retry => 'Retry';

  @override
  String get activationDateLabel => 'Activation date';

  @override
  String get favoriteDeviceLabel => 'Favorite Device';

  @override
  String get selectDatePlaceholder => 'Select date';

  @override
  String get changePhotoButton => 'Change';

  @override
  String get deleteDeviceButton => 'Delete Device';

  @override
  String get serialNumberPlaceholder => 'SN...';

  @override
  String get searchPlaceholder => 'Search...';

  @override
  String get confirmDefault => 'Confirm';

  @override
  String get cancelDefault => 'Cancel';

  @override
  String get groupNotFound => 'Group not found';

  @override
  String get cannotAddToAllGroup => 'Cannot manually add devices to ALL group';

  @override
  String get deviceAlreadyInGroup => 'Device is already in the group';

  @override
  String get cannotRemoveFromAllGroup => 'Cannot remove devices from ALL group';

  @override
  String get deviceNotInGroup => 'Device is not in the group';

  @override
  String get nameCannotBeEmpty => 'Name cannot be empty';

  @override
  String get groupNameAlreadyExists => 'A group with this name already exists';

  @override
  String get cannotModifyAllGroup => 'Cannot modify ALL group';

  @override
  String get cannotDeleteAllGroup => 'Cannot delete ALL group';

  @override
  String get powerTypeLabel => 'Power Type';

  @override
  String get motorTypeLabel => 'Motor Type';

  @override
  String get selectPlaceholder => 'Select';

  @override
  String get openingPhotocellLabel => 'Opening Photocell';

  @override
  String get closingPhotocellLabel => 'Closing Photocell';

  @override
  String get installationDateLabel => 'Installation Date';

  @override
  String get warrantyExpirationLabel => 'Warranty Expiration';

  @override
  String get scheduledMaintenanceLabel => 'Scheduled Maintenance';

  @override
  String get technicianNamePlaceholder => 'Technician name...';

  @override
  String get technicalContactLabel => 'Technical Contact';

  @override
  String get additionalNotesPlaceholder => 'Additional notes...';

  @override
  String get maintenanceNotesLabel => 'Maintenance Notes';

  @override
  String get deviceOnlineStatus => 'Online';

  @override
  String get deviceOfflineStatus => 'Offline';

  @override
  String get deviceImageLabel => 'Device gate image';

  @override
  String get mainGateLabel => 'Main Gate';

  @override
  String get garageGateLabel => 'Garage Gate';

  @override
  String get controlsButtonOpen => 'Open';

  @override
  String get controlsButtonPause => 'Pause';

  @override
  String get controlsButtonClose => 'Close';

  @override
  String get controlsButtonPedestrian => 'Pedestrian';

  @override
  String get modelLabel => 'Model:';

  @override
  String get serialNumberLabel => 'Serial No.:';

  @override
  String get detailLabel => 'Detail';

  @override
  String get notificationTooltip => 'Notifications';

  @override
  String get retryButton => 'Retry';

  @override
  String get editButton => 'Edit';

  @override
  String get showPasswordButton => 'Show';

  @override
  String get hidePasswordButton => 'Hide';
}
