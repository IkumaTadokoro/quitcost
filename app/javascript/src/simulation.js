import { createApp } from 'vue'
import SimulationForm from './SimulationForm.vue'
import Maska from 'maska'

document.addEventListener('DOMContentLoaded', () => {
  const selector = '#js-simulation'
  const simulation = document.querySelector(selector)
  if (simulation) {
    const app = createApp(SimulationForm)
    app.use(Maska)
    app.mount(selector)
  }
})
