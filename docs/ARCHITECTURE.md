# Software Architecture

HydraFlow relies on a decoupled, scalable, and modern stack designed for high velocity, offline-capability, and structural integrity. 

## Architectural Principles
1. **Clean Architecture (Mobile):** Strict separation of concerns (Presentation, Domain, Infrastructure). No business logic exists within the Flutter Widget tree.
2. **Offline-First:** All hydration logs are immediately mapped to local caching via Hive and Firebase offline persistence. Syncing handles itself under the hood when connectivity is restored.
3. **Reactive Data Streams:** Utilizing `flutter_riverpod` + `snapshots()`, data flows in exactly one direction. Modifications to Firestore immediately trigger Provider updates, effortlessly rebuilding relevant UI boundaries.

## Component Breakdown

### App Level (`mobile/`)
- **UI Framework:** Flutter (Dart 3.x)
- **Local State Management:** Riverpod 
- **Local Storage:** Hive
- **Local Notifications:** flutter_local_notifications (Handles all Reminders engine logic heavily without relying on expensive chron-jobs)

### Backend Level (`backend/`)
- **Database:** Firebase Cloud Firestore (NoSQL, collection-document model)
- **Functions:** Node.js Firebase Cloud Functions
- **Triggers:** Asynchronous triggers (`onCreate`, `onUpdate`) decouple UI from heavy database map-reduces (like processing cumulative Streaks or Milestones)

### Infrastructure Layer
- **Hosting (Web):** Vercel edge networks
- **Web Framework:** Next.js 14
- **Analytics:** Firebase Crashlytics & Analytics tightly coupled for crash reporting.
