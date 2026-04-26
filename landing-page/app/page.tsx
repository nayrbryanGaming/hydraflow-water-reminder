import React from 'react';
import { Droplet, Bell, Target, TrendingUp, Award, Smartphone, Shield, Zap } from 'lucide-react';
import './globals.css';

export default function Page() {
  return (
    <div className="min-h-screen bg-dark text-white selection:bg-secondary selection:text-dark">
      {/* Abstract Background Elements */}
      <div className="fixed inset-0 overflow-hidden pointer-events-none z-0">
        <div className="absolute -top-[10%] -left-[10%] w-[50%] h-[50%] rounded-full bg-primary/20 blur-[120px]" />
        <div className="absolute top-[40%] -right-[10%] w-[40%] h-[40%] rounded-full bg-secondary/20 blur-[100px]" />
        <div className="absolute -bottom-[20%] left-[20%] w-[60%] h-[60%] rounded-full bg-accent/10 blur-[150px]" />
      </div>

      <div className="relative z-10">
        {/* Navigation */}
        <nav className="container mx-auto px-6 py-6 flex justify-between items-center">
          <div className="flex items-center space-x-3 group cursor-pointer">
            <div className="w-12 h-12 bg-gradient-to-br from-primary to-secondary rounded-2xl flex items-center justify-center shadow-lg shadow-primary/30 group-hover:scale-105 transition-transform duration-300">
              <Droplet className="text-white" size={26} strokeWidth={2.5} />
            </div>
            <span className="text-2xl font-bold tracking-tight bg-clip-text text-transparent bg-gradient-to-r from-white to-gray-300">
              HydraFlow
            </span>
          </div>
          <div className="hidden md:flex space-x-10">
            <a href="#features" className="text-gray-300 hover:text-white font-medium transition-colors">Features</a>
            <a href="#how-it-works" className="text-gray-300 hover:text-white font-medium transition-colors">How it Works</a>
            <a href="#pricing" className="text-gray-300 hover:text-white font-medium transition-colors">Pricing</a>
          </div>
          <button className="bg-white/10 hover:bg-white/20 backdrop-blur-md border border-white/10 text-white px-8 py-3 rounded-full font-semibold transition-all hover:scale-105">
            Get the App
          </button>
        </nav>

        {/* Hero Section */}
        <section className="container mx-auto px-6 pt-32 pb-40 text-center">
          <div className="inline-flex items-center space-x-2 bg-white/5 border border-white/10 rounded-full px-4 py-2 mb-8 backdrop-blur-sm">
            <span className="flex h-2 w-2 rounded-full bg-accent animate-pulse" />
            <span className="text-sm font-medium text-gray-300">Now available on iOS & Android</span>
          </div>
          <h1 className="text-6xl md:text-8xl font-extrabold tracking-tight mb-8">
            Stay Hydrated.
            <br />
            <span className="text-transparent bg-clip-text bg-gradient-to-r from-primary via-secondary to-accent">
              Stay Focused.
            </span>
          </h1>
          <p className="text-xl md:text-2xl text-gray-400 mb-12 max-w-3xl mx-auto leading-relaxed">
            Experience the future of hydration tracking. **100% Offline-First.** Your biometrics and logs stay on your device, giving you total data sovereignty and zero-latency performance.
          </p>
          <div className="flex flex-col sm:flex-row justify-center space-y-4 sm:space-y-0 sm:space-x-6">
            <button className="group bg-white text-dark px-8 py-5 rounded-2xl font-bold flex items-center justify-center hover:bg-gray-100 transition-all hover:scale-105 shadow-[0_0_40px_-10px_rgba(255,255,255,0.3)]">
              <Smartphone className="mr-3 group-hover:-rotate-12 transition-transform" size={24} /> 
              Download for iOS
            </button>
            <button className="group bg-white/10 backdrop-blur-md border border-white/10 text-white px-8 py-5 rounded-2xl font-bold flex items-center justify-center hover:bg-white/20 transition-all hover:scale-105">
              <Smartphone className="mr-3 group-hover:rotate-12 transition-transform" size={24} /> 
              Download for Android
            </button>
          </div>
        </section>

        {/* Clinical Integrity Section */}
        <section id="clinical" className="py-24 bg-primary/5 border-y border-white/5">
          <div className="container mx-auto px-6">
            <div className="flex flex-col md:flex-row items-center gap-16">
              <div className="flex-1">
                <div className="inline-flex items-center space-x-2 bg-accent/10 border border-accent/20 rounded-full px-4 py-2 mb-6">
                  <Shield className="text-accent" size={16} />
                  <span className="text-sm font-bold text-accent uppercase tracking-wider">Clinical Standards</span>
                </div>
                <h2 className="text-4xl md:text-5xl font-bold mb-8 leading-tight">
                  Built on Global 
                  <br />
                  <span className="text-accent">Health Guidelines.</span>
                </h2>
                <p className="text-xl text-gray-400 mb-8 leading-relaxed">
                  HydraFlow doesn't guess. Our algorithm is calibrated against the **National Academies of Medicine (NAM)** and **WHO** standards, adjusting for your unique biology without ever sending data to the cloud.
                </p>
                <div className="space-y-4">
                  {[
                    "Personalized Metabolic Calculations",
                    "Adaptive Environmental Scaling",
                    "Zero External Data Exposure",
                    "Medical-Grade Transparency"
                  ].map((item, i) => (
                    <div key={i} className="flex items-center space-x-3">
                      <div className="w-5 h-5 rounded-full bg-accent/20 flex items-center justify-center">
                        <div className="w-2 h-2 rounded-full bg-accent" />
                      </div>
                      <span className="font-semibold text-gray-200">{item}</span>
                    </div>
                  ))}
                </div>
              </div>
              <div className="flex-1 relative">
                <div className="aspect-square bg-gradient-to-br from-primary/30 to-secondary/30 rounded-[4rem] flex items-center justify-center border border-white/10 overflow-hidden group">
                  <div className="absolute inset-0 bg-[url('/grid.svg')] opacity-20" />
                  <Droplet size={180} className="text-white drop-shadow-[0_0_50px_rgba(255,255,255,0.4)] group-hover:scale-110 transition-transform duration-700" />
                </div>
              </div>
            </div>
          </div>
        </section>
        {/* Features Section */}
        <section id="features" className="py-32 relative">
          <div className="container mx-auto px-6">
            <div className="text-center mb-24">
              <h2 className="text-4xl md:text-5xl font-bold mb-6">Engineered for Habit Building</h2>
              <p className="text-xl text-gray-400 max-w-2xl mx-auto">Not just another reminder app. We use behavioral science to ensure you actually drink more water.</p>
            </div>
            <div className="grid md:grid-cols-3 gap-8">
              <FeatureCard 
                icon={<Zap className="text-primary" size={32} />}
                title="Liquid Physics UI"
                desc="Experience the most tactile interface in health tech. Interactive waves and rising particles that respond to your touch."
                gradient="from-primary/20 to-transparent"
              />
              <FeatureCard 
                icon={<Target className="text-accent" size={32} />}
                title="Behavioral Insights"
                desc="Dynamic health wisdom and science-backed tips integrated directly into your dashboard to build lasting habits."
                gradient="from-accent/20 to-transparent"
              />
              <FeatureCard 
                icon={<Award className="text-secondary" size={32} />}
                title="Smart Reminder AI"
                desc="Adaptive notifications that calculate your optimal hydration windows based on activity, climate, and goal progress."
                gradient="from-secondary/20 to-transparent"
              />
            </div>
          </div>
        </section>



        {/* Testimonials Section */}
        <section className="py-32 bg-white/5 relative">
          <div className="container mx-auto px-6">
            <div className="flex flex-col md:flex-row items-end justify-between mb-16">
              <div className="max-w-2xl">
                <h2 className="text-4xl md:text-5xl font-bold mb-6">Loved by Productivity Experts</h2>
                <p className="text-xl text-gray-400">Join over 100,000+ users who have transformed their cognitive performance through better hydration.</p>
              </div>
            </div>
            <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-8">
              <TestimonialCard 
                name="Sarah Jenkins"
                role="Senior Developer"
                content="HydraFlow's smart reminders actually work. They don't spam me; they nudge me right when I'm losing focus. Game changer for my deep work sessions."
                avatar="/images/avatar_sarah.png"
              />
              <TestimonialCard 
                name="Dr. Michael Chen"
                role="Wellness Consultant"
                content="The clinical integrity of this app is impressed. Most apps ignore medical conditions; HydraFlow's upfront disclaimers and goal logic are top-notch."
                avatar="/images/avatar_michael.png"
              />
              <TestimonialCard 
                name="Emma Wilson"
                role="Student"
                content="I used to forget to drink all day during finals. The streaks and ranks made it feel like a game. I'm finally a 'Hydration God'!"
                avatar="/images/avatar_emma.png"
              />
            </div>
          </div>
        </section>
        <section className="py-24">
          <div className="container mx-auto px-6">
            <div className="bg-gradient-to-br from-primary via-blue-600 to-dark p-12 md:p-20 rounded-3xl relative overflow-hidden border border-white/10 shadow-2xl shadow-primary/20">
              <div className="absolute top-0 right-0 w-96 h-96 bg-white/10 rounded-full blur-[100px]" />
              <div className="relative z-10 flex flex-col md:flex-row items-center justify-between">
                <div className="mb-10 md:mb-0 md:pr-10">
                  <h2 className="text-4xl md:text-5xl font-bold mb-6 text-white">Upgrade your health today.</h2>
                  <p className="text-xl text-blue-100 max-w-xl">Join thousands of health-conscious users who have boosted their energy and focus with HydraFlow.</p>
                </div>
                <button className="bg-white text-primary px-10 py-5 rounded-2xl font-bold text-lg hover:scale-105 transition-transform shadow-xl flex-shrink-0">
                  Get Started Free
                </button>
              </div>
            </div>
          </div>
        </section>

        {/* Footer */}
        <footer className="border-t border-white/10 bg-dark/80 pt-20 pb-8 backdrop-blur-lg mt-20">
          <div className="container mx-auto px-6">
            <div className="grid md:grid-cols-4 gap-12 mb-16">
              {/* Brand */}
              <div className="col-span-1">
                <div className="flex items-center space-x-3 mb-4">
                  <div className="w-10 h-10 bg-primary/20 rounded-xl flex items-center justify-center border border-primary/30">
                    <Droplet className="text-primary" size={20} />
                  </div>
                  <span className="text-xl font-bold text-white tracking-tight">HydraFlow</span>
                </div>
                <p className="text-gray-500 text-sm leading-relaxed">
                  Smart hydration habit builder powered by intelligent reminders and behavioral science.
                </p>
              </div>

              {/* Product */}
              <div>
                <h4 className="text-white font-semibold mb-4">Product</h4>
                <ul className="space-y-3 text-sm">
                  <li><a href="#features" className="text-gray-400 hover:text-white transition-colors">Features</a></li>
                  <li><a href="#pricing" className="text-gray-400 hover:text-white transition-colors">Pricing</a></li>
                  <li><a href="#" className="text-gray-400 hover:text-white transition-colors">Changelog</a></li>
                  <li><a href="#" className="text-gray-400 hover:text-white transition-colors">Roadmap</a></li>
                </ul>
              </div>

              {/* Legal */}
              <div>
                <h4 className="text-white font-semibold mb-4">Legal & Data</h4>
                <ul className="space-y-3 text-sm">
                  <li><a href="/privacy" className="text-gray-400 hover:text-white transition-colors">Privacy Policy</a></li>
                  <li><a href="/terms" className="text-gray-400 hover:text-white transition-colors">Terms of Service</a></li>
                  <li><a href="/disclaimer" className="text-gray-400 hover:text-white transition-colors">Medical Disclaimer</a></li>
                  <li>
                    <a href="/delete-account" className="text-red-400 hover:text-red-300 transition-colors font-semibold">
                      🗑️ Delete Account
                    </a>
                  </li>
                </ul>
              </div>

              {/* Support / Physical Presence */}
              <div>
                <h4 className="text-white font-semibold mb-4">Support</h4>
                <ul className="space-y-3 text-sm text-gray-400">
                  <li className="flex items-start space-x-2">
                    <Shield size={14} className="text-primary mt-0.5 flex-shrink-0" />
                    <span>support@hydraflow.app</span>
                  </li>
                  <li className="flex items-start space-x-2">
                    <Bell size={14} className="text-accent mt-0.5 flex-shrink-0" />
                    <span>Response within 48 hours</span>
                  </li>
                  <li className="flex items-start space-x-2">
                    <Zap size={14} className="text-secondary mt-0.5 flex-shrink-0" />
                    <span>Data requests processed within 30 days</span>
                  </li>
                </ul>
              </div>
            </div>

            <div className="border-t border-white/5 pt-8 flex flex-col md:flex-row justify-between items-center text-sm text-gray-600">
              <p>© 2026 HydraFlow. All rights reserved. Built with ❤️ for a more hydrated world.</p>
              <p className="mt-4 md:mt-0">Not a medical device. For informational use only.</p>
            </div>
          </div>
        </footer>
      </div>
    </div>
  );
}

