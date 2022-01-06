import { createApp } from 'vue'
import Insurances from './insurances.vue'

document.addEventListener('DOMContentLoaded', () => {
  const selector = '#js-insurances'
  const insurances = document.querySelector(selector)
  if (insurances) {
    const app = createApp(Insurances)
    app.mount(selector)
  }
})
