<template>
  <div class="container mx-auto">
    <FormWizard :validation-schema="validationSchema" @submit="onSubmit">
      <FormStep><RetirementMonth /></FormStep>
      <FormStep><EmploymentMonth /></FormStep>
      <FormStep><Age /></FormStep>
      <FormStep><PostalCode /></FormStep>
      <FormStep><Salary /></FormStep>
      <FormStep><SocialInsurance /></FormStep>
      <FormStep><ScheduledSalary /></FormStep>
      <FormStep><ScheduledSocialInsurance /></FormStep>
    </FormWizard>
  </div>
</template>

<script setup>
import { provide } from 'vue'
import FormWizard from './components/FormWizard'
import FormStep from './components/FormStep'
import RetirementMonth from './components/simulation_form/RetirementMonth'
import EmploymentMonth from './components/simulation_form/EmploymentMonth'
import Age from './components/simulation_form/Age'
import PostalCode from './components/simulation_form/PostalCode'
import Salary from './components/simulation_form/Salary'
import SocialInsurance from './components/simulation_form/SocialInsurance'
import ScheduledSalary from './components/simulation_form/ScheduledSalary'
import ScheduledSocialInsurance from './components/simulation_form/ScheduledSocialInsurance'
import { useValidationSchema } from './validation-schema'

const simulationDate = new Date()
provide('SIMULATION_DATE', simulationDate)

const validationSchema = useValidationSchema(simulationDate)

const onSubmit = (formData) =>
  alert(`入力結果をAPIに送信：\n${JSON.stringify(formData, null, 2)}`)
</script>

<style scope>
.form-label {
  @apply font-bold text-4xl h-32;
}

.form-field {
  @apply px-6 py-2 w-9/12 rounded-md border-4 border-gray-200 focus:border-green-700 tracking-widest text-5xl outline-none leading-8 transition-colors duration-200 ease-in-out;
}

.form-tips {
  @apply mt-4 text-sm text-gray-400;
}

.form-error {
  @apply flex justify-center text-red-500 font-bold mt-2;
}

.form-supplement {
  @apply pl-4 text-4xl text-gray-900 font-bold;
}
</style>
