module.exports = {
  content: [
    './app/views/**/*.html.slim',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/javascript/**/*.vue'
  ],
  theme: {
    extend: {
      colors: {
        primary: '#117766',
        secondary: '#DFEEE5',
        accent: '#FFB600',
        black: '#1B322F',
        gray: '#858585',
        boundaryBlack: 'rgba(27, 50, 47, 0.16)'
      },
      fontFamily: {
        notojp: ['Noto Sans JP']
      }
    }
  },
  plugins: []
}
