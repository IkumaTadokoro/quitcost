<template>
  <label for="retirementMonth" class="form-label"
    >退職予定月を教えてください</label
  >
  <input
    id="retirementMonth"
    class="form-field text-center"
    type="text"
    v-maska="{ mask: '####/##' }"
    :value="retirementMonth"
    @change="handleChange"
    placeholder="2022/02"
  />
  <p class="form-tips">
    <i class="fas fa-info-circle mr-2"></i>計算可能な範囲：
    {{ `${from} ~ ${to}` }}
  </p>
  <p class="form-error">{{ error }}</p>
</template>

<script setup>
import { onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { useField } from 'vee-validate'
import { addMonths, addYears, format } from 'date-fns'
import { useGlobalStore } from '../../store/global'
import { useFinancialYear } from '../../composables/useFinancialYear'

const { simulation } = useGlobalStore()
const params = $computed(() => simulation.params)

const base = new Date(params.simulationDate)
const { endOfYear } = useFinancialYear(addYears(base, 1), 4)
const from = format(base, 'yyyy/MM')
const to = format(addMonths(endOfYear, 1), 'yyyy/MM')

let {
  value: retirementMonth,
  errorMessage: error,
  handleChange
} = useField('retirementMonth')

onMounted(() => {
  retirementMonth.value = params.retirementMonth
  simulation.setCurrentStep(useRoute().name)
})
</script>
