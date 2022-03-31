import { createRouter, createWebHistory } from 'vue-router'
import globalStore from '../store/global'
import SimulationForm from '../components/SimulationForm'

const router = createRouter({
  history: createWebHistory(),
  routes: [
    { path: '/', component: () => import('../components/Home') },
    {
      path: '/:pathMatch(.*)*',
      component: () => import('../components/NotFound')
    },
    {
      path: '/simulations/new',
      component: SimulationForm,
      redirect: '/simulations/new/retirement-month',
      children: [
        {
          path: 'retirement-month',
          name: 'RetirementMonth',
          component: () =>
            import('../components/simulation_form/RetirementMonth.vue'),
          meta: { title: '退職予定月' }
        },
        {
          path: 'employment-month',
          name: 'EmploymentMonth',
          component: () =>
            import('../components/simulation_form/EmploymentMonth.vue'),
          meta: { title: '転職予定月' }
        },
        {
          path: 'age',
          name: 'Age',
          component: () => import('../components/simulation_form/Age'),
          meta: { title: '年齢' }
        },
        {
          path: 'postal-code',
          name: 'PostalCode',
          component: () => import('../components/simulation_form/PostalCode'),
          meta: { title: '郵便番号' }
        },
        {
          path: 'previous-salary',
          name: 'PreviousSalary',
          component: () =>
            import('../components/simulation_form/PreviousSalary'),
          meta: { title: '昨昨年度の所得' }
        },
        {
          path: 'previous-social-insurance',
          name: 'PreviousSocialInsurance',
          component: () =>
            import('../components/simulation_form/PreviousSocialInsurance'),
          meta: { title: '昨昨年度の社会保険料' }
        },
        {
          path: 'salary',
          name: 'Salary',
          component: () => import('../components/simulation_form/Salary'),
          meta: { title: '昨年度の所得' }
        },
        {
          path: 'social-insurance',
          name: 'SocialInsurance',
          component: () =>
            import('../components/simulation_form/SocialInsurance'),
          meta: { title: '昨年度の社会保険料' }
        },
        {
          path: 'scheduled-salary',
          name: 'ScheduledSalary',
          component: () =>
            import('../components/simulation_form/ScheduledSalary'),
          meta: { title: '今年度の所得' }
        },
        {
          path: 'scheduled-social-insurance',
          name: 'ScheduledSocialInsurance',
          component: () =>
            import('../components/simulation_form/ScheduledSocialInsurance'),
          meta: { title: '今年度の社会保険料' }
        }
      ]
    },
    {
      path: '/simulations',
      name: 'Result',
      component: () => import('../components/SimulationResult'),
      meta: { title: 'シミュレーション結果' }
    }
  ]
})

router.beforeEach((to, from, next) => {
  const { simulation } = globalStore()

  if (to.name === 'Result' && !simulation.isFinished) {
    router.push({ name: simulation.currentStep })
  } else if (
    !to.fullPath.indexOf('/simulations/new/') &&
    !simulation.accessibleRoute.includes(to.name)
  ) {
    router.push({ name: simulation.currentStep })
  } else {
    next()
  }
})

const DEFAULT_TITLE = 'quitcost'
const DEFAULT_DESCRIPTION =
  'quitcost | 「無職になったらいくらかかる？」をいますぐ計算！'

router.afterEach((to) => {
  const title = to.meta.title
    ? `${to.meta.title} | ${DEFAULT_TITLE}`
    : DEFAULT_TITLE
  const content = to.meta.description || DEFAULT_DESCRIPTION

  const ogTitle = document.querySelector("meta[property='og:title']")
  const description = document.querySelector("meta[name='description']")
  const ogDescription = document.querySelector(
    "meta[property='og:description']"
  )

  document.title = title
  if (ogTitle) ogTitle.setAttribute('content', title)
  if (description) description.setAttribute('content', content)
  if (ogDescription) description.setAttribute('content', content)
})

export default router
