import { computed, watchEffect } from 'vue'
import { useStorage } from '@vueuse/core'
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
      currentStep: 0
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
      return state.value.routes.length === state.value.currentStep + 1
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

    get parameter() {
      const formatDate = (date) => format(date, 'yyyy-MM-dd')
      const params = state.value.params
      const [prefecture, city] = params.address.split(' ')
      const parameter = new URLSearchParams({
        simulation_date: formatDate(new Date(params.simulationDate)),
        retirement_month: formatDate(new Date(`${params.retirementMonth}/1`)),
        employment_month: formatDate(new Date(`${params.employmentMonth}/1`)),
        age: params.age,
        prefecture,
        city,
        previous_salary: params.previousSalary,
        salary: params.salary,
        scheduled_salary: params.scheduledSalary,
        previous_social_insurance: params.previousSocialInsurance,
        social_insurance: params.socialInsurance,
        scheduled_social_insurance: params.scheduledSocialInsurance
      }).toString()

      return parameter
    },

    add_params(values) {
      state.value.params = {
        ...state.value.params,
        ...values
      }
    },

    reset() {
      state.value.params = { simulationDate: new Date() }
      state.value.routes = [...defaultRoute]
      state.value.currentStep = 0
    }
  }
}
