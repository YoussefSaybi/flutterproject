/// Paths for EcoAR_Regenerated_Asset_Pack (widgets use these — not full-screen UI JPGs).
class AppAssets {
  // Logos (shared everywhere — splash, headers, about)
  static const logo = 'assets/logos/EcoAR_Kerkennah_Logo_4K.png';
  static const logoAlt = 'assets/logos/logo.png';
  static const logoGold = 'assets/logos/EcoAR_Kerkennah_Logo_gold.png';
  static const logoMelies = 'assets/logos/melies_logo_gold.png';

  // Institutional partners + studio (credits screen — original colors)
  static const logoAmbassade = 'assets/partners/ambassade_france_tunisie.png';
  static const logoInstitutFrancais =
      'assets/partners/institut_francais_tunisie.png';
  static const logoSawn = 'assets/partners/sawn.png';
  static const logoMeliesProduction =
      'assets/partners/melies_production_technologies.jpg';

  /// Aide & support page — full lockups (user-provided).
  static const helpLogoAmbassade = 'assets/partners/help_ambassade.png';
  static const helpLogoIft = 'assets/partners/help_ift.png';
  static const helpLogoSawn = 'assets/partners/help_sawn.png';
  static const helpLogoMelies = 'assets/partners/help_melies.png';

  // Compressed photo backgrounds (keeps APK installable on emulator)
  /// CEO splash — rocky cove + marabout (not village_hero / boat quay).
  static const bgSplash = 'assets/bg/splash_cove.jpg';
  static const bgCoast = 'assets/bg/coast.jpg';
  static const bgVillage = 'assets/bg/village.jpg';
  static const bgBoat = 'assets/bg/boat.jpg';
  /// AR light — Charfiya traditionnelle full-bleed scene.
  static const bgCharfiya = 'assets/bg/charfiya_traditionnelle.jpg';
  /// Parcours step — Abbassiya marabout on the coast.
  static const bgAbbassiya = 'assets/bg/abbassiya.jpg';
  /// Home recommended card — coastal village + boat (CEO mock).
  static const bgParcoursMemoire = 'assets/bg/parcours_memoire_maritime.jpg';
  /// Onboarding page 1 — CEO mock coastal boat (user-provided).
  static const bgOnboardingBoat = 'assets/bg/onboarding_boat.jpg';
  /// Onboarding page 2 — alley + QR plaque (user-provided).
  static const bgOnboardingScan = 'assets/bg/onboarding_scan.jpg';
  /// Onboarding page 3 — harbor boats (user-provided).
  static const bgOnboardingHarbor = 'assets/bg/onboarding_harbor.jpg';
  /// Login hero — coastal boats (CEO mock).
  static const bgLoginHero = 'assets/bg/login_hero.jpg';
  /// Signup hero — single full-bleed coastal scene (no user photo stack).
  static const bgSignupHero = 'assets/images/bg_signup_hero.jpg';
  /// Forgot password — dedicated coastal hero.
  static const bgForgotPassword = 'assets/bg/forgot_password_hero.jpg';
  /// Profile header — teal with palm shadow (user asset).
  static const bgProfileHeader = 'assets/bg/profile_header.jpg';
  /// Scanner — QR plaque on stone pillar (coastal alley).
  static const bgScanner = 'assets/bg/scanner_qr_plaque.jpg';
  /// Splash / loading alternate full-screen ocean.
  static const bgOceanFull = 'assets/images/bg_ocean_full.jpg';
  static const bgKerkennahHero = bgSignupHero;
  static const bgMap = 'assets/bg/kerkennah_islands_map.jpg';
  /// Legacy photo (not the islands map).
  static const bgMapPhoto = 'assets/bg/map.jpg';
  static const bgFisherman = 'assets/bg/fisherman.jpg';
  static const bg06 = 'assets/bg/06_placeholder.jpg';
  static const bg07 = 'assets/bg/07_placeholder.jpg';
  static const bg08 = 'assets/bg/08_placeholder.jpg';
  static const bg09 = 'assets/bg/09_placeholder.jpg';
  static const bg10 = 'assets/bg/10_placeholder.jpg';
  static const bg11 = 'assets/bg/11_placeholder.jpg';
  static const bg12 = 'assets/bg/12_placeholder.jpg';

  static const heroCoast = bgCoast;
  static const heroSplash = bgSplash;
  static const heroVillage = bgVillage;
  static const heroBoat = bgBoat;
  static const heroMap = bgMap;
  static const heroFisherman = bgFisherman;

  // Component paths unused at runtime (widgets preferred); kept as aliases to icons
  static const searchBar = iconSearch;
  static const profileHeader = iconProfile;
  static const parcoursCard = bgParcoursMemoire;
  static const audioPlayer = iconPlay;
  static const mapControls = iconNav;
  static const bottomNav = iconHome;
  static const primaryButton = iconHome;
  static const languageToggle = iconHome;
  static const categoryPills = iconHome;
  static const discoveryCard = bgVillage;
  static const listItem = bgCoast;
  static const scannerFrame = iconScanner;
  static const socialGoogle = 'assets/icons/google_g.png';
  static const socialApple = iconHome;
  static const passwordField = iconHome;
  static const nameField = iconHome;

