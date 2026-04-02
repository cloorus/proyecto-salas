import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es')
  ];

  /// Nombre de la aplicación
  ///
  /// In es, this message translates to:
  /// **'BGnius VITA'**
  String get appTitle;

  /// Título de la pantalla de login
  ///
  /// In es, this message translates to:
  /// **'Bienvenido'**
  String get loginTitle;

  /// Placeholder del campo de correo electrónico
  ///
  /// In es, this message translates to:
  /// **'Correo'**
  String get loginEmailHint;

  /// Placeholder del campo de contraseña
  ///
  /// In es, this message translates to:
  /// **'Contraseña'**
  String get loginPasswordHint;

  /// Texto del botón para mostrar contraseña
  ///
  /// In es, this message translates to:
  /// **'Mostrar'**
  String get loginShowPassword;

  /// Texto del botón para ocultar contraseña
  ///
  /// In es, this message translates to:
  /// **'Ocultar'**
  String get loginHidePassword;

  /// Texto del checkbox recordar sesión
  ///
  /// In es, this message translates to:
  /// **'Recuérdame'**
  String get loginRememberMe;

  /// Texto del enlace de recuperación de contraseña
  ///
  /// In es, this message translates to:
  /// **'Olvide mi contraseña'**
  String get loginForgotPassword;

  /// Texto del botón de login
  ///
  /// In es, this message translates to:
  /// **'Ingresar'**
  String get loginButton;

  /// Texto del botón de registro
  ///
  /// In es, this message translates to:
  /// **'Crear Usuario'**
  String get loginCreateAccount;

  /// Enlace a biblioteca de componentes (dev)
  ///
  /// In es, this message translates to:
  /// **'Biblioteca'**
  String get loginLibraryLink;

  /// Mensaje de éxito al hacer login
  ///
  /// In es, this message translates to:
  /// **'Bienvenido a BGnius VITA'**
  String get loginSuccess;

  /// Mensaje de error cuando las credenciales son inválidas
  ///
  /// In es, this message translates to:
  /// **'Correo o contraseña incorrectos'**
  String get loginInvalidCredentials;

  /// Mensaje cuando un campo requerido está vacío
  ///
  /// In es, this message translates to:
  /// **'Este campo es obligatorio'**
  String get validationRequiredField;

  /// Mensaje cuando el formato del email es inválido
  ///
  /// In es, this message translates to:
  /// **'El formato del correo no es válido'**
  String get validationInvalidEmail;

  /// Mensaje cuando el campo contraseña está vacío
  ///
  /// In es, this message translates to:
  /// **'La contraseña es obligatoria'**
  String get validationPasswordRequired;

  /// Mensaje de error genérico
  ///
  /// In es, this message translates to:
  /// **'Ocurrió un error inesperado'**
  String get generalError;

  /// Texto de estado de carga
  ///
  /// In es, this message translates to:
  /// **'Cargando...'**
  String get generalLoading;

  /// Mensaje cuando el campo de correo está vacío
  ///
  /// In es, this message translates to:
  /// **'El correo es obligatorio'**
  String get validationEmailRequired;

  /// Mensaje cuando la contraseña es muy corta
  ///
  /// In es, this message translates to:
  /// **'La contraseña debe tener al menos 8 caracteres'**
  String get validationPasswordMinLength;

  /// Mensaje cuando falta mayúscula en contraseña
  ///
  /// In es, this message translates to:
  /// **'Debe contener al menos una mayúscula'**
  String get validationPasswordUppercase;

  /// Mensaje cuando falta minúscula en contraseña
  ///
  /// In es, this message translates to:
  /// **'Debe contener al menos una minúscula'**
  String get validationPasswordLowercase;

  /// Mensaje cuando falta número en contraseña
  ///
  /// In es, this message translates to:
  /// **'Debe contener al menos un número'**
  String get validationPasswordNumber;

  /// Mensaje cuando falta símbolo en contraseña
  ///
  /// In es, this message translates to:
  /// **'Debe contener al menos un símbolo especial'**
  String get validationPasswordSymbol;

  /// Mensaje cuando las contraseñas no son iguales
  ///
  /// In es, this message translates to:
  /// **'Las contraseñas no coinciden'**
  String get validationPasswordsNoMatch;

  /// Mensaje cuando falta confirmar contraseña
  ///
  /// In es, this message translates to:
  /// **'Confirma tu contraseña'**
  String get validationConfirmPassword;

  /// No description provided for @registerTitle.
  ///
  /// In es, this message translates to:
  /// **'Crear Usuario'**
  String get registerTitle;

  /// No description provided for @registerNameLabel.
  ///
  /// In es, this message translates to:
  /// **'Nombre'**
  String get registerNameLabel;

  /// No description provided for @registerNameHint.
  ///
  /// In es, this message translates to:
  /// **'Nombre completo'**
  String get registerNameHint;

  /// No description provided for @registerEmailLabel.
  ///
  /// In es, this message translates to:
  /// **'Correo'**
  String get registerEmailLabel;

  /// No description provided for @registerEmailHint.
  ///
  /// In es, this message translates to:
  /// **'tu@correo.com'**
  String get registerEmailHint;

  /// No description provided for @registerAddressLabel.
  ///
  /// In es, this message translates to:
  /// **'Dirección'**
  String get registerAddressLabel;

  /// No description provided for @registerAddressHint.
  ///
  /// In es, this message translates to:
  /// **'Calle 123 #45-67'**
  String get registerAddressHint;

  /// No description provided for @registerCountryLabel.
  ///
  /// In es, this message translates to:
  /// **'País'**
  String get registerCountryLabel;

  /// No description provided for @registerCountryHint.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar país'**
  String get registerCountryHint;

  /// No description provided for @registerLanguageLabel.
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get registerLanguageLabel;

  /// No description provided for @registerLanguageHint.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar idioma'**
  String get registerLanguageHint;

  /// No description provided for @registerPasswordLabel.
  ///
  /// In es, this message translates to:
  /// **'Contraseña'**
  String get registerPasswordLabel;

  /// No description provided for @registerPasswordHint.
  ///
  /// In es, this message translates to:
  /// **'Mínimo 8 caracteres'**
  String get registerPasswordHint;

  /// No description provided for @registerConfirmPasswordLabel.
  ///
  /// In es, this message translates to:
  /// **'Repetir Contraseña'**
  String get registerConfirmPasswordLabel;

  /// No description provided for @registerConfirmPasswordHint.
  ///
  /// In es, this message translates to:
  /// **'Confirma tu contraseña'**
  String get registerConfirmPasswordHint;

  /// No description provided for @registerPhonePrefixLabel.
  ///
  /// In es, this message translates to:
  /// **'Prefijo'**
  String get registerPhonePrefixLabel;

  /// No description provided for @registerPhoneLabel.
  ///
  /// In es, this message translates to:
  /// **'Teléfono'**
  String get registerPhoneLabel;

  /// No description provided for @registerPhoneHint.
  ///
  /// In es, this message translates to:
  /// **'3001234567'**
  String get registerPhoneHint;

  /// No description provided for @registerAcceptTerms.
  ///
  /// In es, this message translates to:
  /// **'Acepto términos y condiciones'**
  String get registerAcceptTerms;

  /// No description provided for @registerButton.
  ///
  /// In es, this message translates to:
  /// **'Vincular Usuario'**
  String get registerButton;

  /// No description provided for @registerAlreadyHaveAccount.
  ///
  /// In es, this message translates to:
  /// **'¿Ya tienes cuenta? '**
  String get registerAlreadyHaveAccount;

  /// No description provided for @registerLoginLink.
  ///
  /// In es, this message translates to:
  /// **'Inicia Sesión'**
  String get registerLoginLink;

  /// No description provided for @registerErrorTerms.
  ///
  /// In es, this message translates to:
  /// **'Debes aceptar los términos y condiciones'**
  String get registerErrorTerms;

  /// No description provided for @registerErrorPasswordMismatch.
  ///
  /// In es, this message translates to:
  /// **'Las contraseñas no coinciden'**
  String get registerErrorPasswordMismatch;

  /// No description provided for @registerSuccess.
  ///
  /// In es, this message translates to:
  /// **'Cuenta creada exitosamente'**
  String get registerSuccess;

  /// No description provided for @registerError.
  ///
  /// In es, this message translates to:
  /// **'Error al crear la cuenta'**
  String get registerError;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In es, this message translates to:
  /// **'Restablecer Contraseña'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordEmailHint.
  ///
  /// In es, this message translates to:
  /// **'Correo/Usuario'**
  String get forgotPasswordEmailHint;

  /// No description provided for @forgotPasswordGetCodeButton.
  ///
  /// In es, this message translates to:
  /// **'Obtener código temporal'**
  String get forgotPasswordGetCodeButton;

  /// No description provided for @forgotPasswordTimeRemaining.
  ///
  /// In es, this message translates to:
  /// **'Tiempo restante'**
  String get forgotPasswordTimeRemaining;

  /// No description provided for @forgotPasswordTimeRemainingOf.
  ///
  /// In es, this message translates to:
  /// **'de contraseña temporal'**
  String get forgotPasswordTimeRemainingOf;

  /// No description provided for @forgotPasswordNewPasswordHint.
  ///
  /// In es, this message translates to:
  /// **'Nueva Contraseña'**
  String get forgotPasswordNewPasswordHint;

  /// No description provided for @forgotPasswordRepeatPasswordHint.
  ///
  /// In es, this message translates to:
  /// **'Repita su Nueva Contraseña'**
  String get forgotPasswordRepeatPasswordHint;

  /// No description provided for @forgotPasswordCodeHint.
  ///
  /// In es, this message translates to:
  /// **'Ingrese el código temporal'**
  String get forgotPasswordCodeHint;

  /// No description provided for @forgotPasswordResetButton.
  ///
  /// In es, this message translates to:
  /// **'Restablecer Contraseña'**
  String get forgotPasswordResetButton;

  /// No description provided for @forgotPasswordErrorEmail.
  ///
  /// In es, this message translates to:
  /// **'Ingresa tu correo electrónico'**
  String get forgotPasswordErrorEmail;

  /// No description provided for @forgotPasswordCodeSent.
  ///
  /// In es, this message translates to:
  /// **'Código enviado a {email}'**
  String forgotPasswordCodeSent(String email);

  /// No description provided for @forgotPasswordErrorPasswordMismatch.
  ///
  /// In es, this message translates to:
  /// **'Las contraseñas no coinciden'**
  String get forgotPasswordErrorPasswordMismatch;

  /// No description provided for @forgotPasswordSuccess.
  ///
  /// In es, this message translates to:
  /// **'Contraseña restablecida exitosamente'**
  String get forgotPasswordSuccess;

  /// No description provided for @eventLogTitle.
  ///
  /// In es, this message translates to:
  /// **'Registro de Eventos'**
  String get eventLogTitle;

  /// No description provided for @eventLogDownload.
  ///
  /// In es, this message translates to:
  /// **'Descargar registros'**
  String get eventLogDownload;

  /// No description provided for @eventLogDownloading.
  ///
  /// In es, this message translates to:
  /// **'Descargando {count} registros...'**
  String eventLogDownloading(int count);

  /// No description provided for @eventLogEmpty.
  ///
  /// In es, this message translates to:
  /// **'No hay eventos registrados'**
  String get eventLogEmpty;

  /// No description provided for @deviceInfoTitle.
  ///
  /// In es, this message translates to:
  /// **'Información del dispositivo'**
  String get deviceInfoTitle;

  /// No description provided for @deviceInfoSerialLabel.
  ///
  /// In es, this message translates to:
  /// **'No. Serie:'**
  String get deviceInfoSerialLabel;

  /// No description provided for @deviceInfoNameLabel.
  ///
  /// In es, this message translates to:
  /// **'Nombre:'**
  String get deviceInfoNameLabel;

  /// No description provided for @deviceInfoVersionLabel.
  ///
  /// In es, this message translates to:
  /// **'Versión Actual:'**
  String get deviceInfoVersionLabel;

  /// No description provided for @deviceInfoTotalCyclesLabel.
  ///
  /// In es, this message translates to:
  /// **'Ciclos Totales:'**
  String get deviceInfoTotalCyclesLabel;

  /// No description provided for @deviceInfoActivationDateLabel.
  ///
  /// In es, this message translates to:
  /// **'Fecha de activación'**
  String get deviceInfoActivationDateLabel;

  /// No description provided for @deviceInfoStatusLabel.
  ///
  /// In es, this message translates to:
  /// **'Estado'**
  String get deviceInfoStatusLabel;

  /// No description provided for @deviceInfoUpdateBtn.
  ///
  /// In es, this message translates to:
  /// **'Actualizar dispositivo'**
  String get deviceInfoUpdateBtn;

  /// No description provided for @deviceInfoOneMaintenance.
  ///
  /// In es, this message translates to:
  /// **'1 mantenimiento'**
  String get deviceInfoOneMaintenance;

  /// No description provided for @deviceInfoGroupLabel.
  ///
  /// In es, this message translates to:
  /// **'Grupo:'**
  String get deviceInfoGroupLabel;

  /// No description provided for @deviceInfoFavoriteLabel.
  ///
  /// In es, this message translates to:
  /// **'Favorito:'**
  String get deviceInfoFavoriteLabel;

  /// No description provided for @deviceInfoTechnicianLabel.
  ///
  /// In es, this message translates to:
  /// **'Técnico Asignado:'**
  String get deviceInfoTechnicianLabel;

  /// No description provided for @deviceInfoPhotoLabel.
  ///
  /// In es, this message translates to:
  /// **'Foto:'**
  String get deviceInfoPhotoLabel;

  /// No description provided for @deviceInfoYes.
  ///
  /// In es, this message translates to:
  /// **'Sí'**
  String get deviceInfoYes;

  /// No description provided for @deviceInfoNo.
  ///
  /// In es, this message translates to:
  /// **'No'**
  String get deviceInfoNo;

  /// No description provided for @deviceInfoCustomPhoto.
  ///
  /// In es, this message translates to:
  /// **'Personalizada'**
  String get deviceInfoCustomPhoto;

  /// No description provided for @deviceInfoDefaultPhoto.
  ///
  /// In es, this message translates to:
  /// **'Por defecto'**
  String get deviceInfoDefaultPhoto;

  /// No description provided for @deviceAllDetailsTitle.
  ///
  /// In es, this message translates to:
  /// **'Todos los detalles'**
  String get deviceAllDetailsTitle;

  /// No description provided for @deviceInfoSectionGeneral.
  ///
  /// In es, this message translates to:
  /// **'General'**
  String get deviceInfoSectionGeneral;

  /// No description provided for @deviceInfoSectionConfig.
  ///
  /// In es, this message translates to:
  /// **'Configuración VITA'**
  String get deviceInfoSectionConfig;

  /// No description provided for @deviceInfoSectionOther.
  ///
  /// In es, this message translates to:
  /// **'Otros'**
  String get deviceInfoSectionOther;

  /// No description provided for @deviceInfoSectionIdentity.
  ///
  /// In es, this message translates to:
  /// **'Identificación'**
  String get deviceInfoSectionIdentity;

  /// No description provided for @deviceInfoSectionOperational.
  ///
  /// In es, this message translates to:
  /// **'Configuración Operativa'**
  String get deviceInfoSectionOperational;

  /// No description provided for @deviceInfoSectionPhysical.
  ///
  /// In es, this message translates to:
  /// **'Información Física'**
  String get deviceInfoSectionPhysical;

  /// No description provided for @deviceInfoSectionMaintenance.
  ///
  /// In es, this message translates to:
  /// **'Mantenimiento'**
  String get deviceInfoSectionMaintenance;

  /// No description provided for @deviceInfoModelLabel.
  ///
  /// In es, this message translates to:
  /// **'Modelo:'**
  String get deviceInfoModelLabel;

  /// No description provided for @deviceInfoDescriptionLabel.
  ///
  /// In es, this message translates to:
  /// **'Descripción:'**
  String get deviceInfoDescriptionLabel;

  /// No description provided for @deviceInfoMacLabel.
  ///
  /// In es, this message translates to:
  /// **'Dirección MAC:'**
  String get deviceInfoMacLabel;

  /// No description provided for @deviceInfoHwVersionLabel.
  ///
  /// In es, this message translates to:
  /// **'Versión Hardware:'**
  String get deviceInfoHwVersionLabel;

  /// No description provided for @deviceInfoFwVersionLabel.
  ///
  /// In es, this message translates to:
  /// **'Versión Firmware:'**
  String get deviceInfoFwVersionLabel;

  /// No description provided for @deviceInfoAutoCloseLabel.
  ///
  /// In es, this message translates to:
  /// **'Auto-cierre:'**
  String get deviceInfoAutoCloseLabel;

  /// No description provided for @deviceInfoMaxOpenTimeLabel.
  ///
  /// In es, this message translates to:
  /// **'Tiempo máx. abierto:'**
  String get deviceInfoMaxOpenTimeLabel;

  /// No description provided for @deviceInfoPedestrianTimeoutLabel.
  ///
  /// In es, this message translates to:
  /// **'Timeout peatonal:'**
  String get deviceInfoPedestrianTimeoutLabel;

  /// No description provided for @deviceInfoEmergencyModeLabel.
  ///
  /// In es, this message translates to:
  /// **'Modo Emergencia:'**
  String get deviceInfoEmergencyModeLabel;

  /// No description provided for @deviceInfoAutoLampLabel.
  ///
  /// In es, this message translates to:
  /// **'Lámpara Auto-On:'**
  String get deviceInfoAutoLampLabel;

  /// No description provided for @deviceInfoMaintenanceModeLabel.
  ///
  /// In es, this message translates to:
  /// **'Modo Mantenimiento:'**
  String get deviceInfoMaintenanceModeLabel;

  /// No description provided for @deviceInfoLockedLabel.
  ///
  /// In es, this message translates to:
  /// **'Bloqueado:'**
  String get deviceInfoLockedLabel;

  /// No description provided for @deviceInfoInstallationDateLabel.
  ///
  /// In es, this message translates to:
  /// **'Fecha Instalación:'**
  String get deviceInfoInstallationDateLabel;

  /// No description provided for @deviceInfoWarrantyDateLabel.
  ///
  /// In es, this message translates to:
  /// **'Vencimiento Garantía:'**
  String get deviceInfoWarrantyDateLabel;

  /// No description provided for @deviceInfoScheduledMaintLabel.
  ///
  /// In es, this message translates to:
  /// **'Mantenimiento Programado:'**
  String get deviceInfoScheduledMaintLabel;

  /// No description provided for @deviceInfoMaintNotesLabel.
  ///
  /// In es, this message translates to:
  /// **'Notas Mantenimiento:'**
  String get deviceInfoMaintNotesLabel;

  /// No description provided for @deviceInfoPowerTypeLabel.
  ///
  /// In es, this message translates to:
  /// **'Tipo Corriente:'**
  String get deviceInfoPowerTypeLabel;

  /// No description provided for @deviceInfoMotorTypeLabel.
  ///
  /// In es, this message translates to:
  /// **'Tipo Motor:'**
  String get deviceInfoMotorTypeLabel;

  /// No description provided for @deviceInfoOpeningPhotocellLabel.
  ///
  /// In es, this message translates to:
  /// **'Fotocélula Apertura:'**
  String get deviceInfoOpeningPhotocellLabel;

  /// No description provided for @deviceInfoClosingPhotocellLabel.
  ///
  /// In es, this message translates to:
  /// **'Fotocélula Cierre:'**
  String get deviceInfoClosingPhotocellLabel;

  /// No description provided for @deviceInfoSecondsSuffix.
  ///
  /// In es, this message translates to:
  /// **' seg'**
  String get deviceInfoSecondsSuffix;

  /// No description provided for @deviceInfoViewAllDetailsBtn.
  ///
  /// In es, this message translates to:
  /// **'Ver todos los detalles'**
  String get deviceInfoViewAllDetailsBtn;

  /// No description provided for @deviceAddTitle.
  ///
  /// In es, this message translates to:
  /// **'Agregar Dispositivo'**
  String get deviceAddTitle;

  /// No description provided for @deviceScanBtn.
  ///
  /// In es, this message translates to:
  /// **'Escanear QR / Wifi'**
  String get deviceScanBtn;

  /// No description provided for @deviceFormNameLabel.
  ///
  /// In es, this message translates to:
  /// **'Nombre *'**
  String get deviceFormNameLabel;

  /// No description provided for @deviceFormLocationLabel.
  ///
  /// In es, this message translates to:
  /// **'Ubicación *'**
  String get deviceFormLocationLabel;

  /// No description provided for @deviceFormSerialLabel.
  ///
  /// In es, this message translates to:
  /// **'Número de Serie *'**
  String get deviceFormSerialLabel;

  /// No description provided for @deviceFormMacLabel.
  ///
  /// In es, this message translates to:
  /// **'Dirección MAC *'**
  String get deviceFormMacLabel;

  /// No description provided for @deviceFormProgressTitle.
  ///
  /// In es, this message translates to:
  /// **'Progreso del Formulario'**
  String get deviceFormProgressTitle;

  /// No description provided for @deviceFormProgressCount.
  ///
  /// In es, this message translates to:
  /// **'{completed} de 7 secciones'**
  String deviceFormProgressCount(int completed);

  /// No description provided for @deviceFormSectionBasic.
  ///
  /// In es, this message translates to:
  /// **'Información Básica'**
  String get deviceFormSectionBasic;

  /// No description provided for @deviceFormSectionId.
  ///
  /// In es, this message translates to:
  /// **'Identificación'**
  String get deviceFormSectionId;

  /// No description provided for @deviceFormSectionConfig.
  ///
  /// In es, this message translates to:
  /// **'Configuración Operativa'**
  String get deviceFormSectionConfig;

  /// No description provided for @deviceFormSectionPhysical.
  ///
  /// In es, this message translates to:
  /// **'Información Física'**
  String get deviceFormSectionPhysical;

  /// No description provided for @deviceFormSectionMaintenance.
  ///
  /// In es, this message translates to:
  /// **'Mantenimiento'**
  String get deviceFormSectionMaintenance;

  /// No description provided for @deviceFormSectionVita.
  ///
  /// In es, this message translates to:
  /// **'Configuración VITA'**
  String get deviceFormSectionVita;

  /// No description provided for @deviceFormNamePlaceholder.
  ///
  /// In es, this message translates to:
  /// **'Nombre del dispositivo'**
  String get deviceFormNamePlaceholder;

  /// No description provided for @deviceFormLocationPlaceholder.
  ///
  /// In es, this message translates to:
  /// **'Selecciona ubicación'**
  String get deviceFormLocationPlaceholder;

  /// No description provided for @deviceFormDescriptionLabel.
  ///
  /// In es, this message translates to:
  /// **'Descripción'**
  String get deviceFormDescriptionLabel;

  /// No description provided for @deviceFormDescriptionPlaceholder.
  ///
  /// In es, this message translates to:
  /// **'Descripción (opcional)'**
  String get deviceFormDescriptionPlaceholder;

  /// No description provided for @deviceFormModelLabel.
  ///
  /// In es, this message translates to:
  /// **'Modelo *'**
  String get deviceFormModelLabel;

  /// No description provided for @deviceFormModelPlaceholder.
  ///
  /// In es, this message translates to:
  /// **'Selecciona modelo'**
  String get deviceFormModelPlaceholder;

  /// No description provided for @deviceFormSubmitCreate.
  ///
  /// In es, this message translates to:
  /// **'Crear Dispositivo'**
  String get deviceFormSubmitCreate;

  /// No description provided for @deviceFormSubmitUpdate.
  ///
  /// In es, this message translates to:
  /// **'Guardar Cambios'**
  String get deviceFormSubmitUpdate;

  /// No description provided for @deviceFormCancel.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get deviceFormCancel;

  /// No description provided for @deviceFormErrorRequired.
  ///
  /// In es, this message translates to:
  /// **'Por favor completa todos los campos obligatorios'**
  String get deviceFormErrorRequired;

  /// No description provided for @deviceFormErrorLocation.
  ///
  /// In es, this message translates to:
  /// **'Selecciona una ubicación'**
  String get deviceFormErrorLocation;

  /// No description provided for @deviceFormErrorModel.
  ///
  /// In es, this message translates to:
  /// **'Selecciona un modelo'**
  String get deviceFormErrorModel;

  /// No description provided for @deviceFormErrorSave.
  ///
  /// In es, this message translates to:
  /// **'Error al guardar: {error}'**
  String deviceFormErrorSave(Object error);

  /// No description provided for @deviceFormStatusLabel.
  ///
  /// In es, this message translates to:
  /// **'Estado'**
  String get deviceFormStatusLabel;

  /// No description provided for @deviceFormStatusPlaceholder.
  ///
  /// In es, this message translates to:
  /// **'Selecciona estado'**
  String get deviceFormStatusPlaceholder;

  /// No description provided for @deviceFormTypeLabel.
  ///
  /// In es, this message translates to:
  /// **'Tipo de Dispositivo'**
  String get deviceFormTypeLabel;

  /// No description provided for @deviceFormTypePlaceholder.
  ///
  /// In es, this message translates to:
  /// **'Selecciona tipo'**
  String get deviceFormTypePlaceholder;

  /// No description provided for @deviceFormPhotoLabel.
  ///
  /// In es, this message translates to:
  /// **'Foto del dispositivo'**
  String get deviceFormPhotoLabel;

  /// No description provided for @deviceFormPhotoHint.
  ///
  /// In es, this message translates to:
  /// **'Toca para añadir una foto'**
  String get deviceFormPhotoHint;

  /// No description provided for @deviceInfoSignalStrength.
  ///
  /// In es, this message translates to:
  /// **'{percentage}% señal'**
  String deviceInfoSignalStrength(int percentage);

  /// No description provided for @deviceInfoSecondsValue.
  ///
  /// In es, this message translates to:
  /// **'{seconds} seg'**
  String deviceInfoSecondsValue(Object seconds);

  /// No description provided for @groupsStatusReady.
  ///
  /// In es, this message translates to:
  /// **'Listo'**
  String get groupsStatusReady;

  /// No description provided for @groupsErrorSelectGroupFirst.
  ///
  /// In es, this message translates to:
  /// **'Selecciona un grupo primero'**
  String get groupsErrorSelectGroupFirst;

  /// No description provided for @groupsErrorTodosReadonly.
  ///
  /// In es, this message translates to:
  /// **'No se pueden agregar dispositivos manualmente al grupo TODOS'**
  String get groupsErrorTodosReadonly;

  /// No description provided for @groupsErrorSelectDeviceAdd.
  ///
  /// In es, this message translates to:
  /// **'Selecciona un dispositivo para agregar'**
  String get groupsErrorSelectDeviceAdd;

  /// No description provided for @groupsErrorDeviceAlreadyInGroup.
  ///
  /// In es, this message translates to:
  /// **'El dispositivo ya está en este grupo'**
  String get groupsErrorDeviceAlreadyInGroup;

  /// No description provided for @groupsSuccessDeviceAdded.
  ///
  /// In es, this message translates to:
  /// **'Dispositivo \"{deviceName}\" añadido a {groupName}'**
  String groupsSuccessDeviceAdded(String deviceName, String groupName);

  /// No description provided for @groupsTitle.
  ///
  /// In es, this message translates to:
  /// **'Gestión de Grupos'**
  String get groupsTitle;

  /// No description provided for @groupsSubtitleDevicesInGroup.
  ///
  /// In es, this message translates to:
  /// **'Dispositivos en este grupo'**
  String get groupsSubtitleDevicesInGroup;

  /// No description provided for @groupsControlPrefix.
  ///
  /// In es, this message translates to:
  /// **'Control: {deviceName}'**
  String groupsControlPrefix(String deviceName);

  /// No description provided for @groupsButtonMoreDetails.
  ///
  /// In es, this message translates to:
  /// **'Más detalles y configuración'**
  String get groupsButtonMoreDetails;

  /// No description provided for @groupsSubtitleAddMore.
  ///
  /// In es, this message translates to:
  /// **'Agregar más dispositivos'**
  String get groupsSubtitleAddMore;

  /// No description provided for @groupsDropdownHint.
  ///
  /// In es, this message translates to:
  /// **'Selecciona para agregar...'**
  String get groupsDropdownHint;

  /// No description provided for @groupsDropdownEmpty.
  ///
  /// In es, this message translates to:
  /// **'No hay dispositivos disponibles'**
  String get groupsDropdownEmpty;

  /// No description provided for @groupsButtonAdd.
  ///
  /// In es, this message translates to:
  /// **'Agregar a este grupo'**
  String get groupsButtonAdd;

  /// No description provided for @groupsInfoTodosTitle.
  ///
  /// In es, this message translates to:
  /// **'Grupo Automático \"TODOS\"'**
  String get groupsInfoTodosTitle;

  /// No description provided for @groupsInfoTodosBody.
  ///
  /// In es, this message translates to:
  /// **'Este grupo incluye automáticamente todos tus dispositivos. No puedes agregar ni quitar dispositivos manualmente aquí.'**
  String get groupsInfoTodosBody;

  /// No description provided for @groupsEmptyList.
  ///
  /// In es, this message translates to:
  /// **'No hay dispositivos en este grupo'**
  String get groupsEmptyList;

  /// No description provided for @groupCreateTitle.
  ///
  /// In es, this message translates to:
  /// **'Crear Nuevo Grupo'**
  String get groupCreateTitle;

  /// No description provided for @groupEditTitle.
  ///
  /// In es, this message translates to:
  /// **'Editar Grupo'**
  String get groupEditTitle;

  /// No description provided for @groupNameLabel.
  ///
  /// In es, this message translates to:
  /// **'Nombre del Grupo'**
  String get groupNameLabel;

  /// No description provided for @groupDescLabel.
  ///
  /// In es, this message translates to:
  /// **'Descripción (Opcional)'**
  String get groupDescLabel;

  /// No description provided for @groupDeleteConfirmTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Eliminar Grupo?'**
  String get groupDeleteConfirmTitle;

  /// No description provided for @groupDeleteConfirmBody.
  ///
  /// In es, this message translates to:
  /// **'Esta acción no se puede deshacer.'**
  String get groupDeleteConfirmBody;

  /// No description provided for @deviceRemoveConfirmTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Quitar Dispositivo?'**
  String get deviceRemoveConfirmTitle;

  /// No description provided for @deviceRemoveConfirmBody.
  ///
  /// In es, this message translates to:
  /// **'¿Estás seguro de que deseas quitar este dispositivo del grupo?'**
  String get deviceRemoveConfirmBody;

  /// No description provided for @groupsBtnCancel.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get groupsBtnCancel;

  /// No description provided for @groupsBtnCreate.
  ///
  /// In es, this message translates to:
  /// **'Crear'**
  String get groupsBtnCreate;

  /// No description provided for @groupsBtnSave.
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get groupsBtnSave;

  /// No description provided for @groupsBtnRemove.
  ///
  /// In es, this message translates to:
  /// **'Quitar'**
  String get groupsBtnRemove;

  /// No description provided for @groupsBtnDelete.
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get groupsBtnDelete;

  /// No description provided for @groupsTitleSimple.
  ///
  /// In es, this message translates to:
  /// **'Grupos'**
  String get groupsTitleSimple;

  /// No description provided for @groupsButtonCreateAction.
  ///
  /// In es, this message translates to:
  /// **'Crear Grupo'**
  String get groupsButtonCreateAction;

  /// No description provided for @groupsSubsectionDevices.
  ///
  /// In es, this message translates to:
  /// **'Dispositivos'**
  String get groupsSubsectionDevices;

  /// No description provided for @groupsSuccessCreated.
  ///
  /// In es, this message translates to:
  /// **'Grupo creado exitosamente'**
  String get groupsSuccessCreated;

  /// No description provided for @groupsSuccessUpdated.
  ///
  /// In es, this message translates to:
  /// **'Grupo actualizado'**
  String get groupsSuccessUpdated;

  /// No description provided for @groupsSuccessDeleted.
  ///
  /// In es, this message translates to:
  /// **'Grupo eliminado'**
  String get groupsSuccessDeleted;

  /// No description provided for @groupsSuccessDeviceRemoved.
  ///
  /// In es, this message translates to:
  /// **'Dispositivo quitado del grupo'**
  String get groupsSuccessDeviceRemoved;

  /// No description provided for @generalRetry.
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get generalRetry;

  /// No description provided for @provisioningScanTitle.
  ///
  /// In es, this message translates to:
  /// **'Buscando Dispositivos'**
  String get provisioningScanTitle;

  /// No description provided for @provisioningScanSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Asegúrate que tu dispositivo esté en modo configuración (LED parpadeando).'**
  String get provisioningScanSubtitle;

  /// No description provided for @provisioningScanningText.
  ///
  /// In es, this message translates to:
  /// **'Escaneando...'**
  String get provisioningScanningText;

  /// No description provided for @provisioningDeviceFound.
  ///
  /// In es, this message translates to:
  /// **'Dispositivo detectado'**
  String get provisioningDeviceFound;

  /// No description provided for @provisioningConnectBtn.
  ///
  /// In es, this message translates to:
  /// **'Conectar'**
  String get provisioningConnectBtn;

  /// No description provided for @provisioningWifiTitle.
  ///
  /// In es, this message translates to:
  /// **'Conectar a Wifi'**
  String get provisioningWifiTitle;

  /// No description provided for @provisioningWifiSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Ingresa las credenciales para el dispositivo.'**
  String get provisioningWifiSubtitle;

  /// No description provided for @provisioningSsidLabel.
  ///
  /// In es, this message translates to:
  /// **'Nombre de la Red (SSID)'**
  String get provisioningSsidLabel;

  /// No description provided for @provisioningPasswordLabel.
  ///
  /// In es, this message translates to:
  /// **'Contraseña Wifi'**
  String get provisioningPasswordLabel;

  /// No description provided for @provisioningSendBtn.
  ///
  /// In es, this message translates to:
  /// **'Enviar Configuración'**
  String get provisioningSendBtn;

  /// No description provided for @provisioningSuccessTitle.
  ///
  /// In es, this message translates to:
  /// **'¡Configuración Exitosa!'**
  String get provisioningSuccessTitle;

  /// No description provided for @provisioningSuccessBody.
  ///
  /// In es, this message translates to:
  /// **'El dispositivo se ha conectado correctamente.'**
  String get provisioningSuccessBody;

  /// No description provided for @provisioningManualModeBtn.
  ///
  /// In es, this message translates to:
  /// **'¿No aparece? Configuración Manual (AP)'**
  String get provisioningManualModeBtn;

  /// No description provided for @provisioningErrorConnection.
  ///
  /// In es, this message translates to:
  /// **'No se pudo conectar al dispositivo'**
  String get provisioningErrorConnection;

  /// No description provided for @provisioningErrorWifi.
  ///
  /// In es, this message translates to:
  /// **'Contraseña incorrecta o Wifi no encontrado'**
  String get provisioningErrorWifi;

  /// No description provided for @devicesListTitle.
  ///
  /// In es, this message translates to:
  /// **'Dispositivos'**
  String get devicesListTitle;

  /// No description provided for @devicesTabDevices.
  ///
  /// In es, this message translates to:
  /// **'Dispositivos'**
  String get devicesTabDevices;

  /// No description provided for @devicesTabOthers.
  ///
  /// In es, this message translates to:
  /// **'Otros'**
  String get devicesTabOthers;

  /// No description provided for @deviceStatusOpening.
  ///
  /// In es, this message translates to:
  /// **'Abriendo...'**
  String get deviceStatusOpening;

  /// No description provided for @deviceStatusClosing.
  ///
  /// In es, this message translates to:
  /// **'Cerrando...'**
  String get deviceStatusClosing;

  /// No description provided for @deviceStatusPaused.
  ///
  /// In es, this message translates to:
  /// **'Pausado'**
  String get deviceStatusPaused;

  /// No description provided for @deviceStatusPedestrianActive.
  ///
  /// In es, this message translates to:
  /// **'Modo Peatonal activado'**
  String get deviceStatusPedestrianActive;

  /// No description provided for @deviceStatusReady.
  ///
  /// In es, this message translates to:
  /// **'Listo'**
  String get deviceStatusReady;

  /// No description provided for @deviceAutoCloseCountdown.
  ///
  /// In es, this message translates to:
  /// **'Cierre automático en: {seconds} s'**
  String deviceAutoCloseCountdown(int seconds);

  /// No description provided for @emptyListMessage.
  ///
  /// In es, this message translates to:
  /// **'No hay elementos'**
  String get emptyListMessage;

  /// No description provided for @scanDevicesTitle.
  ///
  /// In es, this message translates to:
  /// **'Agregar Dispositivo'**
  String get scanDevicesTitle;

  /// No description provided for @scanDeviceLabel.
  ///
  /// In es, this message translates to:
  /// **'Dispositivo:'**
  String get scanDeviceLabel;

  /// No description provided for @scanDeviceState.
  ///
  /// In es, this message translates to:
  /// **'Estado:'**
  String get scanDeviceState;

  /// No description provided for @scanDeviceDetail.
  ///
  /// In es, this message translates to:
  /// **'Detalle:'**
  String get scanDeviceDetail;

  /// No description provided for @scanButtonScan.
  ///
  /// In es, this message translates to:
  /// **'Escanear'**
  String get scanButtonScan;

  /// No description provided for @scanWifiNetworksDetected.
  ///
  /// In es, this message translates to:
  /// **'Redes Wi-Fi Detectadas'**
  String get scanWifiNetworksDetected;

  /// No description provided for @scanVitaDevicesAvailable.
  ///
  /// In es, this message translates to:
  /// **'VITA\'S disponibles'**
  String get scanVitaDevicesAvailable;

  /// No description provided for @scanVitaDevices.
  ///
  /// In es, this message translates to:
  /// **'Dispositivos VITA'**
  String get scanVitaDevices;

  /// No description provided for @scanSerialNumberHint.
  ///
  /// In es, this message translates to:
  /// **'Vincular por No de Serie'**
  String get scanSerialNumberHint;

  /// No description provided for @scanSerialNumberLabel.
  ///
  /// In es, this message translates to:
  /// **'Número de Serie'**
  String get scanSerialNumberLabel;

  /// No description provided for @scanButtonAdd.
  ///
  /// In es, this message translates to:
  /// **'Agregar'**
  String get scanButtonAdd;

  /// No description provided for @scanCompletedMessage.
  ///
  /// In es, this message translates to:
  /// **'Escaneo completado - {count} redes encontradas'**
  String scanCompletedMessage(int count);

  /// No description provided for @scanSelectDeviceError.
  ///
  /// In es, this message translates to:
  /// **'Selecciona un dispositivo VITA o ingresa un número de serie'**
  String get scanSelectDeviceError;

  /// No description provided for @scanDeviceAddedSuccess.
  ///
  /// In es, this message translates to:
  /// **'Dispositivo {deviceId} agregado'**
  String scanDeviceAddedSuccess(String deviceId);

  /// No description provided for @parametersTitle.
  ///
  /// In es, this message translates to:
  /// **'Parámetros\ndel Dispositivo'**
  String get parametersTitle;

  /// No description provided for @parametersDeviceLabel.
  ///
  /// In es, this message translates to:
  /// **'Dispositivo:'**
  String get parametersDeviceLabel;

  /// No description provided for @parametersModelLabel.
  ///
  /// In es, this message translates to:
  /// **'Mod:'**
  String get parametersModelLabel;

  /// No description provided for @parametersSerialLabel.
  ///
  /// In es, this message translates to:
  /// **'No. Serie:'**
  String get parametersSerialLabel;

  /// No description provided for @parametersStateLabel.
  ///
  /// In es, this message translates to:
  /// **'Estado:'**
  String get parametersStateLabel;

  /// No description provided for @parametersDetailLabel.
  ///
  /// In es, this message translates to:
  /// **'Detalle:'**
  String get parametersDetailLabel;

  /// No description provided for @parametersConfigSection.
  ///
  /// In es, this message translates to:
  /// **'Config Parámetros:'**
  String get parametersConfigSection;

  /// No description provided for @parametersNotificationsSection.
  ///
  /// In es, this message translates to:
  /// **'Config Notificaciones:'**
  String get parametersNotificationsSection;

  /// No description provided for @parametersAutoClose.
  ///
  /// In es, this message translates to:
  /// **'Cierre Automático'**
  String get parametersAutoClose;

  /// No description provided for @parametersCourtesyLight.
  ///
  /// In es, this message translates to:
  /// **'Luz de cortesía'**
  String get parametersCourtesyLight;

  /// No description provided for @parametersAutoCloseTime.
  ///
  /// In es, this message translates to:
  /// **'Tiempo antes de cerrar automáticamente'**
  String get parametersAutoCloseTime;

  /// No description provided for @parametersLockDevice.
  ///
  /// In es, this message translates to:
  /// **'Bloquear dispositivo'**
  String get parametersLockDevice;

  /// No description provided for @parametersKeepOpen.
  ///
  /// In es, this message translates to:
  /// **'Mantener abierto'**
  String get parametersKeepOpen;

  /// No description provided for @parametersDisconnectionReminder.
  ///
  /// In es, this message translates to:
  /// **'Recordatorio falta de conexión'**
  String get parametersDisconnectionReminder;

  /// No description provided for @parametersOpenDoorReminder.
  ///
  /// In es, this message translates to:
  /// **'Recordatorio puerta abierta'**
  String get parametersOpenDoorReminder;

  /// No description provided for @parametersForcedOpeningAlarm.
  ///
  /// In es, this message translates to:
  /// **'Alarma Apertura Forzada'**
  String get parametersForcedOpeningAlarm;

  /// No description provided for @parametersPhotocellBlocked.
  ///
  /// In es, this message translates to:
  /// **'Foto celda bloqueada'**
  String get parametersPhotocellBlocked;

  /// No description provided for @parametersOpeningNotAllowed.
  ///
  /// In es, this message translates to:
  /// **'Apertura no permitida'**
  String get parametersOpeningNotAllowed;

  /// No description provided for @parametersUpdateAvailable.
  ///
  /// In es, this message translates to:
  /// **'Actualización disponible'**
  String get parametersUpdateAvailable;

  /// No description provided for @parametersMaintenanceRequest.
  ///
  /// In es, this message translates to:
  /// **'Solicitud de mantenimiento'**
  String get parametersMaintenanceRequest;

  /// No description provided for @parametersOpenDoorReminderTime.
  ///
  /// In es, this message translates to:
  /// **'Tiempo recordatorio puerta abierta'**
  String get parametersOpenDoorReminderTime;

  /// No description provided for @parametersConnectionFailureTime.
  ///
  /// In es, this message translates to:
  /// **'Tiempo falta de conexión'**
  String get parametersConnectionFailureTime;

  /// No description provided for @parametersPhotocellBlockedTime.
  ///
  /// In es, this message translates to:
  /// **'Tiempo foto celda bloqueada'**
  String get parametersPhotocellBlockedTime;

  /// No description provided for @parametersUpdateButton.
  ///
  /// In es, this message translates to:
  /// **'Actualizar parámetros'**
  String get parametersUpdateButton;

  /// No description provided for @parametersUpdatedSuccess.
  ///
  /// In es, this message translates to:
  /// **'Parámetros actualizados correctamente'**
  String get parametersUpdatedSuccess;

  /// No description provided for @settingsTitle.
  ///
  /// In es, this message translates to:
  /// **'Configuración'**
  String get settingsTitle;

  /// No description provided for @settingsSelectCountry.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar País'**
  String get settingsSelectCountry;

  /// No description provided for @settingsSelectLanguage.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar Idioma'**
  String get settingsSelectLanguage;

  /// No description provided for @settingsSelectEnvironment.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar Entorno'**
  String get settingsSelectEnvironment;

  /// No description provided for @settingsCountryCostaRica.
  ///
  /// In es, this message translates to:
  /// **'Costa Rica'**
  String get settingsCountryCostaRica;

  /// No description provided for @settingsCountryMexico.
  ///
  /// In es, this message translates to:
  /// **'México'**
  String get settingsCountryMexico;

  /// No description provided for @settingsCountrySpain.
  ///
  /// In es, this message translates to:
  /// **'España'**
  String get settingsCountrySpain;

  /// No description provided for @settingsLanguageSpanish.
  ///
  /// In es, this message translates to:
  /// **'Español'**
  String get settingsLanguageSpanish;

  /// No description provided for @settingsLanguageEnglish.
  ///
  /// In es, this message translates to:
  /// **'English'**
  String get settingsLanguageEnglish;

  /// No description provided for @settingsEnvironmentProduction.
  ///
  /// In es, this message translates to:
  /// **'Producción'**
  String get settingsEnvironmentProduction;

  /// No description provided for @settingsEnvironmentStaging.
  ///
  /// In es, this message translates to:
  /// **'Staging'**
  String get settingsEnvironmentStaging;

  /// No description provided for @settingsEnvironmentDevelopment.
  ///
  /// In es, this message translates to:
  /// **'Desarrollo'**
  String get settingsEnvironmentDevelopment;

  /// No description provided for @settingsProfileSection.
  ///
  /// In es, this message translates to:
  /// **'Perfil de Usuario'**
  String get settingsProfileSection;

  /// No description provided for @settingsAppearanceSection.
  ///
  /// In es, this message translates to:
  /// **'Apariencia'**
  String get settingsAppearanceSection;

  /// No description provided for @settingsAccessibilitySection.
  ///
  /// In es, this message translates to:
  /// **'Accesibilidad'**
  String get settingsAccessibilitySection;

  /// No description provided for @settingsSecuritySection.
  ///
  /// In es, this message translates to:
  /// **'Seguridad'**
  String get settingsSecuritySection;

  /// No description provided for @settingsServerSection.
  ///
  /// In es, this message translates to:
  /// **'Configuración de Servidor'**
  String get settingsServerSection;

  /// No description provided for @settingsInfoSection.
  ///
  /// In es, this message translates to:
  /// **'Información'**
  String get settingsInfoSection;

  /// No description provided for @settingsFieldName.
  ///
  /// In es, this message translates to:
  /// **'Nombre'**
  String get settingsFieldName;

  /// No description provided for @settingsFieldPhone.
  ///
  /// In es, this message translates to:
  /// **'Teléfono'**
  String get settingsFieldPhone;

  /// No description provided for @settingsFieldEmail.
  ///
  /// In es, this message translates to:
  /// **'Correo'**
  String get settingsFieldEmail;

  /// No description provided for @settingsFieldAddress.
  ///
  /// In es, this message translates to:
  /// **'Dirección'**
  String get settingsFieldAddress;

  /// No description provided for @settingsFieldCountry.
  ///
  /// In es, this message translates to:
  /// **'País'**
  String get settingsFieldCountry;

  /// No description provided for @settingsFieldLanguage.
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get settingsFieldLanguage;

  /// No description provided for @settingsDarkMode.
  ///
  /// In es, this message translates to:
  /// **'Modo Oscuro'**
  String get settingsDarkMode;

  /// No description provided for @settingsFontSize.
  ///
  /// In es, this message translates to:
  /// **'Tamaño de Fuente'**
  String get settingsFontSize;

  /// No description provided for @settingsHighContrast.
  ///
  /// In es, this message translates to:
  /// **'Alto Contraste'**
  String get settingsHighContrast;

  /// No description provided for @settingsReduceMotion.
  ///
  /// In es, this message translates to:
  /// **'Reducir Movimiento'**
  String get settingsReduceMotion;

  /// No description provided for @settingsCurrentPassword.
  ///
  /// In es, this message translates to:
  /// **'Contraseña Actual'**
  String get settingsCurrentPassword;

  /// No description provided for @settingsNewPassword.
  ///
  /// In es, this message translates to:
  /// **'Contraseña Nueva'**
  String get settingsNewPassword;

  /// No description provided for @settingsRepeatPassword.
  ///
  /// In es, this message translates to:
  /// **'Repetir Contraseña'**
  String get settingsRepeatPassword;

  /// No description provided for @settingsBiometrics.
  ///
  /// In es, this message translates to:
  /// **'Habilitar Biometría'**
  String get settingsBiometrics;

  /// No description provided for @settingsBiometricsSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Usar huella o rostro para ingresar'**
  String get settingsBiometricsSubtitle;

  /// No description provided for @settingsEnvironment.
  ///
  /// In es, this message translates to:
  /// **'Entorno'**
  String get settingsEnvironment;

  /// No description provided for @settingsServerUrl.
  ///
  /// In es, this message translates to:
  /// **'URL del Servidor'**
  String get settingsServerUrl;

  /// No description provided for @settingsAppVersion.
  ///
  /// In es, this message translates to:
  /// **'Versión de la App'**
  String get settingsAppVersion;

  /// No description provided for @settingsTermsConditions.
  ///
  /// In es, this message translates to:
  /// **'Términos y Condiciones'**
  String get settingsTermsConditions;

  /// No description provided for @settingsPrivacyPolicy.
  ///
  /// In es, this message translates to:
  /// **'Política de Privacidad'**
  String get settingsPrivacyPolicy;

  /// No description provided for @settingsSaveChanges.
  ///
  /// In es, this message translates to:
  /// **'Guardar Cambios'**
  String get settingsSaveChanges;

  /// No description provided for @settingsChangeButton.
  ///
  /// In es, this message translates to:
  /// **'Cambiar'**
  String get settingsChangeButton;

  /// No description provided for @settingsChangePhoto.
  ///
  /// In es, this message translates to:
  /// **'Cambiar foto'**
  String get settingsChangePhoto;

  /// No description provided for @settingsPhotoCamera.
  ///
  /// In es, this message translates to:
  /// **'Cámara'**
  String get settingsPhotoCamera;

  /// No description provided for @settingsPhotoGallery.
  ///
  /// In es, this message translates to:
  /// **'Galería'**
  String get settingsPhotoGallery;

  /// No description provided for @settingsPhotoRemove.
  ///
  /// In es, this message translates to:
  /// **'Eliminar foto'**
  String get settingsPhotoRemove;

  /// No description provided for @settingsPhotoUpdated.
  ///
  /// In es, this message translates to:
  /// **'Foto de perfil actualizada'**
  String get settingsPhotoUpdated;

  /// No description provided for @settingsPhotoRemoved.
  ///
  /// In es, this message translates to:
  /// **'Foto de perfil eliminada'**
  String get settingsPhotoRemoved;

  /// No description provided for @settingsUpdatedSuccess.
  ///
  /// In es, this message translates to:
  /// **'Configuración actualizada exitosamente'**
  String get settingsUpdatedSuccess;

  /// No description provided for @bottomNavDevices.
  ///
  /// In es, this message translates to:
  /// **'Dispositivos'**
  String get bottomNavDevices;

  /// No description provided for @msgInvalidCredentials.
  ///
  /// In es, this message translates to:
  /// **'Correo o contraseña incorrectos'**
  String get msgInvalidCredentials;

  /// No description provided for @msgSessionExpired.
  ///
  /// In es, this message translates to:
  /// **'Tu sesión ha expirado'**
  String get msgSessionExpired;

  /// No description provided for @msgEmailAlreadyExists.
  ///
  /// In es, this message translates to:
  /// **'Este correo ya está registrado'**
  String get msgEmailAlreadyExists;

  /// No description provided for @msgPasswordMismatch.
  ///
  /// In es, this message translates to:
  /// **'Las contraseñas no coinciden'**
  String get msgPasswordMismatch;

  /// No description provided for @msgLoginSuccess.
  ///
  /// In es, this message translates to:
  /// **'Bienvenido a BGnius VITA'**
  String get msgLoginSuccess;

  /// No description provided for @msgRegisterSuccess.
  ///
  /// In es, this message translates to:
  /// **'Cuenta creada exitosamente'**
  String get msgRegisterSuccess;

  /// No description provided for @msgLogoutSuccess.
  ///
  /// In es, this message translates to:
  /// **'Sesión cerrada'**
  String get msgLogoutSuccess;

  /// No description provided for @msgPasswordResetSent.
  ///
  /// In es, this message translates to:
  /// **'Se ha enviado un enlace a tu correo'**
  String get msgPasswordResetSent;

  /// No description provided for @msgDeviceNotFound.
  ///
  /// In es, this message translates to:
  /// **'El dispositivo no fue encontrado'**
  String get msgDeviceNotFound;

  /// No description provided for @msgDeviceOffline.
  ///
  /// In es, this message translates to:
  /// **'El dispositivo está sin conexión'**
  String get msgDeviceOffline;

  /// No description provided for @msgCommandFailed.
  ///
  /// In es, this message translates to:
  /// **'No se pudo ejecutar el comando'**
  String get msgCommandFailed;

  /// No description provided for @msgDeviceAdded.
  ///
  /// In es, this message translates to:
  /// **'Dispositivo agregado exitosamente'**
  String get msgDeviceAdded;

  /// No description provided for @msgDeviceUpdated.
  ///
  /// In es, this message translates to:
  /// **'Dispositivo actualizado'**
  String get msgDeviceUpdated;

  /// No description provided for @msgDeviceDeleted.
  ///
  /// In es, this message translates to:
  /// **'Dispositivo eliminado'**
  String get msgDeviceDeleted;

  /// No description provided for @msgCommandSuccess.
  ///
  /// In es, this message translates to:
  /// **'Comando ejecutado correctamente'**
  String get msgCommandSuccess;

  /// No description provided for @msgUserNotFound.
  ///
  /// In es, this message translates to:
  /// **'Usuario no encontrado'**
  String get msgUserNotFound;

  /// No description provided for @msgUserAdded.
  ///
  /// In es, this message translates to:
  /// **'Usuario agregado exitosamente'**
  String get msgUserAdded;

  /// No description provided for @msgUserUpdated.
  ///
  /// In es, this message translates to:
  /// **'Usuario actualizado'**
  String get msgUserUpdated;

  /// No description provided for @msgUserDeleted.
  ///
  /// In es, this message translates to:
  /// **'Usuario eliminado'**
  String get msgUserDeleted;

  /// No description provided for @msgPermissionGranted.
  ///
  /// In es, this message translates to:
  /// **'Permiso otorgado'**
  String get msgPermissionGranted;

  /// No description provided for @msgPermissionRevoked.
  ///
  /// In es, this message translates to:
  /// **'Permiso revocado'**
  String get msgPermissionRevoked;

  /// No description provided for @msgUserLinked.
  ///
  /// In es, this message translates to:
  /// **'Usuario vinculado correctamente'**
  String get msgUserLinked;

  /// No description provided for @msgGroupCreated.
  ///
  /// In es, this message translates to:
  /// **'Grupo creado exitosamente'**
  String get msgGroupCreated;

  /// No description provided for @msgGroupUpdated.
  ///
  /// In es, this message translates to:
  /// **'Grupo actualizado'**
  String get msgGroupUpdated;

  /// No description provided for @msgGroupDeleted.
  ///
  /// In es, this message translates to:
  /// **'Grupo eliminado'**
  String get msgGroupDeleted;

  /// No description provided for @msgDeviceAddedToGroup.
  ///
  /// In es, this message translates to:
  /// **'Dispositivo agregado al grupo'**
  String get msgDeviceAddedToGroup;

  /// No description provided for @msgDeviceRemovedFromGroup.
  ///
  /// In es, this message translates to:
  /// **'Dispositivo removido del grupo'**
  String get msgDeviceRemovedFromGroup;

  /// No description provided for @msgRequiredField.
  ///
  /// In es, this message translates to:
  /// **'Este campo es obligatorio'**
  String get msgRequiredField;

  /// No description provided for @msgInvalidFormat.
  ///
  /// In es, this message translates to:
  /// **'El formato ingresado no es válido'**
  String get msgInvalidFormat;

  /// No description provided for @msgServerError.
  ///
  /// In es, this message translates to:
  /// **'Ocurrió un error en el servidor'**
  String get msgServerError;

  /// No description provided for @msgConnectionError.
  ///
  /// In es, this message translates to:
  /// **'No se pudo conectar al servidor'**
  String get msgConnectionError;

  /// No description provided for @msgUnknownError.
  ///
  /// In es, this message translates to:
  /// **'Ocurrió un error inesperado'**
  String get msgUnknownError;

  /// No description provided for @msgNoData.
  ///
  /// In es, this message translates to:
  /// **'No hay datos disponibles'**
  String get msgNoData;

  /// No description provided for @msgLoading.
  ///
  /// In es, this message translates to:
  /// **'Cargando...'**
  String get msgLoading;

  /// No description provided for @msgRetry.
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get msgRetry;

  /// No description provided for @msgCancel.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get msgCancel;

  /// No description provided for @msgAccept.
  ///
  /// In es, this message translates to:
  /// **'Aceptar'**
  String get msgAccept;

  /// No description provided for @msgSave.
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get msgSave;

  /// No description provided for @msgDelete.
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get msgDelete;

  /// No description provided for @msgEdit.
  ///
  /// In es, this message translates to:
  /// **'Editar'**
  String get msgEdit;

  /// No description provided for @msgAdd.
  ///
  /// In es, this message translates to:
  /// **'Agregar'**
  String get msgAdd;

  /// No description provided for @msgConfirm.
  ///
  /// In es, this message translates to:
  /// **'Confirmar'**
  String get msgConfirm;

  /// No description provided for @msgYes.
  ///
  /// In es, this message translates to:
  /// **'Sí'**
  String get msgYes;

  /// No description provided for @msgNo.
  ///
  /// In es, this message translates to:
  /// **'No'**
  String get msgNo;

  /// No description provided for @msgConfirmDelete.
  ///
  /// In es, this message translates to:
  /// **'¿Estás seguro de eliminar este elemento?'**
  String get msgConfirmDelete;

  /// No description provided for @msgConfirmDeleteDevice.
  ///
  /// In es, this message translates to:
  /// **'¿Deseas eliminar este dispositivo?'**
  String get msgConfirmDeleteDevice;

  /// No description provided for @msgConfirmDeleteUser.
  ///
  /// In es, this message translates to:
  /// **'¿Deseas eliminar este usuario?'**
  String get msgConfirmDeleteUser;

  /// No description provided for @msgConfirmLogout.
  ///
  /// In es, this message translates to:
  /// **'¿Deseas cerrar sesión?'**
  String get msgConfirmLogout;

  /// No description provided for @msgCannotUndo.
  ///
  /// In es, this message translates to:
  /// **'Esta acción no se puede deshacer'**
  String get msgCannotUndo;

  /// No description provided for @msgMinPasswordLength.
  ///
  /// In es, this message translates to:
  /// **'La contraseña debe tener al menos 8 caracteres'**
  String get msgMinPasswordLength;

  /// No description provided for @msgInvalidEmail.
  ///
  /// In es, this message translates to:
  /// **'El formato del correo no es válido'**
  String get msgInvalidEmail;

  /// No description provided for @msgInvalidPhone.
  ///
  /// In es, this message translates to:
  /// **'El formato del teléfono no es válido'**
  String get msgInvalidPhone;

  /// No description provided for @msgInvalidSerialNumber.
  ///
  /// In es, this message translates to:
  /// **'El número de serie no es válido'**
  String get msgInvalidSerialNumber;

  /// No description provided for @navDevices.
  ///
  /// In es, this message translates to:
  /// **'Dispositivos'**
  String get navDevices;

  /// No description provided for @navGroups.
  ///
  /// In es, this message translates to:
  /// **'Grupos'**
  String get navGroups;

  /// No description provided for @navUsers.
  ///
  /// In es, this message translates to:
  /// **'Usuarios'**
  String get navUsers;

  /// No description provided for @navSettings.
  ///
  /// In es, this message translates to:
  /// **'Configuración'**
  String get navSettings;

  /// No description provided for @sharedUsersTitle.
  ///
  /// In es, this message translates to:
  /// **'Usuarios\nRegistrados'**
  String get sharedUsersTitle;

  /// No description provided for @sharedUsersDeviceLabel.
  ///
  /// In es, this message translates to:
  /// **'Dispositivo:'**
  String get sharedUsersDeviceLabel;

  /// No description provided for @sharedUsersModelLabel.
  ///
  /// In es, this message translates to:
  /// **'Mod:'**
  String get sharedUsersModelLabel;

  /// No description provided for @sharedUsersSerialLabel.
  ///
  /// In es, this message translates to:
  /// **'No. Serie:'**
  String get sharedUsersSerialLabel;

  /// No description provided for @sharedUsersStatusLabel.
  ///
  /// In es, this message translates to:
  /// **'Estado:'**
  String get sharedUsersStatusLabel;

  /// No description provided for @sharedUsersDetailLabel.
  ///
  /// In es, this message translates to:
  /// **'Detalle:'**
  String get sharedUsersDetailLabel;

  /// No description provided for @sharedUsersSearchHint.
  ///
  /// In es, this message translates to:
  /// **'Buscar usuario'**
  String get sharedUsersSearchHint;

  /// No description provided for @sharedUsersEmptyList.
  ///
  /// In es, this message translates to:
  /// **'No hay usuarios registrados'**
  String get sharedUsersEmptyList;

  /// No description provided for @sharedUsersLinkButton.
  ///
  /// In es, this message translates to:
  /// **'Vincular Usuario'**
  String get sharedUsersLinkButton;

  /// No description provided for @deviceEditTitle.
  ///
  /// In es, this message translates to:
  /// **'Editar Dispositivo'**
  String get deviceEditTitle;

  /// No description provided for @deviceEditSuccessMessage.
  ///
  /// In es, this message translates to:
  /// **'Dispositivo actualizado correctamente'**
  String get deviceEditSuccessMessage;

  /// No description provided for @deviceEditErrorLoading.
  ///
  /// In es, this message translates to:
  /// **'Error al cargar'**
  String get deviceEditErrorLoading;

  /// No description provided for @deviceControlTitle.
  ///
  /// In es, this message translates to:
  /// **'Detalle del Dispositivo'**
  String get deviceControlTitle;

  /// No description provided for @deviceControlButtonOpen.
  ///
  /// In es, this message translates to:
  /// **'Abrir'**
  String get deviceControlButtonOpen;

  /// No description provided for @deviceControlButtonPause.
  ///
  /// In es, this message translates to:
  /// **'Pausa'**
  String get deviceControlButtonPause;

  /// No description provided for @deviceControlButtonClose.
  ///
  /// In es, this message translates to:
  /// **'Cerrar'**
  String get deviceControlButtonClose;

  /// No description provided for @deviceControlButtonPedestrian.
  ///
  /// In es, this message translates to:
  /// **'Peatonal'**
  String get deviceControlButtonPedestrian;

  /// No description provided for @deviceControlButtonLock.
  ///
  /// In es, this message translates to:
  /// **'Bloqueo'**
  String get deviceControlButtonLock;

  /// No description provided for @deviceControlButtonLight.
  ///
  /// In es, this message translates to:
  /// **'Lámpara'**
  String get deviceControlButtonLight;

  /// No description provided for @deviceControlButtonSwitch.
  ///
  /// In es, this message translates to:
  /// **'Switch'**
  String get deviceControlButtonSwitch;

  /// No description provided for @deviceControlStatusOpening.
  ///
  /// In es, this message translates to:
  /// **'Abriendo portón...'**
  String get deviceControlStatusOpening;

  /// No description provided for @deviceControlStatusPausing.
  ///
  /// In es, this message translates to:
  /// **'Pausando...'**
  String get deviceControlStatusPausing;

  /// No description provided for @deviceControlStatusClosing.
  ///
  /// In es, this message translates to:
  /// **'Cerrando portón...'**
  String get deviceControlStatusClosing;

  /// No description provided for @deviceControlStatusPedestrian.
  ///
  /// In es, this message translates to:
  /// **'Apertura peatonal...'**
  String get deviceControlStatusPedestrian;

  /// No description provided for @deviceControlStatusLocked.
  ///
  /// In es, this message translates to:
  /// **'Dispositivo Bloqueado'**
  String get deviceControlStatusLocked;

  /// No description provided for @deviceControlStatusLightOn.
  ///
  /// In es, this message translates to:
  /// **'Luz encendida'**
  String get deviceControlStatusLightOn;

  /// No description provided for @deviceControlStatusSwitchActive.
  ///
  /// In es, this message translates to:
  /// **'Switch activado'**
  String get deviceControlStatusSwitchActive;

  /// No description provided for @deviceControlAutoCloseCountdown.
  ///
  /// In es, this message translates to:
  /// **'Cierre autom. en: {seconds} s'**
  String deviceControlAutoCloseCountdown(Object seconds);

  /// No description provided for @deviceControlLinkEdit.
  ///
  /// In es, this message translates to:
  /// **'Editar Dispositivo'**
  String get deviceControlLinkEdit;

  /// No description provided for @deviceControlLinkUsers.
  ///
  /// In es, this message translates to:
  /// **'Usuarios con Acceso'**
  String get deviceControlLinkUsers;

  /// No description provided for @deviceControlLinkParams.
  ///
  /// In es, this message translates to:
  /// **'Parámetros'**
  String get deviceControlLinkParams;

  /// No description provided for @deviceControlLinkEvents.
  ///
  /// In es, this message translates to:
  /// **'Registro de Eventos'**
  String get deviceControlLinkEvents;

  /// No description provided for @deviceControlLinkContact.
  ///
  /// In es, this message translates to:
  /// **'Contacto Técnico'**
  String get deviceControlLinkContact;

  /// No description provided for @deviceControlLinkInfo.
  ///
  /// In es, this message translates to:
  /// **'Información del Dispositivo'**
  String get deviceControlLinkInfo;

  /// No description provided for @technicalContactTitle.
  ///
  /// In es, this message translates to:
  /// **'Contacto Técnico'**
  String get technicalContactTitle;

  /// No description provided for @technicalContactDeviceLabel.
  ///
  /// In es, this message translates to:
  /// **'Dispositivo:'**
  String get technicalContactDeviceLabel;

  /// No description provided for @technicalContactModelLabel.
  ///
  /// In es, this message translates to:
  /// **'Mod:'**
  String get technicalContactModelLabel;

  /// No description provided for @technicalContactSerialLabel.
  ///
  /// In es, this message translates to:
  /// **'No. Serie:'**
  String get technicalContactSerialLabel;

  /// No description provided for @technicalContactStatusLabel.
  ///
  /// In es, this message translates to:
  /// **'Estado:'**
  String get technicalContactStatusLabel;

  /// No description provided for @technicalContactDetailLabel.
  ///
  /// In es, this message translates to:
  /// **'Detalle:'**
  String get technicalContactDetailLabel;

  /// No description provided for @technicalContactTechDataTitle.
  ///
  /// In es, this message translates to:
  /// **'Datos del Técnico'**
  String get technicalContactTechDataTitle;

  /// No description provided for @technicalContactNameHint.
  ///
  /// In es, this message translates to:
  /// **'Nombre de usuario'**
  String get technicalContactNameHint;

  /// No description provided for @technicalContactEmailHint.
  ///
  /// In es, this message translates to:
  /// **'Correo'**
  String get technicalContactEmailHint;

  /// No description provided for @technicalContactCountryHint.
  ///
  /// In es, this message translates to:
  /// **'País'**
  String get technicalContactCountryHint;

  /// No description provided for @technicalContactPhoneHint.
  ///
  /// In es, this message translates to:
  /// **'Teléfono'**
  String get technicalContactPhoneHint;

  /// No description provided for @technicalContactAiDescription.
  ///
  /// In es, this message translates to:
  /// **'Nuestra IA revisa periódicamente tu automatismo, analiza su rendimiento y detecta posibles signos de desgaste o fallos. Con base en esto, te informa cuando tu sistema necesita mantenimiento.'**
  String get technicalContactAiDescription;

  /// No description provided for @technicalContactAiPermissionText.
  ///
  /// In es, this message translates to:
  /// **'Permitir que la IA me informe cuando se requiera mantenimiento.'**
  String get technicalContactAiPermissionText;

  /// No description provided for @technicalContactNotesTitle.
  ///
  /// In es, this message translates to:
  /// **'Notas'**
  String get technicalContactNotesTitle;

  /// No description provided for @technicalContactDeleteButton.
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get technicalContactDeleteButton;

  /// No description provided for @technicalContactSaveButton.
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get technicalContactSaveButton;

  /// No description provided for @technicalContactDeleteDialogTitle.
  ///
  /// In es, this message translates to:
  /// **'Eliminar Contacto'**
  String get technicalContactDeleteDialogTitle;

  /// No description provided for @technicalContactDeleteDialogContent.
  ///
  /// In es, this message translates to:
  /// **'¿Estás seguro que deseas eliminar este contacto técnico?'**
  String get technicalContactDeleteDialogContent;

  /// No description provided for @technicalContactCancelButton.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get technicalContactCancelButton;

  /// No description provided for @technicalContactSaveSuccess.
  ///
  /// In es, this message translates to:
  /// **'Contacto técnico guardado exitosamente'**
  String get technicalContactSaveSuccess;

  /// No description provided for @technicalContactDeleteSuccess.
  ///
  /// In es, this message translates to:
  /// **'Contacto técnico eliminado'**
  String get technicalContactDeleteSuccess;

  /// No description provided for @technicalContactMaintenanceInfo.
  ///
  /// In es, this message translates to:
  /// **'Contactando mantenimiento - Próximamente'**
  String get technicalContactMaintenanceInfo;

  /// No description provided for @linkVirtualUserTitle.
  ///
  /// In es, this message translates to:
  /// **'Vincular usuario virtual'**
  String get linkVirtualUserTitle;

  /// No description provided for @linkVirtualUserEmailLabel.
  ///
  /// In es, this message translates to:
  /// **'Correo/Usuario'**
  String get linkVirtualUserEmailLabel;

  /// No description provided for @linkVirtualUserEmailHint.
  ///
  /// In es, this message translates to:
  /// **'Correo/Usuario'**
  String get linkVirtualUserEmailHint;

  /// No description provided for @linkVirtualUserLabelLabel.
  ///
  /// In es, this message translates to:
  /// **'Etiqueta'**
  String get linkVirtualUserLabelLabel;

  /// No description provided for @linkVirtualUserLabelHint.
  ///
  /// In es, this message translates to:
  /// **'Etiqueta'**
  String get linkVirtualUserLabelHint;

  /// No description provided for @linkVirtualUserAddButton.
  ///
  /// In es, this message translates to:
  /// **'Agregar Usuario al Listado'**
  String get linkVirtualUserAddButton;

  /// No description provided for @linkVirtualUserNewUserName.
  ///
  /// In es, this message translates to:
  /// **'Nuevo Usuario'**
  String get linkVirtualUserNewUserName;

  /// No description provided for @linkVirtualUserErrorEmail.
  ///
  /// In es, this message translates to:
  /// **'Por favor ingrese correo o usuario'**
  String get linkVirtualUserErrorEmail;

  /// No description provided for @linkVirtualUserSuccess.
  ///
  /// In es, this message translates to:
  /// **'Usuario agregado. Configura sus permisos.'**
  String get linkVirtualUserSuccess;

  /// No description provided for @deviceControlSimpleTitle.
  ///
  /// In es, this message translates to:
  /// **'Controles'**
  String get deviceControlSimpleTitle;

  /// No description provided for @deviceControlLocationTitle.
  ///
  /// In es, this message translates to:
  /// **'Ubicación'**
  String get deviceControlLocationTitle;

  /// No description provided for @deviceControlDescriptionTitle.
  ///
  /// In es, this message translates to:
  /// **'Descripción'**
  String get deviceControlDescriptionTitle;

  /// No description provided for @deviceControlStatusTitle.
  ///
  /// In es, this message translates to:
  /// **'Estado'**
  String get deviceControlStatusTitle;

  /// No description provided for @usersScreenTitle.
  ///
  /// In es, this message translates to:
  /// **'Usuarios con Accesos'**
  String get usersScreenTitle;

  /// No description provided for @usersScreenDeviceLabel.
  ///
  /// In es, this message translates to:
  /// **'Dispositivo:'**
  String get usersScreenDeviceLabel;

  /// No description provided for @usersScreenModelLabel.
  ///
  /// In es, this message translates to:
  /// **'Mod:'**
  String get usersScreenModelLabel;

  /// No description provided for @usersScreenSerialLabel.
  ///
  /// In es, this message translates to:
  /// **'No. Serie:'**
  String get usersScreenSerialLabel;

  /// No description provided for @usersScreenStatusLabel.
  ///
  /// In es, this message translates to:
  /// **'Estado:'**
  String get usersScreenStatusLabel;

  /// No description provided for @usersScreenDetailLabel.
  ///
  /// In es, this message translates to:
  /// **'Detalle:'**
  String get usersScreenDetailLabel;

  /// No description provided for @usersScreenAvailableUsersTitle.
  ///
  /// In es, this message translates to:
  /// **'Usuarios Disponibles:'**
  String get usersScreenAvailableUsersTitle;

  /// No description provided for @usersScreenLinkButton.
  ///
  /// In es, this message translates to:
  /// **'Vincular Usuario Existente'**
  String get usersScreenLinkButton;

  /// No description provided for @usersScreenErrorSelectUsers.
  ///
  /// In es, this message translates to:
  /// **'Selecciona al menos un usuario'**
  String get usersScreenErrorSelectUsers;

  /// No description provided for @usersScreenSuccessLinked.
  ///
  /// In es, this message translates to:
  /// **'{count} usuario(s) vinculado(s) exitosamente'**
  String usersScreenSuccessLinked(Object count);

  /// No description provided for @usersScreenEditInfo.
  ///
  /// In es, this message translates to:
  /// **'Editar {name} - Próximamente'**
  String usersScreenEditInfo(Object name);

  /// No description provided for @userAccessScreenTitle.
  ///
  /// In es, this message translates to:
  /// **'Usuarios con Accesos'**
  String get userAccessScreenTitle;

  /// No description provided for @userAccessDeviceLabel.
  ///
  /// In es, this message translates to:
  /// **'Dispositivo:'**
  String get userAccessDeviceLabel;

  /// No description provided for @userAccessModelLabel.
  ///
  /// In es, this message translates to:
  /// **'Mod:'**
  String get userAccessModelLabel;

  /// No description provided for @userAccessSerialLabel.
  ///
  /// In es, this message translates to:
  /// **'No. Serie:'**
  String get userAccessSerialLabel;

  /// No description provided for @userAccessStatusLabel.
  ///
  /// In es, this message translates to:
  /// **'Estado:'**
  String get userAccessStatusLabel;

  /// No description provided for @userAccessDetailLabel.
  ///
  /// In es, this message translates to:
  /// **'Detalle:'**
  String get userAccessDetailLabel;

  /// No description provided for @userAccessLinkedUsersTitle.
  ///
  /// In es, this message translates to:
  /// **'Usuarios Actualmente Vinculados'**
  String get userAccessLinkedUsersTitle;

  /// No description provided for @userAccessLinkedUsersDesc.
  ///
  /// In es, this message translates to:
  /// **'Estos usuarios ya pueden acceder a este dispositivo'**
  String get userAccessLinkedUsersDesc;

  /// No description provided for @userAccessAvailableUsersTitle.
  ///
  /// In es, this message translates to:
  /// **'Usuarios Disponibles para Vincular'**
  String get userAccessAvailableUsersTitle;

  /// No description provided for @userAccessAvailableUsersDesc.
  ///
  /// In es, this message translates to:
  /// **'Selecciona usuarios para darles acceso a este dispositivo'**
  String get userAccessAvailableUsersDesc;

  /// No description provided for @userAccessSearchHint.
  ///
  /// In es, this message translates to:
  /// **'Buscar usuario...'**
  String get userAccessSearchHint;

  /// No description provided for @userAccessTooltipAdmin.
  ///
  /// In es, this message translates to:
  /// **'Administrador'**
  String get userAccessTooltipAdmin;

  /// No description provided for @userAccessTooltipUnlink.
  ///
  /// In es, this message translates to:
  /// **'Desvincular'**
  String get userAccessTooltipUnlink;

  /// No description provided for @userAccessEditButton.
  ///
  /// In es, this message translates to:
  /// **'Editar'**
  String get userAccessEditButton;

  /// No description provided for @userAccessErrorAdminUnlink.
  ///
  /// In es, this message translates to:
  /// **'No puedes desvincular al administrador'**
  String get userAccessErrorAdminUnlink;

  /// No description provided for @userAccessErrorSelectUsers.
  ///
  /// In es, this message translates to:
  /// **'Selecciona al menos un usuario'**
  String get userAccessErrorSelectUsers;

  /// No description provided for @userAccessUnlinkDialogTitle.
  ///
  /// In es, this message translates to:
  /// **'Desvincular Usuario'**
  String get userAccessUnlinkDialogTitle;

  /// No description provided for @userAccessUnlinkDialogContent.
  ///
  /// In es, this message translates to:
  /// **'¿Deseas desvincular a {name}?'**
  String userAccessUnlinkDialogContent(Object name);

  /// No description provided for @userAccessCancelButton.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get userAccessCancelButton;

  /// No description provided for @userAccessUnlinkButton.
  ///
  /// In es, this message translates to:
  /// **'Desvincular'**
  String get userAccessUnlinkButton;

  /// No description provided for @userAccessSuccessUnlinked.
  ///
  /// In es, this message translates to:
  /// **'{name} desvinculado'**
  String userAccessSuccessUnlinked(Object name);

  /// No description provided for @userAccessSuccessLinked.
  ///
  /// In es, this message translates to:
  /// **'{count} usuario(s) vinculado(s) exitosamente'**
  String userAccessSuccessLinked(Object count);

  /// No description provided for @userAccessEditInfo.
  ///
  /// In es, this message translates to:
  /// **'Editar {name} - Próximamente'**
  String userAccessEditInfo(Object name);

  /// No description provided for @userAccessLinkButtonSingle.
  ///
  /// In es, this message translates to:
  /// **'Vincular Usuario Existente ({count})'**
  String userAccessLinkButtonSingle(Object count);

  /// No description provided for @userAccessLinkButtonPlural.
  ///
  /// In es, this message translates to:
  /// **'Vincular Usuarios Existentes ({count})'**
  String userAccessLinkButtonPlural(Object count);

  /// No description provided for @userRolesTitle.
  ///
  /// In es, this message translates to:
  /// **'Roles de usuario\nen dispositivo'**
  String get userRolesTitle;

  /// No description provided for @userRolesDeviceLabel.
  ///
  /// In es, this message translates to:
  /// **'Dispositivo:'**
  String get userRolesDeviceLabel;

  /// No description provided for @userRolesModelLabel.
  ///
  /// In es, this message translates to:
  /// **'Mod:'**
  String get userRolesModelLabel;

  /// No description provided for @userRolesSerialLabel.
  ///
  /// In es, this message translates to:
  /// **'No. Serie:'**
  String get userRolesSerialLabel;

  /// No description provided for @userRolesStatusLabel.
  ///
  /// In es, this message translates to:
  /// **'Estado:'**
  String get userRolesStatusLabel;

  /// No description provided for @userRolesDetailLabel.
  ///
  /// In es, this message translates to:
  /// **'Detalle:'**
  String get userRolesDetailLabel;

  /// No description provided for @userRolesSelectedUserLabel.
  ///
  /// In es, this message translates to:
  /// **'Usuario Seleccionado'**
  String get userRolesSelectedUserLabel;

  /// No description provided for @userRolesEmailLabel.
  ///
  /// In es, this message translates to:
  /// **'Correo'**
  String get userRolesEmailLabel;

  /// No description provided for @userRolesNewUserDefault.
  ///
  /// In es, this message translates to:
  /// **'Usuario Nuevo'**
  String get userRolesNewUserDefault;

  /// No description provided for @userRolesPermissionsTitle.
  ///
  /// In es, this message translates to:
  /// **'Permisos y Roles'**
  String get userRolesPermissionsTitle;

  /// No description provided for @userRolesAssignButton.
  ///
  /// In es, this message translates to:
  /// **'Asignar Roles'**
  String get userRolesAssignButton;

  /// No description provided for @userRolesPermissionOpen.
  ///
  /// In es, this message translates to:
  /// **'Abrir'**
  String get userRolesPermissionOpen;

  /// No description provided for @userRolesPermissionClose.
  ///
  /// In es, this message translates to:
  /// **'Cerrar'**
  String get userRolesPermissionClose;

  /// No description provided for @userRolesPermissionPause.
  ///
  /// In es, this message translates to:
  /// **'Parar/Pausa'**
  String get userRolesPermissionPause;

  /// No description provided for @userRolesPermissionPedestrian.
  ///
  /// In es, this message translates to:
  /// **'Peatonal'**
  String get userRolesPermissionPedestrian;

  /// No description provided for @userRolesPermissionLock.
  ///
  /// In es, this message translates to:
  /// **'Bloquear'**
  String get userRolesPermissionLock;

  /// No description provided for @userRolesPermissionLight.
  ///
  /// In es, this message translates to:
  /// **'Lámpara'**
  String get userRolesPermissionLight;

  /// No description provided for @userRolesPermissionSwitch.
  ///
  /// In es, this message translates to:
  /// **'Relé/Switch'**
  String get userRolesPermissionSwitch;

  /// No description provided for @userRolesPermissionControlPanel.
  ///
  /// In es, this message translates to:
  /// **'Panel Control'**
  String get userRolesPermissionControlPanel;

  /// No description provided for @userRolesPermissionReports.
  ///
  /// In es, this message translates to:
  /// **'Reportes'**
  String get userRolesPermissionReports;

  /// No description provided for @userRolesPermissionViewContact.
  ///
  /// In es, this message translates to:
  /// **'Ver Contacto'**
  String get userRolesPermissionViewContact;

  /// No description provided for @userRolesPermissionViewParams.
  ///
  /// In es, this message translates to:
  /// **'Ver Parámetros'**
  String get userRolesPermissionViewParams;

  /// No description provided for @userRolesPermissionEditDevice.
  ///
  /// In es, this message translates to:
  /// **'Editar Disp.'**
  String get userRolesPermissionEditDevice;

  /// No description provided for @userRolesPermissionAssignUsers.
  ///
  /// In es, this message translates to:
  /// **'Asignar usuarios'**
  String get userRolesPermissionAssignUsers;

  /// No description provided for @userRolesErrorNoPermissions.
  ///
  /// In es, this message translates to:
  /// **'Selecciona al menos un permiso'**
  String get userRolesErrorNoPermissions;

  /// No description provided for @userRolesSuccessAssigned.
  ///
  /// In es, this message translates to:
  /// **'Roles asignados y usuario vinculado exitosamente'**
  String get userRolesSuccessAssigned;

  /// No description provided for @userRolesErrorUnknownDevice.
  ///
  /// In es, this message translates to:
  /// **'No se pudo vincular: Dispositivo desconocido'**
  String get userRolesErrorUnknownDevice;

  /// No description provided for @deviceFormGallery.
  ///
  /// In es, this message translates to:
  /// **'Galería'**
  String get deviceFormGallery;

  /// No description provided for @deviceFormCamera.
  ///
  /// In es, this message translates to:
  /// **'Cámara'**
  String get deviceFormCamera;

  /// No description provided for @deviceFormDeletePhoto.
  ///
  /// In es, this message translates to:
  /// **'Eliminar Foto'**
  String get deviceFormDeletePhoto;

  /// No description provided for @deviceFormDeleteDevice.
  ///
  /// In es, this message translates to:
  /// **'Eliminar Dispositivo'**
  String get deviceFormDeleteDevice;

  /// No description provided for @generalDelete.
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get generalDelete;

  /// No description provided for @deviceFormDeleteConfirmMessage.
  ///
  /// In es, this message translates to:
  /// **'¿Estás seguro de que deseas eliminar este dispositivo y todos sus datos asociados? Esta acción no se puede deshacer.'**
  String get deviceFormDeleteConfirmMessage;

  /// No description provided for @deviceFormSelectImage.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar Imagen'**
  String get deviceFormSelectImage;

  /// No description provided for @deviceFormTakePhoto.
  ///
  /// In es, this message translates to:
  /// **'Tomar Foto'**
  String get deviceFormTakePhoto;

  /// No description provided for @deviceFormImageLoadedSuccess.
  ///
  /// In es, this message translates to:
  /// **'Imagen cargada correctamente'**
  String get deviceFormImageLoadedSuccess;

  /// No description provided for @deviceFormImageLoadError.
  ///
  /// In es, this message translates to:
  /// **'Error al cargar imagen: {error}'**
  String deviceFormImageLoadError(String error);

  /// No description provided for @deviceFormDeletedSuccess.
  ///
  /// In es, this message translates to:
  /// **'Dispositivo eliminado correctamente'**
  String get deviceFormDeletedSuccess;

  /// Título de la pantalla de emparejamiento BLE
  ///
  /// In es, this message translates to:
  /// **'Emparejamiento BLE'**
  String get blePairingTitle;

  /// No description provided for @bleScanStepTitle.
  ///
  /// In es, this message translates to:
  /// **'Escanear dispositivos'**
  String get bleScanStepTitle;

  /// No description provided for @bleScanStepDescription.
  ///
  /// In es, this message translates to:
  /// **'Busca dispositivos VITA cercanos. Asegúrate que el dispositivo esté en modo emparejamiento (LED azul parpadeando).'**
  String get bleScanStepDescription;

  /// No description provided for @bleScanButtonStart.
  ///
  /// In es, this message translates to:
  /// **'Iniciar escaneo'**
  String get bleScanButtonStart;

  /// No description provided for @bleScanningText.
  ///
  /// In es, this message translates to:
  /// **'Escaneando dispositivos...'**
  String get bleScanningText;

  /// No description provided for @bleDeviceListStepTitle.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar dispositivo'**
  String get bleDeviceListStepTitle;

  /// No description provided for @bleDeviceListFound.
  ///
  /// In es, this message translates to:
  /// **'Se encontraron {count} dispositivos'**
  String bleDeviceListFound(int count);

  /// No description provided for @bleConnectionStepTitle.
  ///
  /// In es, this message translates to:
  /// **'Conectando'**
  String get bleConnectionStepTitle;

  /// No description provided for @bleConnectingText.
  ///
  /// In es, this message translates to:
  /// **'Conectando al dispositivo...'**
  String get bleConnectingText;

  /// No description provided for @bleDeviceInfoTitle.
  ///
  /// In es, this message translates to:
  /// **'Información del dispositivo'**
  String get bleDeviceInfoTitle;

  /// No description provided for @bleConfigureButton.
  ///
  /// In es, this message translates to:
  /// **'Configurar'**
  String get bleConfigureButton;

  /// No description provided for @bleConfigStepTitle.
  ///
  /// In es, this message translates to:
  /// **'Configuración'**
  String get bleConfigStepTitle;

  /// No description provided for @bleConfigStepDescription.
  ///
  /// In es, this message translates to:
  /// **'Configura los datos iniciales de tu dispositivo VITA.'**
  String get bleConfigStepDescription;

  /// No description provided for @bleConfigDeviceNameLabel.
  ///
  /// In es, this message translates to:
  /// **'Nombre del dispositivo'**
  String get bleConfigDeviceNameLabel;

  /// No description provided for @bleConfigDeviceNameHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: Portón Principal'**
  String get bleConfigDeviceNameHint;

  /// No description provided for @bleConfigLocationLabel.
  ///
  /// In es, this message translates to:
  /// **'Ubicación'**
  String get bleConfigLocationLabel;

  /// No description provided for @bleConfigLocationHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: Entrada principal'**
  String get bleConfigLocationHint;

  /// No description provided for @bleConfigDescriptionLabel.
  ///
  /// In es, this message translates to:
  /// **'Descripción'**
  String get bleConfigDescriptionLabel;

  /// No description provided for @bleConfigDescriptionHint.
  ///
  /// In es, this message translates to:
  /// **'Descripción adicional (opcional)'**
  String get bleConfigDescriptionHint;

  /// No description provided for @bleConfigDeviceTypeLabel.
  ///
  /// In es, this message translates to:
  /// **'Tipo de dispositivo'**
  String get bleConfigDeviceTypeLabel;

  /// No description provided for @bleConfigTypeGate.
  ///
  /// In es, this message translates to:
  /// **'Portón'**
  String get bleConfigTypeGate;

  /// No description provided for @bleConfigTypeDoor.
  ///
  /// In es, this message translates to:
  /// **'Puerta'**
  String get bleConfigTypeDoor;

  /// No description provided for @bleConfigTypeBarrier.
  ///
  /// In es, this message translates to:
  /// **'Barrera'**
  String get bleConfigTypeBarrier;

  /// No description provided for @bleConfigSaveButton.
  ///
  /// In es, this message translates to:
  /// **'Guardar configuración'**
  String get bleConfigSaveButton;

  /// No description provided for @bleConfigDeviceNameRequired.
  ///
  /// In es, this message translates to:
  /// **'El nombre del dispositivo es requerido'**
  String get bleConfigDeviceNameRequired;

  /// No description provided for @bleConfiguringText.
  ///
  /// In es, this message translates to:
  /// **'Configurando dispositivo...'**
  String get bleConfiguringText;

  /// No description provided for @bleSuccessStepTitle.
  ///
  /// In es, this message translates to:
  /// **'Completado'**
  String get bleSuccessStepTitle;

  /// No description provided for @bleSuccessMessage.
  ///
  /// In es, this message translates to:
  /// **'¡Dispositivo emparejado exitosamente!'**
  String get bleSuccessMessage;

  /// No description provided for @bleSuccessDeviceConfigured.
  ///
  /// In es, this message translates to:
  /// **'El dispositivo \'{deviceName}\' ha sido configurado correctamente.'**
  String bleSuccessDeviceConfigured(String deviceName);

  /// No description provided for @bleSuccessGoToDevices.
  ///
  /// In es, this message translates to:
  /// **'Ir a mis dispositivos'**
  String get bleSuccessGoToDevices;

  /// No description provided for @bleInfoSerial.
  ///
  /// In es, this message translates to:
  /// **'N° Serie'**
  String get bleInfoSerial;

  /// No description provided for @bleInfoFirmware.
  ///
  /// In es, this message translates to:
  /// **'Firmware'**
  String get bleInfoFirmware;

  /// No description provided for @bleInfoModel.
  ///
  /// In es, this message translates to:
  /// **'Modelo'**
  String get bleInfoModel;

  /// No description provided for @bleInfoMotor.
  ///
  /// In es, this message translates to:
  /// **'Motor'**
  String get bleInfoMotor;

  /// No description provided for @bleErrorGeneric.
  ///
  /// In es, this message translates to:
  /// **'Error durante el proceso de emparejamiento'**
  String get bleErrorGeneric;

  /// Título de la pantalla de notificaciones
  ///
  /// In es, this message translates to:
  /// **'Notificaciones'**
  String get notificationsTitle;

  /// Texto del botón para marcar todas las notificaciones como leídas
  ///
  /// In es, this message translates to:
  /// **'Marcar todas como leídas'**
  String get markAllAsRead;

  /// Mensaje cuando no hay notificaciones
  ///
  /// In es, this message translates to:
  /// **'No hay notificaciones'**
  String get noNotifications;

  /// Texto para mostrar tiempo transcurrido en minutos
  ///
  /// In es, this message translates to:
  /// **'hace {minutes}m'**
  String minutesAgo(String minutes);

  /// Texto para mostrar tiempo transcurrido en horas
  ///
  /// In es, this message translates to:
  /// **'hace {hours}h'**
  String hoursAgo(String hours);

  /// Texto para mostrar tiempo transcurrido en días
  ///
  /// In es, this message translates to:
  /// **'hace {days}d'**
  String daysAgo(String days);

  /// Texto para mostrar que algo pasó hace muy poco
  ///
  /// In es, this message translates to:
  /// **'Ahora'**
  String get justNow;

  /// Texto para notificación de dispositivo desconectado
  ///
  /// In es, this message translates to:
  /// **'Dispositivo desconectado'**
  String get deviceOffline;

  /// Texto para notificación de dispositivo conectado
  ///
  /// In es, this message translates to:
  /// **'Dispositivo conectado'**
  String get deviceOnline;

  /// Texto para notificación de acción ejecutada
  ///
  /// In es, this message translates to:
  /// **'Acción ejecutada'**
  String get actionExecuted;

  /// Texto para notificación de cambio de estado
  ///
  /// In es, this message translates to:
  /// **'Cambio de estado'**
  String get statusChange;

  /// Título de la pantalla de preferencias de notificaciones
  ///
  /// In es, this message translates to:
  /// **'Preferencias de Notificaciones'**
  String get notificationPreferences;

  /// Descripción de la pantalla de preferencias de notificaciones
  ///
  /// In es, this message translates to:
  /// **'Configura qué notificaciones quieres recibir para cada dispositivo'**
  String get notificationPreferencesDescription;

  /// Título de la sección de tipos de notificación
  ///
  /// In es, this message translates to:
  /// **'Tipos de notificación'**
  String get notificationTypes;

  /// Opción para notificar cuando se ejecutan acciones
  ///
  /// In es, this message translates to:
  /// **'Notificar acciones'**
  String get notifyActions;

  /// Descripción de la opción de notificar acciones
  ///
  /// In es, this message translates to:
  /// **'Cuando alguien opera el dispositivo'**
  String get notifyActionsDescription;

  /// Opción para notificar cuando el dispositivo se desconecta
  ///
  /// In es, this message translates to:
  /// **'Notificar desconexión'**
  String get notifyOffline;

  /// Descripción de la opción de notificar desconexión
  ///
  /// In es, this message translates to:
  /// **'Cuando el dispositivo se desconecta'**
  String get notifyOfflineDescription;

  /// Opción para notificar cambios de estado del motor
  ///
  /// In es, this message translates to:
  /// **'Notificar cambios de estado'**
  String get notifyStatusChange;

  /// Descripción de la opción de notificar cambios de estado
  ///
  /// In es, this message translates to:
  /// **'Cuando cambia el estado del motor'**
  String get notifyStatusChangeDescription;

  /// Texto del botón para reintentar una operación
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get retry;

  /// Label for activation date field
  ///
  /// In es, this message translates to:
  /// **'Fecha de activación'**
  String get activationDateLabel;

  /// Label for favorite device switch
  ///
  /// In es, this message translates to:
  /// **'Dispositivo Favorito'**
  String get favoriteDeviceLabel;

  /// Placeholder text for date selection
  ///
  /// In es, this message translates to:
  /// **'Seleccionar fecha'**
  String get selectDatePlaceholder;

  /// Text for change photo button
  ///
  /// In es, this message translates to:
  /// **'Cambiar'**
  String get changePhotoButton;

  /// Text for delete device button
  ///
  /// In es, this message translates to:
  /// **'Eliminar Dispositivo'**
  String get deleteDeviceButton;

  /// Placeholder for serial number input
  ///
  /// In es, this message translates to:
  /// **'SN...'**
  String get serialNumberPlaceholder;

  /// Default search placeholder text
  ///
  /// In es, this message translates to:
  /// **'Buscar...'**
  String get searchPlaceholder;

  /// Default confirm button text
  ///
  /// In es, this message translates to:
  /// **'Confirmar'**
  String get confirmDefault;

  /// Default cancel button text
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get cancelDefault;

  /// Error message when group is not found
  ///
  /// In es, this message translates to:
  /// **'Grupo no encontrado'**
  String get groupNotFound;

  /// Error message when trying to add devices to ALL group manually
  ///
  /// In es, this message translates to:
  /// **'No se pueden agregar dispositivos al grupo TODOS manualmente'**
  String get cannotAddToAllGroup;

  /// Error message when device is already in the group
  ///
  /// In es, this message translates to:
  /// **'El dispositivo ya está en el grupo'**
  String get deviceAlreadyInGroup;

  /// Error message when trying to remove devices from ALL group
  ///
  /// In es, this message translates to:
  /// **'No se pueden eliminar dispositivos del grupo TODOS'**
  String get cannotRemoveFromAllGroup;

  /// Error message when device is not in the group
  ///
  /// In es, this message translates to:
  /// **'El dispositivo no está en el grupo'**
  String get deviceNotInGroup;

  /// Error message when name field is empty
  ///
  /// In es, this message translates to:
  /// **'El nombre no puede estar vacío'**
  String get nameCannotBeEmpty;

  /// Error message when group name already exists
  ///
  /// In es, this message translates to:
  /// **'Ya existe un grupo con este nombre'**
  String get groupNameAlreadyExists;

  /// Error message when trying to modify ALL group
  ///
  /// In es, this message translates to:
  /// **'No se puede modificar el grupo TODOS'**
  String get cannotModifyAllGroup;

  /// Error message when trying to delete ALL group
  ///
  /// In es, this message translates to:
  /// **'No se puede eliminar el grupo TODOS'**
  String get cannotDeleteAllGroup;

  /// Label for power type field
  ///
  /// In es, this message translates to:
  /// **'Tipo Corriente'**
  String get powerTypeLabel;

  /// Label for motor type field
  ///
  /// In es, this message translates to:
  /// **'Tipo Motor'**
  String get motorTypeLabel;

  /// Generic select placeholder text
  ///
  /// In es, this message translates to:
  /// **'Seleccionar'**
  String get selectPlaceholder;

  /// Label for opening photocell switch
  ///
  /// In es, this message translates to:
  /// **'Fotocélula Apertura'**
  String get openingPhotocellLabel;

  /// Label for closing photocell switch
  ///
  /// In es, this message translates to:
  /// **'Fotocélula Cierre'**
  String get closingPhotocellLabel;

  /// Label for installation date
  ///
  /// In es, this message translates to:
  /// **'Fecha de Instalación'**
  String get installationDateLabel;

  /// Label for warranty expiration date
  ///
  /// In es, this message translates to:
  /// **'Vencimiento Garantía'**
  String get warrantyExpirationLabel;

  /// Label for scheduled maintenance date
  ///
  /// In es, this message translates to:
  /// **'Mantenimiento Programado'**
  String get scheduledMaintenanceLabel;

  /// Placeholder for technician name field
  ///
  /// In es, this message translates to:
  /// **'Nombre del técnico...'**
  String get technicianNamePlaceholder;

  /// Label for technical contact field
  ///
  /// In es, this message translates to:
  /// **'Contacto Técnico'**
  String get technicalContactLabel;

  /// Placeholder for additional notes field
  ///
  /// In es, this message translates to:
  /// **'Notas adicionales...'**
  String get additionalNotesPlaceholder;

  /// Label for maintenance notes field
  ///
  /// In es, this message translates to:
  /// **'Notas de Mantenimiento'**
  String get maintenanceNotesLabel;

  /// No description provided for @deviceOnlineStatus.
  ///
  /// In es, this message translates to:
  /// **'En línea'**
  String get deviceOnlineStatus;

  /// No description provided for @deviceOfflineStatus.
  ///
  /// In es, this message translates to:
  /// **'Sin conexión'**
  String get deviceOfflineStatus;

  /// No description provided for @deviceImageLabel.
  ///
  /// In es, this message translates to:
  /// **'Imagen del portón del dispositivo'**
  String get deviceImageLabel;

  /// No description provided for @mainGateLabel.
  ///
  /// In es, this message translates to:
  /// **'Portón Principal'**
  String get mainGateLabel;

  /// No description provided for @garageGateLabel.
  ///
  /// In es, this message translates to:
  /// **'Portón Cochera'**
  String get garageGateLabel;

  /// No description provided for @controlsButtonOpen.
  ///
  /// In es, this message translates to:
  /// **'Abrir'**
  String get controlsButtonOpen;

  /// No description provided for @controlsButtonPause.
  ///
  /// In es, this message translates to:
  /// **'Pausa'**
  String get controlsButtonPause;

  /// No description provided for @controlsButtonClose.
  ///
  /// In es, this message translates to:
  /// **'Cerrar'**
  String get controlsButtonClose;

  /// No description provided for @controlsButtonPedestrian.
  ///
  /// In es, this message translates to:
  /// **'Peatonal'**
  String get controlsButtonPedestrian;

  /// No description provided for @modelLabel.
  ///
  /// In es, this message translates to:
  /// **'Modelo:'**
  String get modelLabel;

  /// No description provided for @serialNumberLabel.
  ///
  /// In es, this message translates to:
  /// **'No. Serie:'**
  String get serialNumberLabel;

  /// No description provided for @detailLabel.
  ///
  /// In es, this message translates to:
  /// **'Detalle'**
  String get detailLabel;

  /// No description provided for @notificationTooltip.
  ///
  /// In es, this message translates to:
  /// **'Notificaciones'**
  String get notificationTooltip;

  /// No description provided for @retryButton.
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get retryButton;

  /// No description provided for @editButton.
  ///
  /// In es, this message translates to:
  /// **'Editar'**
  String get editButton;

  /// No description provided for @showPasswordButton.
  ///
  /// In es, this message translates to:
  /// **'Mostrar'**
  String get showPasswordButton;

  /// No description provided for @hidePasswordButton.
  ///
  /// In es, this message translates to:
  /// **'Ocultar'**
  String get hidePasswordButton;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
