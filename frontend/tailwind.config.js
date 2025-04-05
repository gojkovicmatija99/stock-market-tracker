/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        'tradingview': {
          'bg': '#131722',
          'panel': '#1e222d',
          'border': '#363a45',
          'text': '#d1d4dc',
        }
      }
    },
  },
  plugins: [],
} 