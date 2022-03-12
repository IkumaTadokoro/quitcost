import { inject } from 'vue'
import simulationStore from './simulation'

export default function globalStore() {
  return {
    simulation: simulationStore()
  }
}

export const GlobalStoreKey = 'GlobalStore'

export function useGlobalStore() {
  const store = inject(GlobalStoreKey)
  if (!store) {
    throw new Error(`${GlobalStoreKey} is not provided`)
  }
  return store
}
