import { mount } from '@vue/test-utils'
import App from '../App'
import router from '../router/router'
import globalStore, { GlobalStoreKey } from '../store/global'

describe('VueRouter', () => {
  it('render top page (Home.vue)', async () => {
    const wrapper = mount(App, {
      global: {
        plugins: [router],
        provide: {
          [GlobalStoreKey]: globalStore()
        }
      }
    })

    await router.isReady()

    expect(wrapper.html()).toContain(
      '転職準備のために仕事をやめたいけど、お金が心配...。'
    )
  })
})
