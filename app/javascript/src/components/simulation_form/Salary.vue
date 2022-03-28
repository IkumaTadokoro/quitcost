<template>
  <label for="salary" class="form-label">
    <span class="inline-block">{{ `昨年度（${from} ~ ${to}）の` }}</span
    ><span class="inline-block">「所得額」を教えてください</span>
  </label>
  <p class="form-error">{{ error }}</p>
  <input
    id="salary"
    class="form-field text-right"
    type="text"
    :value="salary"
    :class="error ? 'form-field-error' : 'form-field'"
    @change="handleChange"
    v-maska="{ mask: '#*' }"
    placeholder="500000"
  />
  <p class="form-tips">
    <i class="fas fa-info-circle mr-2"></i
    >昨年度の所得額は住民税決定通知書の「給与所得（所得金額調整控除後）」の値です
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
const { lastBeginningOfYear, lastEndOfYear } = useFinancialYear(base, 1, 4)
const from = format(lastBeginningOfYear, 'yyyy年M月d日')
const to = format(lastEndOfYear, 'yyyy年M月d日')
let { value: salary, errorMessage: error, handleChange } = useField('salary')

onMounted(() => {
  salary.value = params.salary
  simulation.setCurrentStep(useRoute().name)
})
</script>
