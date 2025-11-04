import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'app_title': 'First Report',
      'choose_language': 'Choose Your Language',
      'select_language': 'Select your preferred language',
      'continue': 'Continue',
      'home': 'Home',
      'welcome': 'Welcome to First Report',
      'tap_to_continue': 'Tap anywhere to continue',
      'language': 'Language',
      'settings': 'Settings',
      'profile_details': 'Profile Details',
      'manage_your_profile': 'Manage your profile',
      'notifications': 'Notifications',
      'manage_notification_settings': 'Manage notification settings',
      'dark_mode': 'Dark Mode',
      'switch_to_dark_theme': 'Switch to dark theme',
      'privacy_policy': 'Privacy Policy',
      'read_our_privacy_policy': 'Read our privacy policy',
      'made_with_love': 'Made with ❤️ in India',
      'post': 'Post',
      'save_changes': 'Save Changes',
      'full_name': 'Full Name',
      'email_address': 'Email Address',
      'phone_number': 'Phone Number',
      'location': 'Location',
      'member_since': 'Member since',
      'posts': 'Posts',
      'reads': 'Reads',
      'stay_updated': 'Stay Updated',
      'customize_notification_preferences': 'Customize your notification preferences to stay informed about the news that matters to you.',
      'push_notifications': 'Push Notifications',
      'receive_push_notifications': 'Receive push notifications',
      'breaking_news_alerts': 'Breaking News Alerts',
      'get_notified_breaking_news': 'Get notified of breaking news',
      'trending_news': 'Trending News',
      'daily_trending_digest': 'Daily trending news digest',
      'quiz_reminders': 'Quiz Reminders',
      'daily_quiz_challenges': 'Daily quiz challenges',
      'post_updates': 'Post Updates',
      'updates_on_posted_news': 'Updates on your posted news',
      'quiet_hours': 'Quiet Hours',
      'mute_notifications_during_hours': 'Mute notifications during these hours',
      'from': 'From',
      'to': 'To',
      'profile_updated_successfully': 'Profile updated successfully',
      'please_fill_all_fields': 'Please fill all required fields',
      'english': 'English',
      'hindi': 'Hindi',
      'telugu': 'Telugu',
      'tamil': 'Tamil',
      'kannada': 'Kannada',
    },
    'hi': {
      'app_title': 'फर्स्ट रिपोर्ट',
      'choose_language': 'अपनी भाषा चुनें',
      'select_language': 'अपनी पसंदीदा भाषा चुनें',
      'continue': 'जारी रखें',
      'home': 'होम',
      'welcome': 'फर्स्ट रिपोर्ट में आपका स्वागत है',
      'tap_to_continue': 'जारी रखने के लिए कहीं भी टैप करें',
      'language': 'भाषा',
      'settings': 'सेटिंग्स',
      'profile_details': 'प्रोफ़ाइल विवरण',
      'manage_your_profile': 'अपनी प्रोफ़ाइल प्रबंधित करें',
      'notifications': 'सूचनाएं',
      'manage_notification_settings': 'सूचना सेटिंग्स प्रबंधित करें',
      'dark_mode': 'डार्क मोड',
      'switch_to_dark_theme': 'डार्क थीम पर स्विच करें',
      'privacy_policy': 'गोपनीयता नीति',
      'read_our_privacy_policy': 'हमारी गोपनीयता नीति पढ़ें',
      'made_with_love': 'भारत में ❤️ के साथ बनाया गया',
      'post': 'पोस्ट',
      'save_changes': 'परिवर्तन सहेजें',
      'full_name': 'पूरा नाम',
      'email_address': 'ईमेल पता',
      'phone_number': 'फोन नंबर',
      'location': 'स्थान',
      'member_since': 'सदस्यता से',
      'posts': 'पोस्ट',
      'reads': 'पढ़ता है',
      'stay_updated': 'अपडेट रहें',
      'customize_notification_preferences': 'आपकी सूचना प्राथमिकताओं को अनुकूलित करें ताकि आप उन समाचारों के बारे में सूचित रहें जो आपके लिए महत्वपूर्ण हैं।',
      'push_notifications': 'पुश सूचनाएं',
      'receive_push_notifications': 'पुश सूचनाएं प्राप्त करें',
      'breaking_news_alerts': 'ब्रेकिंग न्यूज अलर्ट',
      'get_notified_breaking_news': 'ब्रेकिंग न्यूज की सूचना प्राप्त करें',
      'trending_news': 'ट्रेंडिंग न्यूज',
      'daily_trending_digest': 'दैनिक ट्रेंडिंग समाचार सारांश',
      'quiz_reminders': 'क्विज़ रिमाइंडर',
      'daily_quiz_challenges': 'दैनिक क्विज़ चुनौतियां',
      'post_updates': 'पोस्ट अपडेट',
      'updates_on_posted_news': 'आपके पोस्ट किए गए समाचारों पर अपडेट',
      'quiet_hours': 'शांत घंटे',
      'mute_notifications_during_hours': 'इन घंटों के दौरान सूचनाएं म्यूट करें',
      'from': 'से',
      'to': 'तक',
      'profile_updated_successfully': 'प्रोफ़ाइल सफलतापूर्वक अपडेट हो गई',
      'please_fill_all_fields': 'कृपया सभी आवश्यक फ़ील्ड भरें',
      'english': 'अंग्रेजी',
      'hindi': 'हिंदी',
      'telugu': 'तेलुगु',
      'tamil': 'तमिल',
      'kannada': 'कन्नड़',
    },
    'te': {
      'app_title': 'ఫస్ట్ రిపోర్ట్',
      'choose_language': 'మీ భాషను ఎంచుకోండి',
      'select_language': 'మీకు ఇష్టమైన భాషను ఎంచుకోండి',
      'continue': 'కొనసాగించు',
      'home': 'హోమ్',
      'welcome': 'ఫస్ట్ రిపోర్ట్‌కు స్వాగతం',
      'tap_to_continue': 'కొనసాగించడానికి ఎక్కడైనా టాప్ చేయండి',
      'language': 'భాష',
      'settings': 'సెట్టింగ్‌లు',
      'profile_details': 'ప్రొఫైల్ వివరాలు',
      'manage_your_profile': 'మీ ప్రొఫైల్‌ను నిర్వహించండి',
      'notifications': 'నోటిఫికేషన్‌లు',
      'manage_notification_settings': 'నోటిఫికేషన్ సెట్టింగ్‌లను నిర్వహించండి',
      'dark_mode': 'డార్క్ మోడ్',
      'switch_to_dark_theme': 'డార్క్ థీమ్‌కు మారండి',
      'privacy_policy': 'గోప్యతా విధానం',
      'read_our_privacy_policy': 'మా గోప్యతా విధానాన్ని చదవండి',
      'made_with_love': 'భారతదేశంలో ❤️ తో తయారు చేయబడింది',
      'post': 'పోస్ట్',
      'save_changes': 'మార్పులను సేవ్ చేయండి',
      'full_name': 'పూర్తి పేరు',
      'email_address': 'ఇమెయిల్ చిరునామా',
      'phone_number': 'ఫోన్ నంబర్',
      'location': 'స్థానం',
      'member_since': 'సభ్యత్వం నుండి',
      'posts': 'పోస్ట్‌లు',
      'reads': 'చదువుతుంది',
      'stay_updated': 'నవీకరించబడిన ఉండండి',
      'customize_notification_preferences': 'మీకు ముఖ్యమైన వార్తల గురించి తెలియజేయడానికి మీ నోటిఫికేషన్ ప్రాధాన్యతలను అనుకూలీకరించండి.',
      'push_notifications': 'పుష్ నోటిఫికేషన్‌లు',
      'receive_push_notifications': 'పుష్ నోటిఫికేషన్‌లను స్వీకరించండి',
      'breaking_news_alerts': 'బ్రేకింగ్ న్యూస్ అలర్ట్‌లు',
      'get_notified_breaking_news': 'బ్రేకింగ్ న్యూస్‌కు సూచన పొందండి',
      'trending_news': 'ట్రెండింగ్ న్యూస్',
      'daily_trending_digest': 'రోజువారీ ట్రెండింగ్ వార్తల సారాంశం',
      'quiz_reminders': 'క్విజ్ రిమైండర్‌లు',
      'daily_quiz_challenges': 'రోజువారీ క్విజ్ సవాళ్లు',
      'post_updates': 'పోస్ట్ అప్‌డేట్‌లు',
      'updates_on_posted_news': 'మీరు పోస్ట్ చేసిన వార్తలపై అప్‌డేట్‌లు',
      'quiet_hours': 'నిశ్శబ్ద గంటలు',
      'mute_notifications_during_hours': 'ఈ గంటల సమయంలో నోటిఫికేషన్‌లను మ్యూట్ చేయండి',
      'from': 'నుండి',
      'to': 'వరకు',
      'profile_updated_successfully': 'ప్రొఫైల్ విజయవంతంగా నవీకరించబడింది',
      'please_fill_all_fields': 'దయచేసి అన్ని అవసరమైన ఫీల్డ్‌లను పూరించండి',
      'english': 'ఆంగ్లం',
      'hindi': 'హిందీ',
      'telugu': 'తెలుగు',
      'tamil': 'తమిళం',
      'kannada': 'కన్నడ',
    },
    'ta': {
      'app_title': 'பிரஸ்ட் ரிப்போர்ட்',
      'choose_language': 'உங்கள் மொழியைத் தேர்ந்தெடுக்கவும்',
      'select_language': 'உங்கள் விருப்பமான மொழியைத் தேர்ந்தெடுக்கவும்',
      'continue': 'தொடரவும்',
      'home': 'முகப்பு',
      'welcome': 'பிரஸ்ட் ரிப்போர்ட்டிற்கு வரவேற்கிறோம்',
      'tap_to_continue': 'தொடர சில இடத்தில் தட்டவும்',
      'language': 'மொழி',
      'settings': 'அமைப்புகள்',
      'profile_details': 'சுயவிவர விவரங்கள்',
      'manage_your_profile': 'உங்கள் சுயவிவரத்தை நிர்வகிக்கவும்',
      'notifications': 'அறிவிப்புகள்',
      'manage_notification_settings': 'அறிவிப்பு அமைப்புகளை நிர்வகிக்கவும்',
      'dark_mode': 'இருண்ட முறை',
      'switch_to_dark_theme': 'இருண்ட தீமுக்கு மாறவும்',
      'privacy_policy': 'தனியுரிமை கொள்கை',
      'read_our_privacy_policy': 'எங்கள் தனியுரிமை கொள்கையைப் படிக்கவும்',
      'made_with_love': 'இந்தியாவில் ❤️ உடன் தயாரிக்கப்பட்டது',
      'post': 'இடுகை',
      'save_changes': 'மாற்றங்களைச் சேமிக்கவும்',
      'full_name': 'முழு பெயர்',
      'email_address': 'மின்னஞ்சல் முகவரி',
      'phone_number': 'தொலைபேசி எண்',
      'location': 'இடம்',
      'member_since': 'உறுப்பினர் முதல்',
      'posts': 'இடுகைகள்',
      'reads': 'படிக்கிறது',
      'stay_updated': 'புதுப்பிக்கப்பட்டதாக இருங்கள்',
      'customize_notification_preferences': 'உங்களுக்கு முக்கியமான செய்திகளைப் பற்றி தெரிந்து கொள்ள உங்கள் அறிவிப்பு விருப்பங்களைத் தனிப்பயனாக்கவும்.',
      'push_notifications': 'புஷ் அறிவிப்புகள்',
      'receive_push_notifications': 'புஷ் அறிவிப்புகளைப் பெறுங்கள்',
      'breaking_news_alerts': 'பிரேக்கிங் நியூஸ் அலர்ட்ஸ்',
      'get_notified_breaking_news': 'பிரேக்கிங் செய்திகளுக்கு அறிவிக்கவும்',
      'trending_news': 'பிரபலமான செய்திகள்',
      'daily_trending_digest': 'தினசரி பிரபலமான செய்திகளின் சுருக்கம்',
      'quiz_reminders': 'வினாடி வினா நினைவூட்டல்கள்',
      'daily_quiz_challenges': 'தினசரி வினாடி வினா சவால்கள்',
      'post_updates': 'இடுகை புதுப்பிப்புகள்',
      'updates_on_posted_news': 'உங்கள் இடுகையிட்ட செய்திகளில் புதுப்பிப்புகள்',
      'quiet_hours': 'அமைதியான மணிநேரங்கள்',
      'mute_notifications_during_hours': 'இந்த மணிநேரங்களில் அறிவிப்புகளை முடக்கவும்',
      'from': 'இருந்து',
      'to': 'வரை',
      'profile_updated_successfully': 'சுயவிவரம் வெற்றிகரமாக புதுப்பிக்கப்பட்டது',
      'please_fill_all_fields': 'தயவுசெய்து அனைத்து தேவையான புலங்களையும் நிரப்பவும்',
      'english': 'ஆங்கிலம்',
      'hindi': 'இந்தி',
      'telugu': 'தெலுங்கு',
      'tamil': 'தமிழ்',
      'kannada': 'கன்னடம்',
    },
    'kn': {
      'app_title': 'ಫಸ್ಟ್ ರಿಪೋರ್ಟ್',
      'choose_language': 'ನಿಮ್ಮ ಭಾಷೆಯನ್ನು ಆಯ್ಕೆಮಾಡಿ',
      'select_language': 'ನಿಮ್ಮ ಮೆಚ್ಚಿನ ಭಾಷೆಯನ್ನು ಆಯ್ಕೆಮಾಡಿ',
      'continue': 'ಮುಂದುವರಿಸಿ',
      'home': 'ಹೋಮ್',
      'welcome': 'ಫಸ್ಟ್ ರಿಪೋರ್ಟ್‌ಗೆ ಸ್ವಾಗತ',
      'tap_to_continue': 'ಮುಂದುವರಿಸಲು ಎಲ್ಲಿಯಾದರೂ ಟ್ಯಾಪ್ ಮಾಡಿ',
      'language': 'ಭಾಷೆ',
      'settings': 'ಸೆಟ್ಟಿಂಗ್‌ಗಳು',
      'profile_details': 'ಪ್ರೊಫೈಲ್ ವಿವರಗಳು',
      'manage_your_profile': 'ನಿಮ್ಮ ಪ್ರೊಫೈಲ್‌ನ್ನು ನಿರ್ವಹಿಸಿ',
      'notifications': 'ಅಧಿಸೂಚನೆಗಳು',
      'manage_notification_settings': 'ಅಧಿಸೂಚನಾ ಸೆಟ್ಟಿಂಗ್‌ಗಳನ್ನು ನಿರ್ವಹಿಸಿ',
      'dark_mode': 'ಡಾರ್ಕ್ ಮೋಡ್',
      'switch_to_dark_theme': 'ಡಾರ್ಕ್ ಥೀಮ್‌ಗೆ ಬದಲಾಯಿಸಿ',
      'privacy_policy': 'ಗೌಪ್ಯತೆ ನೀತಿ',
      'read_our_privacy_policy': 'ನಮ್ಮ ಗೌಪ್ಯತೆ ನೀತಿಯನ್ನು ಓದಿ',
      'made_with_love': 'ಭಾರತದಲ್ಲಿ ❤️ ಜೊತೆಗೆ ಮಾಡಲಾಗಿದೆ',
      'post': 'ಪೋಸ್ಟ್',
      'save_changes': 'ಬದಲಾವಣೆಗಳನ್ನು ಉಳಿಸಿ',
      'full_name': 'ಪೂರ್ಣ ಹೆಸರು',
      'email_address': 'ಇಮೇಲ್ ವಿಳಾಸ',
      'phone_number': 'ಫೋನ್ ಸಂಖ್ಯೆ',
      'location': 'ಸ್ಥಳ',
      'member_since': 'ಸದಸ್ಯತ್ವದಿಂದ',
      'posts': 'ಪೋಸ್ಟ್‌ಗಳು',
      'reads': 'ಓದುತ್ತದೆ',
      'stay_updated': 'ನವೀಕರಿಸಲಾಗಿದೆ',
      'customize_notification_preferences': 'ನಿಮಗೆ ಮುಖ್ಯವಾದ ಸುದ್ದಿಗಳ ಬಗ್ಗೆ ತಿಳಿದುಕೊಳ್ಳಲು ನಿಮ್ಮ ಅಧಿಸೂಚನಾ ಆದ್ಯತೆಗಳನ್ನು ಹೊಂದಾಣಿಕೆ ಮಾಡಿ.',
      'push_notifications': 'ಪುಶ್ ಅಧಿಸೂಚನೆಗಳು',
      'receive_push_notifications': 'ಪುಶ್ ಅಧಿಸೂಚನೆಗಳನ್ನು ಸ್ವೀಕರಿಸಿ',
      'breaking_news_alerts': 'ಬ್ರೇಕಿಂಗ್ ನ್ಯೂಸ್ ಅಲರ್ಟ್‌ಗಳು',
      'get_notified_breaking_news': 'ಬ್ರೇಕಿಂಗ್ ನ್ಯೂಸ್‌ಗೆ ಅಧಿಸೂಚನೆ ಪಡೆಯಿರಿ',
      'trending_news': 'ಟ್ರೆಂಡಿಂಗ್ ನ್ಯೂಸ್',
      'daily_trending_digest': 'ದೈನಂದಿನ ಟ್ರೆಂಡಿಂಗ್ ಸುದ್ದಿಯ ಸಾರಾಂಶ',
      'quiz_reminders': 'ಕ್ವಿಜ್ ರಿಮೈಂಡರ್‌ಗಳು',
      'daily_quiz_challenges': 'ದೈನಂದಿನ ಕ್ವಿಜ್ ಸವಾಲುಗಳು',
      'post_updates': 'ಪೋಸ್ಟ್ ಅಪ್‌ಡೇಟ್‌ಗಳು',
      'updates_on_posted_news': 'ನಿಮ್ಮ ಪೋಸ್ಟ್ ಮಾಡಿದ ಸುದ್ದಿಯ ಮೇಲೆ ಅಪ್‌ಡೇಟ್‌ಗಳು',
      'quiet_hours': 'ನಿಶ್ಚಲ ಸಮಯಗಳು',
      'mute_notifications_during_hours': 'ಈ ಸಮಯದಲ್ಲಿ ಅಧಿಸೂಚನೆಗಳನ್ನು ಮ್ಯೂಟ್ ಮಾಡಿ',
      'from': 'ಇಂದ',
      'to': 'ವರೆಗೆ',
      'profile_updated_successfully': 'ಪ್ರೊಫೈಲ್ ಯಶಸ್ವಿಯಾಗಿ ನವೀಕರಿಸಲಾಗಿದೆ',
      'please_fill_all_fields': 'ದಯವಿಟ್ಟು ಎಲ್ಲಾ ಅಗತ್ಯವಿರುವ ಫೀಲ್ಡ್‌ಗಳನ್ನು ಭರ್ತಿ ಮಾಡಿ',
      'english': 'ಇಂಗ್ಲೀಷ್',
      'hindi': 'ಹಿಂದಿ',
      'telugu': 'ತೆಲುಗು',
      'tamil': 'ತಮಿಳು',
      'kannada': 'ಕನ್ನಡ',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? 
           _localizedValues['en']?[key] ?? key;
  }

  // Getters for common translations
  String get appTitle => translate('app_title');
  String get chooseLanguage => translate('choose_language');
  String get selectLanguage => translate('select_language');
  String get continueText => translate('continue');
  String get home => translate('home');
  String get welcome => translate('welcome');
  String get tapToContinue => translate('tap_to_continue');
  String get language => translate('language');
  String get settings => translate('settings');
  String get profileDetails => translate('profile_details');
  String get manageYourProfile => translate('manage_your_profile');
  String get notifications => translate('notifications');
  String get manageNotificationSettings => translate('manage_notification_settings');
  String get darkMode => translate('dark_mode');
  String get switchToDarkTheme => translate('switch_to_dark_theme');
  String get privacyPolicy => translate('privacy_policy');
  String get readOurPrivacyPolicy => translate('read_our_privacy_policy');
  String get madeWithLove => translate('made_with_love');
  String get post => translate('post');
  String get saveChanges => translate('save_changes');
  String get fullName => translate('full_name');
  String get emailAddress => translate('email_address');
  String get phoneNumber => translate('phone_number');
  String get location => translate('location');
  String get memberSince => translate('member_since');
  String get posts => translate('posts');
  String get reads => translate('reads');
  String get stayUpdated => translate('stay_updated');
  String get customizeNotificationPreferences => translate('customize_notification_preferences');
  String get pushNotifications => translate('push_notifications');
  String get receivePushNotifications => translate('receive_push_notifications');
  String get breakingNewsAlerts => translate('breaking_news_alerts');
  String get getNotifiedBreakingNews => translate('get_notified_breaking_news');
  String get trendingNews => translate('trending_news');
  String get dailyTrendingDigest => translate('daily_trending_digest');
  String get quizReminders => translate('quiz_reminders');
  String get dailyQuizChallenges => translate('daily_quiz_challenges');
  String get postUpdates => translate('post_updates');
  String get updatesOnPostedNews => translate('updates_on_posted_news');
  String get quietHours => translate('quiet_hours');
  String get muteNotificationsDuringHours => translate('mute_notifications_during_hours');
  String get from => translate('from');
  String get to => translate('to');
  String get profileUpdatedSuccessfully => translate('profile_updated_successfully');
  String get pleaseFillAllFields => translate('please_fill_all_fields');
  
  // Language names
  String getLanguageName(String code) {
    final langMap = {
      'en': translate('english'),
      'hi': translate('hindi'),
      'te': translate('telugu'),
      'ta': translate('tamil'),
      'kn': translate('kannada'),
    };
    return langMap[code] ?? code;
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'hi', 'te', 'ta', 'kn'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

