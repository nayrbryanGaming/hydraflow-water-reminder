export const metadata = {
  title: 'HydraFlow | Smart Hydration Habit Builder',
  description: 'HydraFlow helps you build a healthy hydration habit with intelligent reminders, personalized hydration goals, and simple tracking.',
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body className="bg-background text-dark">{children}</body>
    </html>
  );
}