function FeatureCard({ icon, title, desc, gradient }: { icon: React.ReactNode, title: string, desc: string, gradient: string }) {
  return (
    <div className={`p-10 rounded-3xl bg-white/5 border border-white/10 hover:bg-white/10 transition-all duration-500 relative overflow-hidden group hover:-translate-y-2`}>
      <div className={`absolute top-0 right-0 w-40 h-40 bg-gradient-to-bl ${gradient} rounded-full blur-3xl opacity-0 group-hover:opacity-100 transition-opacity duration-500`} />
      <div className="relative z-10">
        <div className="mb-8 w-16 h-16 rounded-2xl bg-white/10 border border-white/5 flex items-center justify-center backdrop-blur-md shadow-inner group-hover:scale-110 transition-transform duration-500">
          {icon}
        </div>
        <h3 className="text-2xl font-bold mb-4 text-white">{title}</h3>
        <p className="text-gray-400 leading-relaxed text-lg">{desc}</p>
      </div>
    </div>
  );
}
function TestimonialCard({ name, role, content, avatar }: { name: string, role: string, content: string, avatar: string }) {
  return (
    <div className="p-8 rounded-3xl bg-white/5 border border-white/10 hover:border-primary/30 transition-all duration-300 flex flex-col justify-between">
      <p className="text-gray-300 italic mb-8 leading-relaxed">"{content}"</p>
      <div className="flex items-center space-x-4">
        <img src={avatar} alt={name} className="w-12 h-12 rounded-full border-2 border-primary/20" />
        <div>
          <h4 className="font-bold text-white">{name}</h4>
          <p className="text-gray-500 text-sm">{role}</p>
        </div>
      </div>
    </div>
  );
}
