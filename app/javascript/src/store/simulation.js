import { computed, watchEffect } from 'vue'
import { useStorage } from '@vueuse/core'
import axios from 'axios'
import axiosJsonpAdapter from 'axios-jsonp'
import { format } from 'date-fns'
import { useFinancialYear } from '../composables/useFinancialYear'

export default function simulationStore() {
  const essentialRoute = [
    'RetirementMonth',
    'EmploymentMonth',
    'Age',
    'PostalCode'
  ]

  const previousRoute = ['PreviousSalary', 'PreviousSocialInsurance']

  const currentRoute = ['Salary', 'SocialInsurance']

  const scheduledRoute = ['ScheduledSalary', 'ScheduledSocialInsurance']

  const defaultRoute = [
    ...essentialRoute,
    ...previousRoute,
    ...currentRoute,
    ...scheduledRoute
  ]

  const state = useStorage(
    'State',
    {
      params: {
        simulationDate: new Date()
      },
      routes: [...defaultRoute],
      currentStep: 0,
      loading: false,
      result: {}
    },
    sessionStorage
  )

  watchEffect(() => {
    const { simulationDate, retirementMonth, employmentMonth } =
      state.value.params

    if (!retirementMonth || !employmentMonth) return

    const base = new Date(simulationDate)
    const retirementMonthDate = new Date(retirementMonth)
    const employmentMonthDate = new Date(employmentMonth)

    const {
      beginningOfYear: previousBreak,
      nextBeginningOfYear: currentBreak
    } = useFinancialYear(base, 6, 4)
    const { nextBeginningOfYear: scheduledBreak } = useFinancialYear(base, 4, 4)

    const newRoute = [...essentialRoute]
    if (retirementMonthDate < previousBreak) newRoute.push(...previousRoute)
    if (retirementMonthDate < currentBreak) newRoute.push(...currentRoute)
    if (employmentMonthDate >= scheduledBreak) newRoute.push(...scheduledRoute)

    state.value.routes = newRoute
  })

  const searchAddress = async (params) => {
    const zipCode = params.postalCode.replace(/[^\d]+/g, '')
    if (!/^\d{7}$/.test(zipCode)) return
    const response = await axios.get(
      `https://api.zipaddress.net/?zipcode=${zipCode}`,
      { adapter: axiosJsonpAdapter }
    )

    return response.data
  }

  const formatDate = (date) => format(date, 'yyyy-MM-dd')

  const getResult = async () => {
    const params = state.value.params
    const address = await searchAddress(params)
    const parameter = new URLSearchParams({
      simulation_date: formatDate(new Date(params.simulationDate)),
      retirement_month: formatDate(new Date(`${params.retirementMonth}/1`)),
      employment_month: formatDate(new Date(`${params.employmentMonth}/1`)),
      age: params.age,
      prefecture: address.pref,
      city: address.city,
      previous_salary: params.previousSalary,
      salary: params.salary,
      scheduled_salary: params.scheduledSalary,
      previous_social_insurance: params.previousSocialInsurance,
      social_insurance: params.socialInsurance,
      scheduled_social_insurance: params.scheduledSocialInsurance
    }).toString()

    const simulationApi = `/api/simulations?${parameter}`
    const response = await fetch(simulationApi, {
      method: 'GET',
      headers: { 'X-Requested-With': 'XMLHttpRequest' },
      credentials: 'same-origin',
      redirect: 'manual'
    })
    const json = await response.json()
    return json.simulation
  }

  return {
    get params() {
      return state.value.params
    },

    get steps() {
      return state.value.routes.length
    },

    setCurrentStep(routeName) {
      state.value.currentStep = state.value.routes.includes(routeName)
        ? state.value.routes.indexOf(routeName)
        : 0
    },

    get currentStepIdx() {
      return state.value.currentStep
    },

    get currentStep() {
      return state.value.routes[state.value.currentStep]
    },

    get prevStep() {
      return computed(() =>
        state.value.currentStep !== 0
          ? state.value.routes[state.value.currentStep - 1]
          : null
      )
    },

    get nextStep() {
      return computed(() =>
        state.value.routes.length !== state.value.currentStep
          ? state.value.routes[state.value.currentStep + 1]
          : null
      )
    },

    get routes() {
      return state.value.routes
    },

    get isFinished() {
      return state.value.steps === state.value.currentStepIdx + 1
    },

    get accessibleRoute() {
      const camelizeAnswer = Object.keys(state.value.params).map(
        (route) => route[0].toUpperCase() + route.slice(1)
      )
      const completedRoute = camelizeAnswer.filter((route) =>
        state.value.routes.includes(route)
      )
      const lastStep = state.value.routes.indexOf(completedRoute.at(-1)) + 1
      const nextRoute = state.value.routes[lastStep]
      return [...completedRoute, nextRoute]
    },

    get result() {
      return state.value.result
    },

    get loading() {
      return state.value.loading
    },

    get numberOfStep() {
      return state.value.route.length
    },

    add_params(values) {
      state.value.params = {
        ...state.value.params,
        ...values
      }
    },

    reset() {
      state.value.params = { simulationDate: new Date() }
      state.value.result = {}
      state.value.routes = [...defaultRoute]
      state.value.currentStep = 0
    },

    async load_result() {
      state.value.loading = true
      try {
        state.value.result = await getResult()
      } finally {
        state.value.loading = false
      }
    }
  }
}
