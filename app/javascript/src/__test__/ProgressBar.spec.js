import { shallowMount } from '@vue/test-utils'
import ProgressBar from '../components/ProgressBar'

describe('ProgressBar', () => {
  describe('props', () => {
    describe('when top is 0', () => {
      it('should show only steps bar', () => {
        const wrapper = shallowMount(ProgressBar, {
          props: {
            top: 0,
            bottom: 10
          }
        })

        expect(wrapper.find(`[data-test-id="Progress"]`).exists()).toBe(false)
        expect(wrapper.find(`[data-test-id="Steps"]`).exists()).toBe(true)
      })
    })

    describe('when top is NOT 0 and top is smaller than bottom', () => {
      const wrapper = shallowMount(ProgressBar, {
        props: {
          top: 3,
          bottom: 10
        }
      })

      it('should show only progress bar', () => {
        expect(wrapper.find(`[data-test-id="Progress"]`).exists()).toBe(true)
        expect(wrapper.find(`[data-test-id="Steps"]`).exists()).toBe(false)
      })

      it('should calculate progress by top/bottom', () => {
        expect(
          wrapper.get(`[data-test-id="Progress"]`).attributes().style
        ).toContain('width: 30%') // 3 / 10 * 100 = 30%
      })
    })

    describe('when top is bottom', () => {
      const wrapper = shallowMount(ProgressBar, {
        props: {
          top: 10,
          bottom: 10
        }
      })

      it('should show only progress bar', () => {
        expect(wrapper.find(`[data-test-id="Progress"]`).exists()).toBe(true)
        expect(wrapper.find(`[data-test-id="Steps"]`).exists()).toBe(false)
      })

      it('should calculate progress by top/bottom, and its result is 100%', () => {
        expect(
          wrapper.get(`[data-test-id="Progress"]`).attributes().style
        ).toContain('width: 100%') // 10 / 10 * 100 = 100%
      })
    })
  })
})
