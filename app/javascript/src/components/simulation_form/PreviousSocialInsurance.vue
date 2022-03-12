<template>
  <div class="text-center">
    <h2 class="form-label">
      <span class="inline-block">{{ `昨年度（${from} ~ ${to}）の` }}</span
      ><span class="inline-block">「社会保険料」を教えてください</span>
    </h2>
    <input
      class="form-field text-right"
      type="text"
      :value="previousSocialInsurance"
      @change="handleChange"
      v-maska="{ mask: '#*' }"
      placeholder="500000"
    />
    <p class="form-tips">
      <i class="fas fa-info-circle mr-2"></i
      >住民税の総額は、住民税決定通知書の「社会保険料」の値です
    </p>
    <p class="form-error">{{ error }}</p>
    <InsuranceCompleteButton
      :salary="previousSalary"
      @completeInsurance="completeInsurance"
      class="mt-2"
    />
  </div>
</template>

<script setup>
import { onMounted, computed } from 'vue'
import { useRoute } from 'vue-router'
import { useField } from 'vee-validate'
import { format } from 'date-fns'
import { useGlobalStore } from '../../store/global'
import { useFinancialYear } from '../../composables/use-financial-year'
import InsuranceCompleteButton from './InsuranceCompleteButton'

const { simulation } = useGlobalStore()
const params = $computed(() => simulation.params)
const previousSalary = computed(() => Number(params.previousSalary))

const base = new Date(params.simulationDate)
const { beforeLastBeginningOfYear, beforeLastEndOfYear } = useFinancialYear(
  base,
  1,
  4
)
const from = format(beforeLastBeginningOfYear, 'yyyy年M月d日')
const to = format(beforeLastEndOfYear, 'yyyy年M月d日')

const completeInsurance = (calculatedInsurance) => {
  previousSocialInsurance.value = calculatedInsurance
}

let {
  value: previousSocialInsurance,
  errorMessage: error,
  handleChange
} = useField('previousSocialInsurance')

onMounted(() => {
  previousSocialInsurance.value = params.previousSocialInsurance
  simulation.setCurrentStep(useRoute().name)
})
</script>
