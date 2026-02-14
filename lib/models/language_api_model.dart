class LanguageApiResponse {
  final bool success;
  final String language;
  final Translations translations;

  LanguageApiResponse({
    required this.success,
    required this.language,
    required this.translations,
  });

  factory LanguageApiResponse.fromJson(Map<String, dynamic> json) {
    return LanguageApiResponse(
      success: json['success'] ?? false,
      language: json['language'] ?? 'en',
      translations: Translations.fromJson(json['translations'] ?? {}),
    );
  }
}

class Translations {
  // Common
  final String continueText;
  final String selectLanguage;
  final String chooseLanguage;
  final String saveChanges;
  final String retry;
  final String loading;
  final String searchNews;
  final String noNewsFound;

  // Auth
  final String login;
  final String signup;
  final String emailLabel;
  final String emailHint;
  final String passwordLabel;
  final String passwordHint;
  final String fullNameLabel;
  final String fullNameHint;
  final String phoneNumberLabel;
  final String phoneNumberHint;
  final String forgotPassword;
  final String dontHaveAccount;
  final String alreadyHaveAccount;
  final String createAccount;
  final String continueWithGoogle;
  final String verifyOtp;
  final String enterOtp;
  final String resendOtp;
  final String resetPassword;
  final String newPassword;
  final String confirmPassword;

  // Dashboard / Home
  final String home;
  final String post;
  final String quiz;
  final String settings;
  final String readMore;
  final String readLess;
  final String share;
  final String save;
  final String saved;
  final String all;
  final String yesterday;
  final String india;
  final String international;
  final String currentAffairs;
  final String health;
  final String tech;

  // Settings
  final String general;
  final String account;
  final String support;
  final String language;
  final String darkMode;
  final String profileDetails;
  final String notifications;
  final String savedOnes;
  final String privacyPolicy;
  final String termsConditions;
  final String contactSupport;
  final String memberSince;
  final String verifiedReader;
  final String personalizedFeed;

  Translations({
    required this.continueText,
    required this.selectLanguage,
    required this.chooseLanguage,
    required this.saveChanges,
    required this.retry,
    required this.loading,
    required this.searchNews,
    required this.noNewsFound,
    required this.login,
    required this.signup,
    required this.emailLabel,
    required this.emailHint,
    required this.passwordLabel,
    required this.passwordHint,
    required this.fullNameLabel,
    required this.fullNameHint,
    required this.phoneNumberLabel,
    required this.phoneNumberHint,
    required this.forgotPassword,
    required this.dontHaveAccount,
    required this.alreadyHaveAccount,
    required this.createAccount,
    required this.continueWithGoogle,
    required this.verifyOtp,
    required this.enterOtp,
    required this.resendOtp,
    required this.resetPassword,
    required this.newPassword,
    required this.confirmPassword,
    required this.home,
    required this.post,
    required this.quiz,
    required this.settings,
    required this.readMore,
    required this.readLess,
    required this.share,
    required this.save,
    required this.saved,
    required this.all,
    required this.yesterday,
    required this.india,
    required this.international,
    required this.currentAffairs,
    required this.health,
    required this.tech,
    required this.general,
    required this.account,
    required this.support,
    required this.language,
    required this.darkMode,
    required this.profileDetails,
    required this.notifications,
    required this.savedOnes,
    required this.privacyPolicy,
    required this.termsConditions,
    required this.contactSupport,
    required this.memberSince,
    required this.verifiedReader,
    required this.personalizedFeed,
  });

  factory Translations.fromJson(Map<String, dynamic> json) {
    return Translations(
      continueText: json['continue'] ?? 'Continue',
      selectLanguage: json['select_language'] ?? 'Select your preferred language',
      chooseLanguage: json['choose_language'] ?? 'Choose Your Language',
      saveChanges: json['save_changes'] ?? 'Save Changes',
      retry: json['retry'] ?? 'Retry',
      loading: json['loading'] ?? 'Loading...',
      searchNews: json['search_news'] ?? 'Search news...',
      noNewsFound: json['no_news_found'] ?? 'No news found',
      login: json['login'] ?? 'Login',
      signup: json['signup'] ?? 'Sign Up',
      emailLabel: json['email_label'] ?? 'Email',
      emailHint: json['email_hint'] ?? 'Enter your email',
      passwordLabel: json['password_label'] ?? 'Password',
      passwordHint: json['password_hint'] ?? 'Enter your password',
      fullNameLabel: json['full_name_label'] ?? 'Full Name',
      fullNameHint: json['full_name_hint'] ?? 'Enter your full name',
      phoneNumberLabel: json['phone_number_label'] ?? 'Phone Number',
      phoneNumberHint: json['phone_number_hint'] ?? 'Enter your phone number',
      forgotPassword: json['forgot_password'] ?? 'Forgot Password?',
      dontHaveAccount: json['dont_have_account'] ?? "Don't have an account? ",
      alreadyHaveAccount: json['already_have_account'] ?? 'Already have an account? ',
      createAccount: json['create_account'] ?? 'Create your account',
      continueWithGoogle: json['continue_with_google'] ?? 'Continue with Google',
      verifyOtp: json['verify_otp'] ?? 'Verify OTP',
      enterOtp: json['enter_otp'] ?? 'Enter OTP',
      resendOtp: json['resend_otp'] ?? 'Resend OTP',
      resetPassword: json['reset_password'] ?? 'Reset Password',
      newPassword: json['new_password'] ?? 'New Password',
      confirmPassword: json['confirm_password'] ?? 'Confirm Password',
      home: json['home'] ?? 'Home',
      post: json['post'] ?? 'Post',
      quiz: json['quiz'] ?? 'Quiz',
      settings: json['settings'] ?? 'Settings',
      readMore: json['read_more'] ?? 'Read More',
      readLess: json['read_less'] ?? 'Read Less',
      share: json['share'] ?? 'Share',
      save: json['save'] ?? 'Save',
      saved: json['saved'] ?? 'Saved',
      all: json['all'] ?? 'All',
      yesterday: json['yesterday'] ?? 'Yesterday',
      india: json['india'] ?? 'India',
      international: json['international'] ?? 'International',
      currentAffairs: json['current_affairs'] ?? 'Current Affairs',
      health: json['health'] ?? 'Health',
      tech: json['tech'] ?? 'Tech',
      general: json['general'] ?? 'General',
      account: json['account'] ?? 'Account',
      support: json['support'] ?? 'Support',
      language: json['language'] ?? 'Language',
      darkMode: json['dark_mode'] ?? 'Dark Mode',
      profileDetails: json['profile_details'] ?? 'Profile Details',
      notifications: json['notifications'] ?? 'Notifications',
      savedOnes: json['saved_ones'] ?? 'Saved Ones',
      privacyPolicy: json['privacy_policy'] ?? 'Privacy Policy',
      termsConditions: json['terms_conditions'] ?? 'Terms & Conditions',
      contactSupport: json['contact_support'] ?? 'Contact Support',
      memberSince: json['member_since'] ?? 'Member since',
      verifiedReader: json['verified_reader'] ?? 'Verified Reader',
      personalizedFeed: json['personalized_feed'] ?? 'Personalized Feed',
    );
  }
}

