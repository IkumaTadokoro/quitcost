<template>
  <label for="previousSalary" class="form-label">
    <span class="inline-block">{{ `昨昨年度（${from} ~ ${to}）の` }}</span
    ><span class="inline-block">「所得額」を教えてください</span>
  </label>
  <p class="mb-1 w-9/12 mx-auto text-right">
    <span class="ml-2 text-red-600">{{ error }}</span>
  </p>
  <input
    id="previousSalary"
    class="form-field text-right"
    type="text"
    :value="previousSalary"
    :class="error ? 'form-field-error' : 'form-field'"
    @change="handleChange"
    v-maska="{ mask: '#*' }"
    placeholder="500000"
  />
  <p class="form-tips">
    <i class="fas fa-info-circle mr-2"></i
    >昨昨年度の所得額は住民税決定通知書の「給与所得（所得金額調整控除後）」の値です
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
const { beforeLastBeginningOfYear, beforeLastEndOfYear } = useFinancialYear(
  base,
  1,
  4
)
const from = format(beforeLastBeginningOfYear, 'yyyy年M月d日')
const to = format(beforeLastEndOfYear, 'yyyy年M月d日')
let {
  value: previousSalary,
  errorMessage: error,
  handleChange
} = useField('previousSalary')

onMounted(() => {
  previousSalary.value = params.previousSalary
  simulation.setCurrentStep(useRoute().name)
})
</script>
