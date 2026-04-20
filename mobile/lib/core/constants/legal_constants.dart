class LegalConstants {
  static const String privacyPolicy = '''
# Privacy Policy for HydraFlow

**Last Updated: April 16, 2026**

HydraFlow ("we", "us", "our") is committed to protecting your privacy. This Privacy Policy explains how we collect, use, and protect your information when you use our hydration tracking application.

## 1. Data Collection
We collect the following personal information to provide essential app functionality:
- **Email Address**: Used for account authentication and data synchronization.
- **Physical Weight & Activity Levels**: Used strictly locally or within our secure cloud to calculate personalized hydration goals.
- **Hydration Logs**: Timestamps and amounts of water recorded.

## 2. Data Usage
We process your data to:
- Calculate and adjust hydration reminders.
- Provide analytics on your hydration habits.
- Sync your data across multiple devices.

## 3. Data Deletion
In compliance with Google Play's Unified Deletion Policy, users have the right to delete their entire account and all associated data at any time via the **Settings -> Danger Zone** section of the app. Alternatively, users can request deletion through our web portal.

## 4. Third-Party Services
We use Firebase for authentication and database services. Your data is stored securely in Firebase's data centers.

## 5. Contact
For privacy-related inquiries, contact support@hydraflow.app.
''';

  static const String termsOfService = '''
# Terms of Service

**Last Updated: April 16, 2026**

By using HydraFlow, you agree to the following terms:

## 1. Acceptance
By downloading and using HydraFlow, you accept these terms in full. If you disagree, please stop using the application.

## 2. Health Disclaimer
**HydraFlow is NOT a medical application.** Guidelines are based on population-level standards (NAM/WHO) and should not replace professional medical advice. Always consult a physician for specific health needs.

## 3. Subscriptions
Premium features are managed via auto-renewing subscriptions through the Google Play Store.

## 4. Liability
We are not liable for any injuries or health issues arising from your use of the application.

## 5. Changes
We reserve the right to modify these terms at any time.
''';

  static const String medicalDisclaimer = '''
# Medical Disclaimer

**HydraFlow is a wellness and habit-building application.**

The water intake recommendations provided (calculated based on weight and activity) are intended for educational and general wellness purposes only.

### WARNING:
1. **Not Diagnostic**: This app does not diagnose, treat, or prevent any disease.
2. **Consult a Doctor**: If you have kidney disease, congestive heart failure, or other conditions affecting fluid balance, you **MUST** consult a medical professional before following app targets.
3. **Listen to Your Body**: Thirst is a complex physiological signal. The app's reminders should be used as nudges, not absolute mandates. 

By using this app, you acknowledge that you are responsible for your own health decisions.
''';

  static const String dataUsagePolicy = '''
# Data Usage Policy

HydraFlow operates with a **Transparency-First** mandate for all user data.

### 1. Transparency
- All data collected is solely for the purpose of improving your hydration habit.
- We do not sell user data to advertisers or third-party data brokers.

### 2. Portability
- Users can export a full JSON package of their hydration logs at any time via the Settings menu.

### 3. Deletion Execution
- When you click "Delete Account," we perform a permanent erasure of your user document and all associated sub-collections from our Firestore servers within 24 hours.
''';
}

enum LegalType {
  privacy,
  terms,
  disclaimer,
  dataUsage;

  String get title {
    switch (this) {
      case LegalType.privacy: return 'Privacy Policy';
      case LegalType.terms: return 'Terms of Service';
      case LegalType.disclaimer: return 'Medical Disclaimer';
      case LegalType.dataUsage: return 'Data Usage Policy';
    }
  }

  String get content {
    switch (this) {
      case LegalType.privacy: return LegalConstants.privacyPolicy;
      case LegalType.terms: return LegalConstants.termsOfService;
      case LegalType.disclaimer: return LegalConstants.medicalDisclaimer;
      case LegalType.dataUsage: return LegalConstants.dataUsagePolicy;
    }
  }
}


