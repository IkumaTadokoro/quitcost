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
import { getYear, subMonths, subYears, format } from 'date-fns'
import { useGlobalStore } from '../../store/global'

const { simulation } = useGlobalStore()
const params = $computed(() => simulation.params)

const salaryValue = computed({
  get: () => salary.value || params.salary,
  set: (value) => (salary.value = value)
})

const base = new Date(params.simulationDate)
const lastYear = getYear(subYears(subMonths(base, 3), 1))
const from = format(new Date(lastYear, 0, 1), 'yyyy年M月d日')
const to = format(new Date(lastYear, 11, 31), 'yyyy年M月d日')

let { value: salary, errorMessage: error, handleChange } = useField('salary')

onMounted(() => (salary.value = params.salary))
</script>
