<template>
  <label for="scheduledSalary" class="form-label">
    <span class="inline-block">{{ `今年度（${from} ~ ${to}）` }}の</span
    ><span class="inline-block">「所得額」を教えてください</span>
  </label>
  <p class="form-error">{{ error }}</p>
  <input
    id="scheduledSalary"
    class="form-field text-right"
    type="text"
    :value="scheduledSalary"
    :class="error ? 'form-field-error' : 'form-field'"
    @change="handleChange"
    v-maska="{ mask: '#*' }"
    placeholder="500000"
  />
  <p class="form-tips">
    <i class="fas fa-info-circle mr-2"></i
    >今年度の所得額は「退職するまでの毎月の給与（満額）」と「賞与（満額）」の合計です
  </p>
</template>

<script setup>
import { onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { useField } from 'vee-validate'
import { format } from 'date-fns'
import { useGlobalStore } from '../../store/global'
import { useFinancialYear } from '../../composables/useFinancialYear'

const { simulation } = useGlobalStore()
const params = $computed(() => simulation.params)

const base = new Date(params.simulationDate)

const { beginningOfYear, endOfYear } = useFinancialYear(base, 1, 4)
const from = format(beginningOfYear, 'yyyy年M月d日')
const to = format(endOfYear, 'yyyy年M月d日')
let {
  value: scheduledSalary,
  errorMessage: error,
  handleChange
} = useField('scheduledSalary')

onMounted(() => {
  scheduledSalary.value = params.scheduledSalary
  simulation.setCurrentStep(useRoute().name)
})
</script>
