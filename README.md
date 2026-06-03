# HydraFlow: Smart Hydration Habit Builder

**Stay Hydrated. Stay Focused. Built with clinical-standard, 100% offline-first intelligence.**

[![Live Demo](https://img.shields.io/badge/Live-Demo-2F80ED?style=for-the-badge)](https://hydraflow-water-reminder.vercel.app)
[![Google Play](https://img.shields.io/badge/Google_Play-Production-6FCF97?style=for-the-badge)](https://play.google.com/store/apps/details?id=com.nayrbryan.hydraflow)

---

## 1. One-Liner
HydraFlow is a premium, data-sovereign wellness application that optimizes cognitive focus through biometric-calibrated hydration and deterministic local scheduling.

## 2. Problem
Modern users suffer from "Hydration Debt" caused by:
- **Privacy Leakage**: Sensitive biometrics (weight, age) being synced to untrusted cloud servers.
- **Latency Friction**: Sluggish UX caused by reliance on remote databases (Firebase/Firestore).
- **Generic Algorithms**: Water goals that ignore environmental heat and daily activity levels.

## 3. Solution
HydraFlow provides a **Zero-Trust, Zero-Latency** hydration experience:
- **Local Sovereignty**: 100% On-Device persistence using high-performance Hive NoSQL.
- **Scientific Calibration**: Targets calculated via NAM (National Academies of Medicine) and WHO standards.
- **Behavioral Design**: Liquid-physics inspired UI with adaptive reminder nudges.

## 4. Why HydraFlow?
- **100% Offline**: No Firebase. No Analytics. No Cloud. Zero data exit, guaranteed.
- **Premium Aesthetics**: Vibrant gradients, glassmorphism, and smooth physics-based animations.
- **Intelligent Nudges**: Adaptive engine that respects "Quiet Hours" and adapts to your intake velocity.

## 5. Architecture
Built with **Clean Architecture** and a **Deterministic State Container**:
- **Framework**: Flutter (Dart)
- **State Management**: Riverpod (Reactive Logic)
- **Persistence**: Hive (Local NoSQL Time-Series)
- **Routing**: Typed Navigation via GoRouter
- **Localization**: 100% Isolated English & Indonesian Logic

## 6. What's Built
- **Clinical Assessment**: Scientific onboarding to establish biological fluid baselines.
- **Interactive Dashboard**: Real-time progress with animated liquid wave physics.
- **Analytics Hub**: Weekly velocity trends and habit consistency ranking.
- **Smart Reminders**: Local notification engine with interval tuning.
- **Data Portability**: Full secure JSON export and instant local erasure.

## 7. Team
- **Chief AI Architect**: HydraFlow Core Team
- **Production Auditor**: Antigravity (Advanced AI Hardening)

## 8. Quick Start
```bash
# Clone the repository
git clone https://github.com/nayrbryanGaming/hydraflow-water-reminder.git

# Navigate to the mobile app
cd mobile && flutter pub get

# Generate local adapters and run
flutter pub run build_runner build --delete-conflicting-outputs
flutter run --release
```

---
*HydraFlow is a wellness habit builder and does not replace professional medical advice.*
