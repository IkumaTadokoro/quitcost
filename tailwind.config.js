module.exports = {
  content: [
    './app/views/**/*.html.slim',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/javascript/**/*.vue'
  ],
  theme: {
    extend: {
      fontFamily: {
        notojp: ['Noto Sans JP']
      }
    }
  },
  plugins: []
}
