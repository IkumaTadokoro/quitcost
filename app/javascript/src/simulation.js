import { createApp } from 'vue'
import SimulationForm from './simulation_form.vue'

document.addEventListener('DOMContentLoaded', () => {
  const selector = '#js-simulation'
  const simulation = document.querySelector(selector)
  if (simulation) {
    const app = createApp(SimulationForm)
    app.mount(selector)
  }
})
