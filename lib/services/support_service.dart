class SupportService {
  static const String helpCenterUrl = 'https://support.wsvpn.com/help';
  static const String privacyPolicyUrl = 'https://support.wsvpn.com/privacy';
  static const String termsOfServiceUrl = 'https://support.wsvpn.com/terms';
  static const String contactUsUrl = 'https://support.wsvpn.com/contact';

  static const Map<String, String> supportUrls = {
    'help': helpCenterUrl,
    'privacy': privacyPolicyUrl,
    'terms': termsOfServiceUrl,
    'contact': contactUsUrl,
  };

  static String getUrl(String key) {
    return supportUrls[key] ?? helpCenterUrl;
  }
} 