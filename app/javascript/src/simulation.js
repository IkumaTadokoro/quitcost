import { createApp } from 'vue'
import App from './App.vue'
import Maska from 'maska'
import router from './router.js'

document.addEventListener('DOMContentLoaded', () => {
  const selector = '#js-simulation'
  const simulation = document.querySelector(selector)
  if (simulation) {
    const app = createApp(App)
    app.use(Maska)
    app.use(router)
    app.mount(selector)
  }
})
