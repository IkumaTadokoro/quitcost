<template>
  <div class="text-center">
    <h2 class="form-label">
      <span class="inline-block">{{ `今年度（${from} ~ ${to}）の` }}</span
      ><span class="inline-block">「予定社会保険料」を教えてください</span>
    </h2>
    <input
      class="form-field text-right"
      type="text"
      :value="scheduledSocialInsuranceValue"
      @blur="handleChange"
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
  </div>
</template>

<script setup>
import { inject, computed } from 'vue'
import { useField } from 'vee-validate'
import { getYear, subMonths, format } from 'date-fns'

const base = inject('SIMULATION_DATE')
const thisYear = getYear(subMonths(base, 3))
const from = format(new Date(thisYear, 0, 1), 'yyyy年M月d日')
const to = format(new Date(thisYear, 11, 31), 'yyyy年M月d日')
const formData = inject('FORM_DATA')
const scheduledSocialInsuranceValue = computed({
  get: () =>
    scheduledSocialInsurance.value || formData.value.scheduledSocialInsurance,
  set: (value) => {
    scheduledSocialInsurance.value = value
  }
})
let {
  value: scheduledSocialInsurance,
  errorMessage: error,
  handleChange
} = useField('scheduledSocialInsurance')
const setDefaultValue = () =>
  (scheduledSocialInsurance.value = formData.value.scheduledSocialInsurance)
setDefaultValue()
</script>
