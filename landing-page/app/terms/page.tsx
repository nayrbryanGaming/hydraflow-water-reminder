'use client';

import React from 'react';
import { FileText, ChevronLeft } from 'lucide-react';

export default function TermsPage() {
  return (
    <div className="min-h-screen bg-[#F9FBFF] text-[#1A1C1E] p-6 md:p-12">
      <div className="max-w-3xl mx-auto bg-white rounded-3xl p-8 md:p-12 shadow-xl border border-blue-50">
        <div className="flex items-center justify-between mb-12">
          <a href="/" className="flex items-center text-blue-600 hover:text-blue-700 font-medium group transition-all">
            <ChevronLeft className="mr-2 group-hover:-translate-x-1 transition-transform" />
            Back to Home
          </a>
          <FileText className="text-blue-500" size={32} />
        </div>

        <h1 className="text-4xl font-extrabold mb-8 tracking-tight">Terms of Service</h1>
        <p className="text-gray-400 mb-8 font-medium italic">Effective Date: April 2026</p>

        <div className="prose prose-blue max-w-none space-y-8 text-gray-600 leading-relaxed">
          <section>
            <h2 className="text-2xl font-bold text-gray-800 mb-4">1. Acceptance of Terms</h2>
            <p>
              By downloading or using HydraFlow, these terms will automatically apply to you. You should make sure therefore that you read them carefully before using the app.
            </p>
          </section>

          <section>
            <h2 className="text-2xl font-bold text-gray-800 mb-4">2. Health Disclaimer</h2>
            <p className="bg-blue-50 p-4 rounded-xl border border-blue-100">
              <strong>HydraFlow is NOT a medical application.</strong> The calculations for hydration goals are based on standard health models for healthy individuals and should not replace professional medical advice. If you have medical conditions (e.g., kidney issues), consult a doctor before following app recommendations.
            </p>
          </section>

          <section>
            <h2 className="text-2xl font-bold text-gray-800 mb-4">3. Subscriptions</h2>
            <p>
              Premium features are available via auto-renewing subscriptions managed through Google Play Store. You may cancel at any time via your Play Store account settings.
            </p>
          </section>

          <section>
            <h2 className="text-2xl font-bold text-gray-800 mb-4">4. User Conduct</h2>
            <p>
              You agree not to use the app in any way that causes interruption or damage to the app's functionality or security integrity.
            </p>
          </section>

          <section>
            <h2 className="text-2xl font-bold text-gray-800 mb-4">5. Limitation of Liability</h2>
            <p>
              In no event shall HydraFlow, nor its developers, be liable for any indirect, consequential, or incidental injuries or damages arising out of your use of the application.
            </p>
          </section>
        </div>

        <div className="mt-16 pt-8 border-t border-gray-100 text-center">
          <p className="text-gray-400 text-sm">© 2026 HydraFlow. All rights reserved.</p>
        </div>
      </div>
    </div>
  );
}
