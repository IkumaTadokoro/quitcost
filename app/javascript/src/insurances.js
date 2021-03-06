import { createApp } from 'vue'
import Insurances from './components/Insurances.vue'

document.addEventListener('DOMContentLoaded', () => {
  const selector = '#js-insurances'
  const insurances = document.querySelector(selector)
  if (insurances) {
    const app = createApp(Insurances)
    app.mount(selector)
  }
})
