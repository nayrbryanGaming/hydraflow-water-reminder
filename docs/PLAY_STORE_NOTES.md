# Google Play Submission Guide — HydraFlow (Attempt 8)

If your app has been rejected 7 times, the issue is likely not just the code, but the **declarations** and **metadata** in the Google Play Console. Follow this guide for a successful 8th attempt.

## 1. Mandatory 'Health Apps' Declaration
As of late 2024, Google requires a specific declaration for any app in the Health category.
- **Path**: Play Console -> Policy -> App Content -> Health Apps
- **Selection**: Select "Health Management" or "Fitness".
- **Documentation**: If prompted, state that the app is a "Hydration tracker providing general wellness reminders and is NOT a medical device."

## 2. Data Safety Section
Ensure your Data Safety section matches these exact points:
- **Data Collected**: 
    - Personal Info (Weight - used for hydration calculation).
    - Health & Fitness (Water intake Logs).
    - Device IDs (for Firebase Cloud Messaging).
- **Data Usage**: State that data is used for "App Functionality" and "Analytics".
- **Data Deletion**: **YES**, users can request data deletion (via the in-app Delete Account button).

## 3. Account Deletion Declaration
- **Path**: Policy -> App Content -> Data Safety
- **Required**: You MUST provide a web link for account deletion. Use your Next.js landing page link (e.g., `https://hydraflow-your-url.vercel.app/delete-account`) or your Privacy Policy link.

## 4. Metadata & Store Listing
- **Headline**: Avoid medical claims like "Cure dehydration" or "Prevents headaches". 
- **Recommended**: "HydraFlow helps you build a healthy hydration habit through smart reminders."
- **Testing Credits**: Provide a test account (Email/Password) to the Google Reviewer in the "App Access" section.

## 5. Background Task Policy (Android 14+)
- Google now strictly limits "Exact Alarms". 
- In your submission notes to the reviewer, mention: "The app requires USE_EXACT_ALARM permission to provide precisely timed hydration reminders as requested by the user for health purposes."

---
*Good luck with Attempt 8! This version includes the mandatory in-app disclaimer and Android 14 compliance to clear technical hurdles.*
