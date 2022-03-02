import { useStorage } from '@vueuse/core'
import { computed } from 'vue'

export default function stepStore() {
  const state = useStorage('Step', 0, sessionStorage)

  return {
    get raw() {
      return state.value
    },

    get current() {
      return computed(() => state.value + 1).value
    },

    get hasPrevious() {
      return computed(() => state.value > 0).value
    },

    increment() {
      state.value++
    },

    decrement() {
      state.value--
    },

    reset() {
      state.value = 0
    }
  }
}
