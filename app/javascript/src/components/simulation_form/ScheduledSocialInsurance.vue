<template>
  <div class="text-center">
    <label for="scheduledSalary" class="form-label">
      <span class="inline-block">{{ `今年度（${from} ~ ${to}）の` }}</span
      ><span class="inline-block">「予定社会保険料」を教えてください</span>
    </label>
    <input
      id="scheduledSalary"
      class="form-field text-right"
      type="text"
      :value="scheduledSocialInsurance"
      @change="handleChange"
      v-maska="{ mask: '#*' }"
      placeholder="500000"
    />
    <div class="form-tips flex justify-center">
      <div>
        <i class="fas fa-info-circle mr-2"></i>
      </div>
      <div class="text-left">
        <p>予定社会保険料は以下の合計です。</p>
        <ul class="list-disc pl-6 pt-0.5">
          <li>
            退職するまでの毎月の「社会保険料」「厚生年金保険料」「雇用保険料」
          </li>
          <li>
            賞与および臨時賞与の「社会保険料」「厚生年金保険料」「雇用保険料」
          </li>
        </ul>
      </div>
    </div>
    <p class="form-error">{{ error }}</p>
    <InsuranceCompleteButton
      :salary="scheduledSalary"
      @completeInsurance="completeInsurance"
      class="mt-2"
    />
  </div>
</template>

<script setup>
import { onMounted, computed } from 'vue'
import { useRoute } from 'vue-router'
import { useField } from 'vee-validate'
import { useGlobalStore } from '../../store/global'
import { useFinancialYear } from '../../composables/useFinancialYear'
import { format } from 'date-fns'
import InsuranceCompleteButton from './InsuranceCompleteButton'

const { simulation } = useGlobalStore()
const params = $computed(() => simulation.params)
const scheduledSalary = computed(() => Number(params.scheduledSalary))

const base = new Date(params.simulationDate)
const { beginningOfYear, endOfYear } = useFinancialYear(base, 1, 4)
const from = format(beginningOfYear, 'yyyy年M月d日')
const to = format(endOfYear, 'yyyy年M月d日')

const completeInsurance = (calculatedInsurance) => {
  scheduledSocialInsurance.value = calculatedInsurance
}

let {
  value: scheduledSocialInsurance,
  errorMessage: error,
  handleChange
} = useField('scheduledSocialInsurance')

onMounted(() => {
  scheduledSocialInsurance.value = params.scheduledSocialInsurance
  simulation.setCurrentStep(useRoute().name)
})
</script>
