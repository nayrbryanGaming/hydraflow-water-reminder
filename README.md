# HydraFlow: Smart Hydration Habit Builder
**Build healthy hydration habits with a clinical-standard, 100% offline-first intelligent reminder system.**

[![Live Demo](https://img.shields.io/badge/Live-Demo-2F80ED?style=for-the-badge)](https://hydraflow-water-reminder.vercel.app)
[![Google Play](https://img.shields.io/badge/Google_Play-Production-6FCF97?style=for-the-badge)](https://play.google.com/store/apps/details?id=com.nayrbryan.hydraflow)

---

## 1. One-Liner
HydraFlow is a premium, data-sovereign wellness application that optimizes fluid intake through biometric calibration and deterministic local notification scheduling.

## 2. Problem
Most hydration trackers suffer from:
- **Privacy Leakage**: Personal biometrics (weight, age) are synced to cloud servers.
- **Latency**: Reliance on remote databases (like Firebase) leads to sluggish "offline" behavior and sync errors.
- **Generic Targets**: Arbitrary water goals that ignore environmental and activity factors.

## 3. Solution
HydraFlow provides a 100% On-Device solution:
- **Local Sovereignty**: All data is stored in high-performance NoSQL (Hive) locally on your device.
- **Scientific Calibration**: Targets are calculated using NAM (National Academies of Medicine) and WHO population standards.
- **Zero-Latency UX**: Immediate feedback and logging without any network requests.

## 4. Why HydraFlow?
- **100% Offline**: No Firebase, no analytics, no external tracking. Zero data exit.
- **Premium Aesthetics**: A liquid-physics inspired UI with high-contrast dynamic themes.
- **Intelligent Nudges**: Adaptive reminder engine that respects your "Quiet Hours" and activity levels.

## 5. Architecture
Built with **Clean Architecture** principles using the Flutter framework:
- **Core**: Deterministic state management with Riverpod.
- **Persistence**: Hive (Local NoSQL) for time-series logs and biometric profiles.
- **Routing**: Typed navigation using GoRouter.
- **Theming**: Dynamic Material 3 design system with specialized contrast hardening.

## 6. What's Built
- **Clinical Assessment**: Scientific onboarding to establish biological baselines.
- **Interactive Dashboard**: Real-time progress tracking with animated wave physics.
- **Analytics Hub**: Weekly velocity trends and habit consistency statistics.
- **Smart Reminders**: Local notification engine with interval tuning and behavior adaptation.
- **Bilingual Core**: 100% separated English and Indonesian localization.

## 7. Team
- **Chief Architect**: nayrbryanGaming
- **Production Auditor**: Antigravity (Advanced AI Hardening System)

## 8. Quick Start
```bash
git clone https://github.com/nayrbryanGaming/hydraflow-water-reminder.git
cd mobile && flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run --release
```

---
*HydraFlow is a wellness habit builder and does not replace professional medical advice.*
