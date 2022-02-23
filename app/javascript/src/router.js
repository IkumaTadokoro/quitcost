import { createRouter, createWebHistory } from 'vue-router'
import SimulationForm from './SimulationForm'
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
    {
      path: '/simulations/new',
      component: SimulationForm,
      redirect: '/simulations/new/1',
      children: [
        { path: '1', component: RetirementMonth },
        { path: '2', component: EmploymentMonth },
        { path: '3', component: Age },
        { path: '4', component: PostalCode },
        { path: '5', component: Salary },
        { path: '6', component: SocialInsurance },
        { path: '7', component: ScheduledSalary },
        { path: '8', component: ScheduledSocialInsurance }
      ]
    }
  ]
})

export default router
