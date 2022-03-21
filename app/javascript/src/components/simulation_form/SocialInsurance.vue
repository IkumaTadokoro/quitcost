<template>
  <label for="socialInsurance" class="form-label">
    <span class="inline-block">{{ `昨年度（${from} ~ ${to}）の` }}</span
    ><span class="inline-block">「社会保険料」を教えてください</span>
  </label>
  <p class="mb-1 w-9/12 mx-auto text-right">
    <span class="ml-2 text-red-600">{{ error }}</span>
  </p>
  <input
    id="socialInsurance"
    class="text-right"
    type="text"
    :value="socialInsurance"
    :class="error ? 'form-field-error' : 'form-field'"
    @change="handleChange"
    v-maska="{ mask: '#*' }"
    placeholder="500000"
  />
  <p class="form-tips">
    <i class="fas fa-info-circle mr-2"></i
    >昨年度の社会保険料は、住民税決定通知書の「社会保険料」の値です
  </p>
  <InsuranceCompleteButton
    :salary="salary"
    @completeInsurance="completeInsurance"
    class="mt-4"
  />
</template>

<script setup>
import { onMounted, computed } from 'vue'
import { useRoute } from 'vue-router'
import { useField } from 'vee-validate'
import { format } from 'date-fns'
import { useGlobalStore } from '../../store/global'
import { useFinancialYear } from '../../composables/useFinancialYear'
import InsuranceCompleteButton from './InsuranceCompleteButton'

const { simulation } = useGlobalStore()
const params = $computed(() => simulation.params)
const salary = computed(() => Number(params.salary))

const base = new Date(params.simulationDate)
const { lastBeginningOfYear, lastEndOfYear } = useFinancialYear(base, 1, 4)
const from = format(lastBeginningOfYear, 'yyyy年M月d日')
const to = format(lastEndOfYear, 'yyyy年M月d日')

const completeInsurance = (calculatedInsurance) => {
  socialInsurance.value = calculatedInsurance
}

let {
  value: socialInsurance,
  errorMessage: error,
  handleChange
} = useField('socialInsurance')

onMounted(() => {
  socialInsurance.value = params.socialInsurance
  simulation.setCurrentStep(useRoute().name)
})
</script>
