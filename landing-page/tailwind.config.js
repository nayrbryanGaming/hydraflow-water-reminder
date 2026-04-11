/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./pages/**/*.{js,ts,jsx,tsx,mdx}",
    "./components/**/*.{js,ts,jsx,tsx,mdx}",
    "./app/**/*.{js,ts,jsx,tsx,mdx}",
  ],
  theme: {
    extend: {
      colors: {
        primary: "#2F80ED",
        secondary: "#56CCF2",
        accent: "#6FCF97",
        background: "#F9FBFF",
        dark: "#0A1628",
      },
    },
  },
  plugins: [],
};
