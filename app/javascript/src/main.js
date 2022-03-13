import { createApp } from 'vue'
import App from './App.vue'
import Maska from 'maska'
import index from './router'
import globalStore, { GlobalStoreKey } from './store/global'

document.addEventListener('DOMContentLoaded', () => {
  const selector = '#app'
  const app = document.querySelector(selector)
  if (app) {
    const app = createApp(App)
    app.use(Maska)
    app.use(index)
    app.provide(GlobalStoreKey, globalStore())
    app.mount(selector)
  }
})
