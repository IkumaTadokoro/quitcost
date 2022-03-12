<template>
  <div className="text-center">
    <h2 className="form-label">
      <span className="inline-block">{{ `昨昨年度（${from} ~ ${to}）の` }}</span
      ><span className="inline-block">「所得」を教えてください</span>
    </h2>
    <input
      className="form-field text-right"
      type="text"
      :value="previousSalary"
      @change="handleChange"
      v-maska="{ mask: '#*' }"
      placeholder="500000"
    />
    <p className="form-tips">
      <i className="fas fa-info-circle mr-2"></i
      >所得額は住民税決定通知書の「給与所得（所得金額調整控除後）」の値です
    </p>
    <p className="form-error">{{ error }}</p>
  </div>
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
