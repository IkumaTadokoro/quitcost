import { createApp } from 'vue'
import App from './App.vue'
import Maska from 'maska'
import router from './router.js'
import globalStore, { GlobalStoreKey } from './store/global'

document.addEventListener('DOMContentLoaded', () => {
  const selector = '#js-simulation'
  const simulation = document.querySelector(selector)
  if (simulation) {
    const app = createApp(App)
    app.use(Maska)
    app.use(router)
    app.provide(GlobalStoreKey, globalStore())
    app.mount(selector)
  }
})
