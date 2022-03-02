<template>
  <div class="text-center">
    <h2 class="form-label">転職予定月を教えてください</h2>
    <input
      class="form-field text-center"
      type="text"
      v-maska="{ mask: '####/##' }"
      :value="employmentMonthValue"
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
import { computed, onMounted } from 'vue'
import { useField } from 'vee-validate'
import { addYears, format } from 'date-fns'
import { useGlobalStore } from '../../store/global'

const { simulation } = useGlobalStore()
const params = $computed(() => simulation.params)

const base = new Date(params.simulationDate)
const from = format(base, 'yyyy/MM')
const to = format(
  new Date(getYear(addYears(subMonths(base, 3), 2)), 3, 1),
  'yyyy/MM'
)
const employmentMonthValue = computed({
  get: () => employmentMonth.value || params.employmentMonth,
  set: (value) => (employmentMonth.value = value)
})
let { value: retirementMonth } = useField('retirementMonth')
let {
  value: employmentMonth,
  errorMessage: error,
  handleChange
} = useField('employmentMonth')

onMounted(() => {
  retirementMonth.value = params.retirementMonth
  employmentMonth.value = params.employmentMonth
})
</script>
