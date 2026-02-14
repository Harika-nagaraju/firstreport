import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  // Helper method to get instance from context
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  // All translations
  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      // Bottom Navigation
      'home': 'Home',
      'post': 'Post',
      'quiz': 'Quiz',
      'settings': 'Settings',
      
      // Common
      'all': 'All',
      'yesterday': 'Yesterday',
      'india': 'India',
      'international': 'International',
      'current_affairs': 'Current Affairs',
      'health': 'Health',
      'tech': 'Tech',
      'loading': 'Loading...',
      'retry': 'Retry',
      'save': 'Save',
      'saved': 'Saved',
      'share': 'Share',
      'read_more': 'Read More',
      'read_less': 'Read Less',
      'search_news': 'Search news...',
      'no_news_found': 'No news found',
      
      // Settings
      'general': 'General',
      'account': 'Account',
      'support': 'Support',
      'language': 'Language',
      'dark_mode': 'Dark Mode',
      'profile_details': 'Profile Details',
      'notifications': 'Notifications',
      'saved_ones': 'Saved Ones',
      'privacy_policy': 'Privacy Policy',
      'terms_conditions': 'Terms & Conditions',
      'contact_support': 'Contact Support',
      
      // Post News
      'post_news': 'Post News',
      'title': 'Title',
      'description': 'Description',
      'category': 'Category',
      'upload_media': 'Upload Media',
      'select_image': 'Select Image',
      'submit': 'Submit',
      
      // Auth
      'login': 'Login',
      'signup': 'Sign Up',
      'email': 'Email',
      'password': 'Password',
      'forgot_password': 'Forgot Password?',
    },
    'hi': {
      // Bottom Navigation
      'home': 'होम',
      'post': 'पोस्ट',
      'quiz': 'क्विज़',
      'settings': 'सेटिंग्स',
      
      // Common
      'all': 'सभी',
      'yesterday': 'कल',
      'india': 'भारत',
      'international': 'अंतर्राष्ट्रीय',
      'current_affairs': 'वर्तमान घटनाक्रम',
      'health': 'स्वास्थ्य',
      'tech': 'टेक',
      'loading': 'लोड हो रहा है...',
      'retry': 'पुनः प्रयास करें',
      'save': 'सहेजें',
      'saved': 'सहेजा गया',
      'share': 'साझा करें',
      'read_more': 'और पढ़ें',
      'read_less': 'कम पढ़ें',
      'search_news': 'समाचार खोजें...',
      'no_news_found': 'कोई समाचार नहीं मिला',
      
      // Settings
      'general': 'सामान्य',
      'account': 'खाता',
      'support': 'सहायता',
      'language': 'भाषा',
      'dark_mode': 'डार्क मोड',
      'profile_details': 'प्रोफ़ाइल विवरण',
      'notifications': 'सूचनाएं',
      'saved_ones': 'सहेजे गए',
      'privacy_policy': 'गोपनीयता नीति',
      'terms_conditions': 'नियम और शर्तें',
      'contact_support': 'सहायता से संपर्क करें',
      
      // Post News
      'post_news': 'समाचार पोस्ट करें',
      'title': 'शीर्षक',
      'description': 'विवरण',
      'category': 'श्रेणी',
      'upload_media': 'मीडिया अपलोड करें',
      'select_image': 'छवि चुनें',
      'submit': 'जमा करें',
      
      // Auth
      'login': 'लॉगिन',
      'signup': 'साइन अप',
      'email': 'ईमेल',
      'password': 'पासवर्ड',
      'forgot_password': 'पासवर्ड भूल गए?',
    },
    'te': {
      // Bottom Navigation
      'home': 'హోమ్',
      'post': 'పోస్ట్',
      'quiz': 'క్విజ్',
      'settings': 'సెట్టింగ్స్',
      
      // Common
      'all': 'అన్నీ',
      'yesterday': 'నిన్న',
      'india': 'భారతదేశం',
      'international': 'అంతర్జాతీయ',
      'current_affairs': 'నేటి విషయాలు',
      'health': 'ఆరోగ్యం',
      'tech': 'టెక్',
      'loading': 'లోడ్ అవుతోంది...',
      'retry': 'మళ్లీ ప్రయత్నించండి',
      'save': 'సేవ్',
      'saved': 'సేవ్ చేయబడింది',
      'share': 'షేర్',
      'read_more': 'మరింత చదవండి',
      'read_less': 'తక్కువ చదవండి',
      'search_news': 'వార్తలు శోధించండి...',
      'no_news_found': 'వార్తలు కనుగొనబడలేదు',
      
      // Settings
      'general': 'సాధారణ',
      'account': 'ఖాతా',
      'support': 'మద్దతు',
      'language': 'భాష',
      'dark_mode': 'డార్క్ మోడ్',
      'profile_details': 'ప్రొఫైల్ వివరాలు',
      'notifications': 'నోటిఫికేషన్లు',
      'saved_ones': 'సేవ్ చేసినవి',
      'privacy_policy': 'గోప్యతా విధానం',
      'terms_conditions': 'నిబంధనలు & షరతులు',
      'contact_support': 'మద్దతును సంప్రదించండి',
      
      // Post News
      'post_news': 'వార్తలు పోస్ట్ చేయండి',
      'title': 'శీర్షిక',
      'description': 'వివరణ',
      'category': 'వర్గం',
      'upload_media': 'మీడియా అప్లోడ్ చేయండి',
      'select_image': 'చిత్రాన్ని ఎంచుకోండి',
      'submit': 'సమర్పించండి',
      
      // Auth
      'login': 'లాగిన్',
      'signup': 'సైన్ అప్',
      'email': 'ఇమెయిల్',
      'password': 'పాస్వర్డ్',
      'forgot_password': 'పాస్వర్డ్ మర్చిపోయారా?',
    },
    'ta': {
      // Bottom Navigation
      'home': 'முகப்பு',
      'post': 'இடுகை',
      'quiz': 'வினாடி வினா',
      'settings': 'அமைப்புகள்',
      
      // Common
      'all': 'அனைத்தும்',
      'yesterday': 'நேற்று',
      'india': 'இந்தியா',
      'international': 'சர்வதேச',
      'current_affairs': 'நடப்பு நிகழ்வுகள்',
      'health': 'சுகாதாரம்',
      'tech': 'தொழில்நுட்பம்',
      'loading': 'ஏற்றுகிறது...',
      'retry': 'மீண்டும் முயற்சிக்கவும்',
      'save': 'சேமி',
      'saved': 'சேமிக்கப்பட்டது',
      'share': 'பகிர்',
      'read_more': 'மேலும் படிக்க',
      'read_less': 'குறைவாக படிக்க',
      'search_news': 'செய்திகளைத் தேடு...',
      'no_news_found': 'செய்திகள் இல்லை',
      
      // Settings
      'general': 'பொது',
      'account': 'கணக்கு',
      'support': 'ஆதரவு',
      'language': 'மொழி',
      'dark_mode': 'இருண்ட பயன்முறை',
      'profile_details': 'சுயவிவர விவரங்கள்',
      'notifications': 'அறிவிப்புகள்',
      'saved_ones': 'சேமித்தவை',
      'privacy_policy': 'தனியுரிமை கொள்கை',
      'terms_conditions': 'விதிமுறைகள் & நிபந்தனைகள்',
      'contact_support': 'ஆதரவைத் தொடர்பு கொள்ளவும்',
      
      // Post News
      'post_news': 'செய்தி இடுகை',
      'title': 'தலைப்பு',
      'description': 'விளக்கம்',
      'category': 'வகை',
      'upload_media': 'ஊடகத்தை பதிவேற்று',
      'select_image': 'படத்தைத் தேர்ந்தெடுக்கவும்',
      'submit': 'சமர்ப்பிக்கவும்',
      
      // Auth
      'login': 'உள்நுழைய',
      'signup': 'பதிவு செய்க',
      'email': 'மின்னஞ்சல்',
      'password': 'கடவுச்சொல்',
      'forgot_password': 'கடவுச்சொல்லை மறந்துவிட்டீர்களா?',
    },
    'kn': {
      // Bottom Navigation
      'home': 'ಮುಖಪುಟ',
      'post': 'ಪೋಸ್ಟ್',
      'quiz': 'ಕ್ವಿಜ್',
      'settings': 'ಸೆಟ್ಟಿಂಗ್ಸ್',
      
      // Common
      'all': 'ಎಲ್ಲಾ',
      'yesterday': 'ನಿನ್ನೆ',
      'india': 'ಭಾರತ',
      'international': 'ಅಂತರರಾಷ್ಟ್ರೀಯ',
      'current_affairs': 'ಪ್ರಸ್ತುತ ಘಟನೆಗಳು',
      'health': 'ಆರೋಗ್ಯ',
      'tech': 'ತಂತ್ರಜ್ಞಾನ',
      'loading': 'ಲೋಡ್ ಆಗುತ್ತಿದೆ...',
      'retry': 'ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ',
      'save': 'ಉಳಿಸಿ',
      'saved': 'ಉಳಿಸಲಾಗಿದೆ',
      'share': 'ಹಂಚಿಕೊಳ್ಳಿ',
      'read_more': 'ಇನ್ನಷ್ಟು ಓದಿ',
      'read_less': 'ಕಡಿಮೆ ಓದಿ',
      'search_news': 'ಸುದ್ದಿಗಳನ್ನು ಹುಡುಕಿ...',
      'no_news_found': 'ಯಾವುದೇ ಸುದ್ದಿ ಸಿಗಲಿಲ್ಲ',
      
      // Settings
      'general': 'ಸಾಮಾನ್ಯ',
      'account': 'ಖಾತೆ',
      'support': 'ಬೆಂಬಲ',
      'language': 'ಭಾಷೆ',
      'dark_mode': 'ಡಾರ್ಕ್ ಮೋಡ್',
      'profile_details': 'ಪ್ರೊಫೈಲ್ ವಿವರಗಳು',
      'notifications': 'ಅಧಿಸೂಚನೆಗಳು',
      'saved_ones': 'ಉಳಿಸಿದವುಗಳು',
      'privacy_policy': 'ಗೌಪ್ಯತಾ ನೀತಿ',
      'terms_conditions': 'ನಿಯಮಗಳು & ಷರತ್ತುಗಳು',
      'contact_support': 'ಬೆಂಬಲವನ್ನು ಸಂಪರ್ಕಿಸಿ',
      
      // Post News
      'post_news': 'ಸುದ್ದಿ ಪೋಸ್ಟ್ ಮಾಡಿ',
      'title': 'ಶೀರ್ಷಿಕೆ',
      'description': 'ವಿವರಣೆ',
      'category': 'ವರ್ಗ',
      'upload_media': 'ಮಾಧ್ಯಮ ಅಪ್ಲೋಡ್ ಮಾಡಿ',
      'select_image': 'ಚಿತ್ರವನ್ನು ಆಯ್ಕೆಮಾಡಿ',
      'submit': 'ಸಲ್ಲಿಸಿ',
      
      // Auth
      'login': 'ಲಾಗಿನ್',
      'signup': 'ಸೈನ್ ಅಪ್',
      'email': 'ಇಮೇಲ್',
      'password': 'ಪಾಸ್ವರ್ಡ್',
      'forgot_password': 'ಪಾಸ್ವರ್ಡ್ ಮರೆತಿರುವಿರಾ?',
    },
  };

  // Get translation by key
  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? 
           _localizedValues['en']?[key] ?? 
           key;
  }

  // Convenience getters
  String get home => translate('home');
  String get post => translate('post');
  String get quiz => translate('quiz');
  String get settings => translate('settings');
  String get all => translate('all');
  String get yesterday => translate('yesterday');
  String get india => translate('india');
  String get international => translate('international');
  String get currentAffairs => translate('current_affairs');
  String get health => translate('health');
  String get tech => translate('tech');
  String get loading => translate('loading');
  String get retry => translate('retry');
  String get save => translate('save');
  String get saved => translate('saved');
  String get share => translate('share');
  String get readMore => translate('read_more');
  String get readLess => translate('read_less');
  String get searchNews => translate('search_news');
  String get noNewsFound => translate('no_news_found');
  String get general => translate('general');
  String get account => translate('account');
  String get support => translate('support');
  String get language => translate('language');
  String get darkMode => translate('dark_mode');
  String get profileDetails => translate('profile_details');
  String get notifications => translate('notifications');
  String get savedOnes => translate('saved_ones');
  String get privacyPolicy => translate('privacy_policy');
  String get termsConditions => translate('terms_conditions');
  String get contactSupport => translate('contact_support');
  String get postNews => translate('post_news');
  String get title => translate('title');
  String get description => translate('description');
  String get category => translate('category');
  String get uploadMedia => translate('upload_media');
  String get selectImage => translate('select_image');
  String get submit => translate('submit');
  String get login => translate('login');
  String get signup => translate('signup');
  String get email => translate('email');
  String get password => translate('password');
  String get forgotPassword => translate('forgot_password');
}

// Localization delegate
class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'hi', 'te', 'ta', 'kn'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => true;
}
