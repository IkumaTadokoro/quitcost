import { createRouter, createWebHistory } from 'vue-router'
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
    { path: '/simulations/new', redirect: '/simulations/new/1' },
    {
      name: 'retirementMonth',
      path: '/simulations/new/1',
      component: RetirementMonth
    },
    {
      name: 'employmentMonth',
      path: '/simulations/new/2',
      component: EmploymentMonth
    },
    {
      name: 'age',
      path: '/simulations/new/3',
      component: Age
    },
    {
      name: 'postalCode',
      path: '/simulations/new/4',
      component: PostalCode
    },
    {
      name: 'salary',
      path: '/simulations/new/5',
      component: Salary
    },
    {
      name: 'SocialInsurance',
      path: '/simulations/new/6',
      component: SocialInsurance
    },
    {
      name: 'scheduledSalary',
      path: '/simulations/new/7',
      component: ScheduledSalary
    },
    {
      name: 'scheduledSocialInsurance',
      path: '/simulations/new/8',
      component: ScheduledSocialInsurance
    }
  ]
})

export default router
