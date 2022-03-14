import { createApp } from 'vue'
import App from './App.vue'
import Maska from 'maska'
import router from './router/router'
import globalStore, { GlobalStoreKey } from './store/global'

document.addEventListener('DOMContentLoaded', () => {
  const selector = '#app'
  const app = document.querySelector(selector)
  if (app) {
    const app = createApp(App)
    app.use(Maska)
    app.use(router)
    app.provide(GlobalStoreKey, globalStore())
    app.mount(selector)
  }
})
