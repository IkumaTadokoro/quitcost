import { createApp } from 'vue'
import App from './App.vue'
import Maska from 'maska'
import router from './router/router'
import globalStore, { GlobalStoreKey } from './store/global'
import * as Sentry from '@sentry/vue'
import { BrowserTracing } from '@sentry/tracing'

document.addEventListener('DOMContentLoaded', () => {
  const selector = '#app'
  const app = document.querySelector(selector)
  if (app) {
    const app = createApp(App)
    Sentry.init({
      app,
      dsn: process.env.SENTRY_DSN,
      integrations: [
        new BrowserTracing({
          routingInstrumentation: Sentry.vueRouterInstrumentation(router),
          tracingOrigins: ['localhost', 'my-site-url.com', /^\//]
        })
      ],
      // Set tracesSampleRate to 1.0 to capture 100%
      // of transactions for performance monitoring.
      // We recommend adjusting this value in production
      tracesSampleRate: 1.0
    })
    app.use(Maska)
    app.use(router)
    app.provide(GlobalStoreKey, globalStore())
    app.mount(selector)
  }
})
