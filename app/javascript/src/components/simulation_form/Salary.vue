<template>
  <div class="text-center">
    <h2 class="form-label">
      <span class="inline-block">{{ `昨年度（${from} ~ ${to}）の` }}</span
      ><span class="inline-block">「所得」を教えてください</span>
    </h2>
    <input
      class="form-field text-right"
      type="text"
      :value="salaryValue"
      @blur="handleChange"
      v-maska="{ mask: '#*' }"
      placeholder="500000"
    />
    <p class="form-tips">
      <i class="fas fa-info-circle mr-2"></i
      >所得額は住民税決定通知書の「給与所得（所得金額調整控除後）」の値です
    </p>
    <p class="form-error">{{ error }}</p>
  </div>
</template>

<script setup>
import { computed, onMounted } from 'vue'
import { useField } from 'vee-validate'
import { format } from 'date-fns'
import { useGlobalStore } from '../../store/global'
import { useFinancialYear } from '../../composables/use-financial-year'

const { simulation } = useGlobalStore()
const params = $computed(() => simulation.params)

const salaryValue = computed({
  get: () => salary.value || params.salary,
  set: (value) => (salary.value = value)
})

const base = new Date(params.simulationDate)
const { lastBeginningOfYear, lastEndOfYear } = useFinancialYear(base, 1, 4)
const from = format(lastBeginningOfYear, 'yyyy年M月d日')
const to = format(lastEndOfYear, 'yyyy年M月d日')
let { value: salary, errorMessage: error, handleChange } = useField('salary')

onMounted(() => (salary.value = params.salary))
</script>
