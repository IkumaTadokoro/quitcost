<template>
  <h2 class="form-label">
    <span class="inline-block">{{ `今年度（${from} ~ ${to}）` }}の</span
    ><span class="inline-block">「予定所得額」を教えてください</span>
  </h2>
  <input
    class="form-field text-right"
    type="text"
    :value="scheduledSalary"
    @blur="handleChange"
    v-maska="{ mask: '#*' }"
    placeholder="500000"
  />
  <p class="form-tips">
    <i class="fas fa-info-circle mr-2"></i
    >予定所得額は「退職するまでの毎月の給与（満額）」と「賞与（満額）」の合計です
  </p>
  <p class="form-error">{{ error }}</p>
</template>

<script setup>
import { inject } from 'vue'
import { useField } from 'vee-validate'
import { getYear, subMonths, format } from 'date-fns'

const base = inject('SIMULATION_DATE')
const thisYear = getYear(subMonths(base, 3))
const from = format(new Date(thisYear, 0, 1), 'yyyy年M月d日')
const to = format(new Date(thisYear, 11, 31), 'yyyy年M月d日')
const {
  value: scheduledSalary,
  errorMessage: error,
  handleChange
} = useField('scheduledSalary')
</script>
