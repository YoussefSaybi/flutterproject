import 'locale_controller.dart';

/// Multi-language string catalog driven by [LocaleController].
class AppStrings {
  AppStrings._(this._code);

  final String _code;

  static AppStrings get current =>
      AppStrings._(LocaleController.instance.code);

  String _t({
    required String fr,
    required String en,
    required String ar,
    required String es,
    required String de,
    required String pt,
    required String tr,
  }) {
    switch (_code) {
      case 'EN':
        return en;
      case 'AR':
        return ar;
      case 'ES':
        return es;
      case 'DE':
        return de;
      case 'PT':
        return pt;
      case 'TR':
        return tr;
      default:
        return fr;
    }
  }

  // ── Settings ──
  String get settings => _t(
        fr: 'Paramètres',
        en: 'Settings',
        ar: 'الإعدادات',
        es: 'Ajustes',
        de: 'Einstellungen',
        pt: 'Definições',
        tr: 'Ayarlar',
      );
  String get settingsSubtitle => _t(
        fr: 'Choisissez la langue de l’application.',
        en: 'Choose the application language.',
        ar: 'اختر لغة التطبيق.',
        es: 'Elige el idioma de la aplicación.',
        de: 'Wählen Sie die Sprache der App.',
        pt: 'Escolha o idioma da aplicação.',
        tr: 'Uygulama dilini seçin.',
      );
  String get language => _t(
        fr: 'Langue',
        en: 'Language',
        ar: 'اللغة',
        es: 'Idioma',
        de: 'Sprache',
        pt: 'Idioma',
        tr: 'Dil',
      );
  String get languageFrench => _t(
        fr: 'Français',
        en: 'French',
        ar: 'الفرنسية',
        es: 'Francés',
        de: 'Französisch',
        pt: 'Francês',
        tr: 'Fransızca',
      );
  String get languageEnglish => _t(
        fr: 'Anglais',
        en: 'English',
        ar: 'الإنجليزية',
        es: 'Inglés',
        de: 'Englisch',
        pt: 'Inglês',
        tr: 'İngilizce',
      );
  String get languageArabic => _t(
        fr: 'Arabe',
        en: 'Arabic',
        ar: 'العربية',
        es: 'Árabe',
        de: 'Arabisch',
        pt: 'Árabe',
        tr: 'Arapça',
      );
  String get languageSpanish => _t(
        fr: 'Espagnol',
        en: 'Spanish',
        ar: 'الإسبانية',
        es: 'Español',
        de: 'Spanisch',
        pt: 'Espanhol',
        tr: 'İspanyolca',
      );
  String get languageGerman => _t(
        fr: 'Allemand',
        en: 'German',
        ar: 'الألمانية',
        es: 'Alemán',
        de: 'Deutsch',
        pt: 'Alemão',
        tr: 'Almanca',
      );
  String get languagePortuguese => _t(
        fr: 'Portugais',
        en: 'Portuguese',
        ar: 'البرتغالية',
        es: 'Portugués',
        de: 'Portugiesisch',
        pt: 'Português',
        tr: 'Portekizce',
      );
  String get languageTurkish => _t(
        fr: 'Turc',
        en: 'Turkish',
        ar: 'التركية',
        es: 'Turco',
        de: 'Türkisch',
        pt: 'Turco',
        tr: 'Türkçe',
      );
  String get languageSelected => _t(
        fr: 'Langue mise à jour.',
        en: 'Language updated.',
        ar: 'تم تحديث اللغة.',
        es: 'Idioma actualizado.',
        de: 'Sprache aktualisiert.',
        pt: 'Idioma atualizado.',
        tr: 'Dil güncellendi.',
      );

  // ── Profile ──
  String get myProfile => _t(
        fr: 'Mon profil',
        en: 'My profile',
        ar: 'ملفي الشخصي',
        es: 'Mi perfil',
        de: 'Mein Profil',
        pt: 'O meu perfil',
        tr: 'Profilim',
      );
  String get placesVisited => _t(
        fr: 'Lieux visités',
        en: 'Places visited',
        ar: 'أماكن تمت زيارتها',
        es: 'Lugares visitados',
        de: 'Besuchte Orte',
        pt: 'Locais visitados',
        tr: 'Ziyaret edilen yerler',
      );
  String get parcours => _t(
        fr: 'Parcours',
        en: 'Routes',
        ar: 'المسارات',
        es: 'Recorridos',
        de: 'Routen',
        pt: 'Percursos',
        tr: 'Rotalar',
      );
  String get favorites => _t(
        fr: 'Favoris',
        en: 'Favorites',
        ar: 'المفضلة',
        es: 'Favoritos',
        de: 'Favoriten',
        pt: 'Favoritos',
        tr: 'Favoriler',
      );
  String get myFavorites => _t(
        fr: 'Mes favoris',
        en: 'My favorites',
        ar: 'مفضلاتي',
        es: 'Mis favoritos',
        de: 'Meine Favoriten',
        pt: 'Os meus favoritos',
        tr: 'Favorilerim',
      );
  String get myParcours => _t(
        fr: 'Mes parcours',
        en: 'My routes',
        ar: 'مساراتي',
        es: 'Mis recorridos',
        de: 'Meine Routen',
        pt: 'Os meus percursos',
        tr: 'Rotalarım',
      );
  String get myDownloads => _t(
        fr: 'Mes téléchargements',
        en: 'My downloads',
        ar: 'تنزيلاتي',
        es: 'Mis descargas',
        de: 'Meine Downloads',
        pt: 'As minhas transferências',
        tr: 'İndirmelerim',
      );
  String get helpSupport => _t(
        fr: 'Aide & support',
        en: 'Help & support',
        ar: 'المساعدة والدعم',
        es: 'Ayuda y soporte',
        de: 'Hilfe & Support',
        pt: 'Ajuda e suporte',
        tr: 'Yardım ve destek',
      );
  String get downloadsSoon => _t(
        fr: 'Téléchargements — bientôt disponible.',
        en: 'Downloads — coming soon.',
        ar: 'التنزيلات — قريباً.',
        es: 'Descargas — próximamente.',
        de: 'Downloads — demnächst verfügbar.',
        pt: 'Transferências — em breve.',
        tr: 'İndirmeler — yakında.',
      );
  String get helpSoon => _t(
        fr: 'Aide & support — bientôt disponible.',
        en: 'Help & support — coming soon.',
        ar: 'المساعدة والدعم — قريباً.',
        es: 'Ayuda y soporte — próximamente.',
        de: 'Hilfe & Support — demnächst verfügbar.',
        pt: 'Ajuda e suporte — em breve.',
        tr: 'Yardım ve destek — yakında.',
      );

  // ── Common ──
  String get back => _t(
        fr: 'Retour',
        en: 'Back',
        ar: 'رجوع',
        es: 'Volver',
        de: 'Zurück',
        pt: 'Voltar',
        tr: 'Geri',
      );
}
