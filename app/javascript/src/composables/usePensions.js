import { ref } from 'vue'

export const usePensions = () => {
  const pensions = ref([])
  const totalPages = ref(0)

  const getPensions = async (query) => {
    const pensionsAPI = `/api/pensions.json?${query}`
    const response = await fetch(pensionsAPI, {
      method: 'GET',
      headers: { 'X-Requested-With': 'XMLHttpRequest' },
      credentials: 'same-origin',
      redirect: 'manual'
    })
    const json = await response
      .json()
      .catch((e) => console.warn('Failed to parsing', e))
    pensions.value = json.pensions
    totalPages.value = parseInt(json.totalPages)
  }

  const token = () => {
    const meta = document.querySelector('meta[name="csrf-token"]')
    return meta ? meta.getAttribute('content') : ''
  }

  const deletePension = async (pensionId) => {
    const pensionAPI = `/api/pensions/${pensionId}`
    await fetch(pensionAPI, {
      method: 'DELETE',
      headers: {
        'X-Requested-With': 'XMLHttpRequest',
        'X-CSRF-Token': token()
      },
      credentials: 'same-origin',
      redirect: 'manual'
    })
  }

  return {
    pensions,
    totalPages,
    getPensions,
    deletePension
  }
}
