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
import { computed, onMounted } from 'vue'
import { useField } from 'vee-validate'
import { addMonths, addYears, format } from 'date-fns'
import { useGlobalStore } from '../../store/global'
import { useFinancialYear } from '../../composables/use-financial-year'

const { simulation } = useGlobalStore()
const params = $computed(() => simulation.params)

const base = new Date(params.simulationDate)
const { endOfYear } = useFinancialYear(addYears(base, 1), 4)
const from = format(base, 'yyyy/MM')
const to = format(addMonths(endOfYear, 1), 'yyyy/MM')

const retirementMonthValue = computed({
  get: () => retirementMonth.value || params.retirementMonth,
  set: (value) => (retirementMonth.value = value)
})

let {
  value: retirementMonth,
  errorMessage: error,
  handleChange
} = useField('retirementMonth')

onMounted(() => (retirementMonth.value = params.retirementMonth))
</script>
