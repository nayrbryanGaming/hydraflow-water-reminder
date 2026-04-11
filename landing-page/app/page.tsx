import React from 'react';
import { Droplet, Bell, Target, TrendingUp, Award, Smartphone } from 'lucide-react';
import './globals.css';

export default function Page() {
  return (
    <div className="min-h-screen">
      {/* Navigation */}
      <nav className="container mx-auto px-6 py-4 flex justify-between items-center">
        <div className="flex items-center space-x-2">
          <div className="w-10 h-10 bg-primary rounded-full flex items-center justify-center">
            <Droplet className="text-white" size={24} />
          </div>
          <span className="text-xl font-bold">HydraFlow</span>
        </div>
        <div className="hidden md:flex space-x-8">
          <a href="#features" className="text-gray-600 hover:text-primary">Features</a>
          <a href="#how-it-works" className="text-gray-600 hover:text-primary">How it Works</a>
          <a href="#pricing" className="text-gray-600 hover:text-primary">Pricing</a>
        </div>
        <button className="bg-primary text-white px-6 py-2 rounded-full font-semibold hover:bg-blue-600 transition">
          Download App
        </button>
      </nav>

      {/* Hero Section */}
      <section className="container mx-auto px-6 pt-20 pb-32 text-center">
        <h1 className="text-5xl md:text-7xl font-extrabold text-transparent bg-clip-text bg-gradient-to-r from-primary to-secondary mb-8">
          Stay Hydrated.<br/>Stay Focused.
        </h1>
        <p className="text-xl text-gray-600 mb-10 max-w-2xl mx-auto">
          HydraFlow helps you build a healthy hydration habit with intelligent reminders, personalized goals, and simple tracking.
        </p>
        <div className="flex flex-col sm:flex-row justify-center space-y-4 sm:space-y-0 sm:space-x-4">
          <button className="bg-dark text-white px-8 py-4 rounded-xl font-semibold flex items-center justify-center hover:bg-gray-800 transition">
            <Smartphone className="mr-2" size={24} /> App Store
          </button>
          <button className="bg-primary text-white px-8 py-4 rounded-xl font-semibold flex items-center justify-center hover:bg-blue-600 transition">
            <Smartphone className="mr-2" size={24} /> Google Play
          </button>
        </div>
      </section>

      {/* Features Section */}
      <section id="features" className="bg-white py-24">
        <div className="container mx-auto px-6">
          <div className="text-center mb-16">
            <h2 className="text-3xl md:text-4xl font-bold mb-4">Why choose HydraFlow?</h2>
            <p className="text-gray-600">Built differently to help you actually form a habit.</p>
          </div>
          <div className="grid md:grid-cols-3 gap-12">
            <FeatureCard 
              icon={<Bell className="text-primary" size={32} />}
              title="Smart Reminders"
              desc="Adaptive notifications that learn your schedule and remind you at the perfect time."
            />
            <FeatureCard 
              icon={<Target className="text-accent" size={32} />}
              title="Personalized Goals"
              desc="We calculate your ideal water intake based on weight, activity, and climate."
            />
            <FeatureCard 
              icon={<Award className="text-secondary" size={32} />}
              title="Gamified Streaks"
              desc="Build a lasting habit by unlocking achievements and maintaining daily streaks."
            />
          </div>
        </div>
      </section>

      {/* CTA Section */}
      <section className="bg-gradient-to-r from-primary to-secondary py-24 text-white text-center">
        <div className="container mx-auto px-6">
          <h2 className="text-4xl font-bold mb-8">Ready to upgrade your hydration?</h2>
          <button className="bg-white text-primary px-10 py-4 rounded-full font-bold text-lg hover:shadow-lg transition">
            Download HydraFlow Free
          </button>
        </div>
      </section>

      {/* Footer */}
      <footer className="bg-dark text-gray-400 py-12">
        <div className="container mx-auto px-6 flex flex-col md:flex-row justify-between items-center">
          <div className="flex items-center space-x-2 mb-4 md:mb-0">
            <Droplet className="text-white" size={24} />
            <span className="text-xl font-bold text-white">HydraFlow</span>
          </div>
          <div className="flex space-x-6 text-sm">
            <a href="/privacy" className="hover:text-white">Privacy Policy</a>
            <a href="/terms" className="hover:text-white">Terms of Service</a>
            <a href="/contact" className="hover:text-white">Contact Us</a>
          </div>
        </div>
      </footer>
    </div>
  );
}

function FeatureCard({ icon, title, desc }: { icon: React.ReactNode, title: string, desc: string }) {
  return (
    <div className="p-8 rounded-2xl bg-gray-50 hover:shadow-xl transition duration-300 border border-gray-100">
      <div className="mb-6 bg-white w-16 h-16 rounded-xl flex items-center justify-center shadow-sm">
        {icon}
      </div>
      <h3 className="text-xl font-bold mb-3">{title}</h3>
      <p className="text-gray-600 leading-relaxed">{desc}</p>
    </div>
  );
}
