import { ref } from 'vue'

export const useInsurances = () => {
  const insurances = ref([])
  const totalPages = ref(0)

  const getInsurances = async (query) => {
    const insurancesAPI = `/api/admin/insurances.json?${query}`
    const response = await fetch(insurancesAPI, {
      method: 'GET',
      headers: { 'X-Requested-With': 'XMLHttpRequest' },
      credentials: 'same-origin',
      redirect: 'manual'
    })
    const json = await response
      .json()
      .catch((e) => console.warn('Failed to parsing', e))
    insurances.value = json.insurance
    totalPages.value = parseInt(json.totalPages)
  }

  const token = () => {
    const meta = document.querySelector('meta[name="csrf-token"]')
    return meta ? meta.getAttribute('content') : ''
  }

  const deleteInsurance = async (insuranceId) => {
    const insuranceAPI = `/api/admin/insurances/${insuranceId}`
    await fetch(insuranceAPI, {
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
    insurances,
    totalPages,
    getInsurances,
    deleteInsurance
  }
}
