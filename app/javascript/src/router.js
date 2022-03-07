import { createRouter, createWebHistory } from 'vue-router'
import Home from './components/Home'
import SimulationForm from './SimulationForm'
import SimulationResult from './SimulationResult'
import RetirementMonth from './components//simulation_form/RetirementMonth.vue'
import EmploymentMonth from './components//simulation_form/EmploymentMonth.vue'
import Age from './components/simulation_form/Age'
import PostalCode from './components/simulation_form/PostalCode'
import Salary from './components/simulation_form/Salary'
import SocialInsurance from './components/simulation_form/SocialInsurance'
import ScheduledSalary from './components/simulation_form/ScheduledSalary'
import ScheduledSocialInsurance from './components/simulation_form/ScheduledSocialInsurance'

const router = createRouter({
  history: createWebHistory(),
  routes: [
    { path: '/', component: Home },
    {
      path: '/simulations/new',
      component: SimulationForm,
      redirect: '/simulations/new/1',
      children: [
        {
          path: '1',
          component: RetirementMonth,
          meta: { title: '退職予定月' }
        },
        {
          path: '2',
          component: EmploymentMonth,
          meta: { title: '転職予定月' }
        },
        { path: '3', component: Age, meta: { title: '年齢' } },
        { path: '4', component: PostalCode, meta: { title: '郵便番号' } },
        { path: '5', component: Salary, meta: { title: '昨年度の所得' } },
        {
          path: '6',
          component: SocialInsurance,
          meta: { title: '昨年度の社会保険料' }
        },
        {
          path: '7',
          component: ScheduledSalary,
          meta: { title: '今年度の所得' }
        },
        {
          path: '8',
          component: ScheduledSocialInsurance,
          meta: { title: '今年度の社会保険料' }
        }
      ]
    },
    {
      path: '/simulations',
      component: SimulationResult,
      meta: { title: 'シミュレーション結果' }
    }
  ]
})

const DEFAULT_TITLE = 'quitcost'
const DEFAULT_DESCRIPTION = '「無職になったらいくらかかる？」を解決'

router.afterEach((to) => {
  const title = to.meta.title
    ? `${to.meta.title} | ${DEFAULT_TITLE}`
    : DEFAULT_TITLE
  const content = to.meta.description || DEFAULT_DESCRIPTION

  document.title = title
  document
    .querySelector("meta[property='og:title']")
    .setAttribute('content', title)
  document
    .querySelector("meta[name='description']")
    .setAttribute('content', content)
  document
    .querySelector("meta[property='og:description']")
    .setAttribute('content', content)
})

export default router
