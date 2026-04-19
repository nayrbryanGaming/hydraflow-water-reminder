'use client';

import React, { useState } from 'react';

export default function DeleteAccountPage() {
  const [submitted, setSubmitted] = useState(false);

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    setSubmitted(true);
  };

  if (submitted) {
    return (
      <div className="min-h-screen bg-[#F9FBFF] flex flex-col items-center justify-center p-6 text-[#1A1C1E]">
        <div className="max-w-md w-full bg-white rounded-3xl p-10 shadow-xl border border-blue-50 text-center animate-in fade-in zoom-in duration-500">
          <div className="flex justify-center mb-8">
            <div className="w-20 h-20 bg-green-50 rounded-full flex items-center justify-center">
              <svg className="w-10 h-10 text-green-500" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="3" d="M5 13l4 4L19 7" />
              </svg>
            </div>
          </div>
          <h1 className="text-2xl font-bold mb-4">Request Received</h1>
          <p className="text-gray-500 mb-8">
            Your account deletion request for HydraFlow has been securely received and is being processed. 
            All your personal data, logs, and achievements will be purged within 30 days.
          </p>
          <a 
            href="/" 
            className="inline-block w-full bg-blue-600 text-white font-bold py-4 rounded-xl hover:bg-blue-700 transition-all shadow-lg shadow-blue-100"
          >
            RETURN HOME
          </a>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-[#F9FBFF] flex flex-col items-center justify-center p-6 text-[#1A1C1E]">
      <div className="max-w-md w-full bg-white rounded-3xl p-10 shadow-xl border border-blue-50">
        <div className="flex justify-center mb-8">
          <div className="w-20 h-20 bg-blue-50 rounded-full flex items-center justify-center">
            <svg className="w-10 h-10 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
            </svg>
          </div>
        </div>
        
        <h1 className="text-3xl font-bold text-center mb-4 tracking-tight">Delete Account</h1>
        <p className="text-gray-500 text-center mb-8 leading-relaxed">
          We're sorry to see you go. Please note that account deletion is <strong>permanent</strong> and will result in the loss of all your hydration logs, achievements, and settings.
        </p>

        <form onSubmit={handleSubmit} className="space-y-6">
          <div>
            <label htmlFor="email" className="block text-sm font-semibold text-gray-700 mb-2">Account Email Address</label>
            <input 
              type="email" 
              id="email" 
              required
              placeholder="your@email.com"
              className="w-full px-4 py-3 rounded-xl border border-gray-200 focus:ring-2 focus:ring-blue-500 focus:border-transparent outline-none transition-all"
            />
          </div>
          
          <div>
            <label htmlFor="reason" className="block text-sm font-semibold text-gray-700 mb-2">Reason for Deletion (Optional)</label>
            <textarea 
              id="reason" 
              placeholder="Tell us how we can improve..."
              className="w-full px-4 py-3 rounded-xl border border-gray-200 focus:ring-2 focus:ring-blue-500 focus:border-transparent outline-none transition-all h-24 resize-none"
            />
          </div>

          <div className="pt-4">
            <button 
              type="submit"
              className="w-full bg-red-500 text-white font-bold py-4 rounded-xl hover:bg-red-600 active:scale-[0.98] transition-all shadow-lg shadow-red-100"
            >
              REQUEST ACCOUNT DELETION
            </button>
          </div>
        </form>

        <div className="mt-8 pt-8 border-t border-gray-50 text-center">
          <p className="text-xs text-gray-400">
            Requests are processed within 30 days in accordance with our Privacy Policy.
          </p>
        </div>
      </div>
      
      <div className="mt-8">
        <a href="/" className="text-sm font-medium text-blue-600 hover:text-blue-700 flex items-center gap-2">
          <span>← Back to Landing Page</span>
        </a>
      </div>
    </div>
  );
}