  // Bottom nav — custom line icons (teal inactive / gold active, label baked in)
  static const navAccueil = 'assets/icons/nav/accueil_inactive.png';
  static const navAccueilActive = 'assets/icons/nav/accueil_active.png';
  static const navCarte = 'assets/icons/nav/carte_inactive.png';
  static const navCarteActive = 'assets/icons/nav/carte_active.png';
  static const navParcours = 'assets/icons/nav/parcours_inactive.png';
  static const navParcoursActive = 'assets/icons/nav/parcours_active.png';
  static const navScanner = 'assets/icons/nav/scanner_inactive.png';
  static const navScannerActive = 'assets/icons/nav/scanner_active.png';
  static const navProfil = 'assets/icons/nav/profil_inactive.png';
  static const navProfilActive = 'assets/icons/nav/profil_active.png';

  // Nav / UI icons
  static const iconHome = 'assets/icons/01_icon.png';
  static const iconHomeActive = 'assets/icons/02_icon.png';
  static const iconMap = 'assets/icons/03_icon.png';
  static const iconMapActive = 'assets/icons/04_icon.png';
  static const iconParcours = 'assets/icons/05_icon.png';
  static const iconParcoursActive = 'assets/icons/06_icon.png';
  static const iconScanner = 'assets/icons/07_icon.png';
  static const iconScannerActive = 'assets/icons/08_icon.png';
  static const iconQr = 'assets/icons/09_icon.png';
  static const iconProfile = 'assets/icons/10_icon.png';
  static const iconProfileActive = 'assets/icons/11_icon.png';
  static const iconBack = 'assets/icons/12_icon.png';
  static const iconClose = 'assets/icons/13_icon.png';
  static const iconMenu = 'assets/icons/14_icon.png';
  static const iconMenuGold = 'assets/icons/15_icon.png';
  static const iconBookmark = 'assets/icons/16_icon.png';
  static const iconBookmarkActive = 'assets/icons/17_icon.png';
  static const iconSearch = 'assets/icons/18_icon.png';
  static const iconSearchActive = 'assets/icons/19_icon.png';
  static const iconFilter = 'assets/icons/20_icon.png';
  static const iconFilterGold = 'assets/icons/21_icon.png';
  static const iconPin = 'assets/icons/22_icon.png';
  static const iconPinGold = 'assets/icons/23_icon.png';
  static const iconPlus = 'assets/icons/24_icon.png';
  static const iconMinus = 'assets/icons/25_icon.png';
  static const iconNav = 'assets/icons/26_icon.png';
  static const iconPlay = 'assets/icons/27_icon.png';
  static const iconPause = 'assets/icons/28_icon.png';
  static const iconSkipBack = 'assets/icons/29_icon.png';
  static const iconSkipForward = 'assets/icons/30_icon.png';
  static const iconDownload = 'assets/icons/31_icon.png';
  static const iconHelp = 'assets/icons/32_icon.png';
  static const iconSettings = 'assets/icons/33_icon.png';
  static const iconHeart = 'assets/icons/34_icon.png';
  static const iconHeartActive = 'assets/icons/35_icon.png';
  static const iconShare = 'assets/icons/36_icon.png';
  static const iconAnchor = 'assets/icons/37_icon.png';
  static const iconAnchorGold = 'assets/icons/38_icon.png';
  static const iconBoat = 'assets/icons/39_icon.png';
  static const iconBoatGold = 'assets/icons/40_icon.png';
  static const iconLandmark = 'assets/icons/41_icon.png';
  static const iconLandmarkGold = 'assets/icons/42_icon.png';
  static const iconPalm = 'assets/icons/43_icon.png';
  static const iconVase = 'assets/icons/44_icon.png';
  /// Onboarding themes — user medallions (transparent bg).
  static const iconThemePatrimoine = 'assets/icons/icon_theme_patrimoine.png';
  static const iconThemeCulture = 'assets/icons/icon_theme_culture.png';
  static const iconThemeTraditions = 'assets/icons/icon_theme_traditions.png';
  static const iconThemeScan = 'assets/icons/icon_theme_scan.png';
  static const iconThemeDiscover = 'assets/icons/icon_theme_discover.png';
  static const iconDoc = 'assets/icons/45_icon.png';
  static const iconCamera = 'assets/icons/46_icon.png';

  // Reference mockups only (do not use as screen UI)
  static const screenSplash = 'assets/screens/01_Splash.png';
  static const screenOnboarding1 = 'assets/screens/02_Onboarding_1.png';
  static const screenOnboarding2 = 'assets/screens/03_Onboarding_2.png';
  static const screenOnboarding3 = 'assets/screens/04_Onboarding_3.png';
  static const screenLogin = 'assets/screens/05_Login.png';
  static const screenSignUp = 'assets/screens/06_Sign_Up.png';
  static const screenHome = 'assets/screens/07_Home.png';
  static const screenParcours = 'assets/screens/08_Parcours_Detail.png';
  static const screenScanner = 'assets/screens/09_Scanner_QR.png';
  static const screenAudio = 'assets/screens/10_Audio_Story.png';
  static const screenAr = 'assets/screens/11_AR_Light.png';
  static const screenProfile = 'assets/screens/12_Profile.png';
  static const screenEditProfile = 'assets/screens/13_Edit_Profile.png';
  static const screenFavorites = 'assets/screens/14_Favorites.png';

  static String icon(int n) =>
      'assets/icons/${n.toString().padLeft(2, '0')}_icon.png';

  static String component(int n) => icon(n);

  static String placeholder(int n) =>
      'assets/bg/${n.toString().padLeft(2, '0')}_placeholder.jpg';
}
