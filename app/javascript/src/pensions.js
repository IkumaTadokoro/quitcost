import { createApp } from 'vue'
import Pensions from './components/Pensions.vue'

document.addEventListener('DOMContentLoaded', () => {
  const selector = '#js-pensions'
  const pensions = document.querySelector(selector)
  if (pensions) {
    const app = createApp(Pensions)
    app.mount(selector)
  }
})
