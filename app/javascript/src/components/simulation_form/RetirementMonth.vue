<template>
  <div class="text-center">
    <h2 class="form-label">退職予定月を教えてください</h2>
    <input
      class="form-field text-center"
      type="text"
      v-maska="{ mask: '####/##' }"
      :value="retirementMonthValue"
      @blur="handleChange"
      placeholder="2022/02"
    />
    <p class="form-tips">
      <i class="fas fa-info-circle mr-2"></i>計算可能な範囲：
      {{ `${from} ~ ${to}` }}
    </p>
    <p class="form-error">{{ error }}</p>
  </div>
</template>

<script setup>
import { inject, computed } from 'vue'
import { useField } from 'vee-validate'
import { getYear, subMonths, addYears, format } from 'date-fns'

const formData = inject('FORM_DATA')
const retirementMonthValue = computed({
  get: () => retirementMonth.value || formData.value.retirementMonth,
  set: (value) => {
    retirementMonth.value = value || formData.value.retirementMonth
  }
})
const base = inject('SIMULATION_DATE')
const from = format(base, 'yyyy/MM')
const to = format(
  new Date(getYear(addYears(subMonths(base, 3), 2)), 3, 1),
  'yyyy/MM'
)

let {
  value: retirementMonth,
  errorMessage: error,
  handleChange
} = useField('retirementMonth')

const setDefaultValue = () =>
  (retirementMonth.value = formData.value.retirementMonth)
setDefaultValue()
</script>
