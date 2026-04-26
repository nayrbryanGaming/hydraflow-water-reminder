'use client';

import React from 'react';
import { Shield, ChevronLeft } from 'lucide-react';

export default function PrivacyPage() {
  return (
    <div className="min-h-screen bg-[#F9FBFF] text-[#1A1C1E] p-6 md:p-12">
      <div className="max-w-3xl mx-auto bg-white rounded-3xl p-8 md:p-12 shadow-xl border border-blue-50">
        <div className="flex items-center justify-between mb-12">
          <a href="/" className="flex items-center text-blue-600 hover:text-blue-700 font-medium group transition-all">
            <ChevronLeft className="mr-2 group-hover:-translate-x-1 transition-transform" />
            Back to Home
          </a>
          <Shield className="text-blue-500" size={32} />
        </div>

        <h1 className="text-4xl font-extrabold mb-8 tracking-tight">Privacy Policy</h1>
        <p className="text-gray-400 mb-8 font-medium italic">Effective Date: April 2026</p>

        <div className="prose prose-blue max-w-none space-y-8 text-gray-600 leading-relaxed">
          <section>
            <h2 className="text-2xl font-bold text-gray-800 mb-4">1. Data We Collect</h2>
            <p>
              To provide a personalized hydration experience, HydraFlow calculates your needs locally.
              <ul className="list-disc pl-6 mt-4 space-y-2">
                <li><strong>Personal Parameters</strong>: Weight, age, and activity level (stored strictly on your local device).</li>
                <li><strong>Usage Data</strong>: Water intake logs (time, amount, and type of beverage).</li>
                <li><strong>Data Location</strong>: All data is stored in the application's local sandbox on your physical hardware.</li>
              </ul>
            </p>
          </section>

          <section>
            <h2 className="text-2xl font-bold text-gray-800 mb-4">2. Data Usage</h2>
            <p>
              Your data is used strictly for identifying optimal hydration windows and calculating daily progress locally. 
              <strong>No data leaves your device.</strong> We do not track you across other apps or share your information with any third parties.
            </p>
          </section>

          <section>
            <h2 className="text-2xl font-bold text-gray-800 mb-4">3. Data Security & Sovereignty</h2>
            <p>
              HydraFlow is a <strong>100% offline application</strong>. We do not use Firebase, Google Cloud, or any remote servers for data storage. 
              Your data remains under your absolute control at all times.
            </p>
          </section>

          <section>
            <h2 className="text-2xl font-bold text-gray-800 mb-4">4. Data Deletion</h2>
            <p>
              Since all data is stored locally, deleting the application or using the "Reset All Data" function within the app will permanently and immediately erase all logs and profile data from your device. 
            </p>
          </section>

          <section>
            <h2 className="text-2xl font-bold text-gray-800 mb-4">5. Contact Information</h2>
            <p>
              For any privacy-related inquiries, please contact our Data Protection team at:
              <br />
              <strong className="text-gray-800">support@hydraflow.app</strong>
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
