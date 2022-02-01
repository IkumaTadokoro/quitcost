import { createApp } from 'vue'
import Pentions from './pentions.vue'

document.addEventListener('DOMContentLoaded', () => {
  const selector = '#js-pentions'
  const pentions = document.querySelector(selector)
  if (pentions) {
    const app = createApp(Pentions)
    app.mount(selector)
  }
})
