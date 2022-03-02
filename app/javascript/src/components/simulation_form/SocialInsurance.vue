<template>
  <div class="text-center">
    <h2 class="form-label">
      <span class="inline-block">{{ `昨年度（${from} ~ ${to}）の` }}</span
      ><span class="inline-block">「社会保険料」を教えてください</span>
    </h2>
    <input
      class="form-field text-right"
      type="text"
      :value="socialInsuranceValue"
      @blur="handleChange"
      v-maska="{ mask: '#*' }"
      placeholder="500000"
    />
    <p class="form-tips">
      <i class="fas fa-info-circle mr-2"></i
      >住民税の総額は、住民税決定通知書の「社会保険料」の値です
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

const base = new Date(params.simulationDate)
const { lastBeginningOfYear, lastEndOfYear } = useFinancialYear(base, 1, 4)
const from = format(lastBeginningOfYear, 'yyyy年M月d日')
const to = format(lastEndOfYear, 'yyyy年M月d日')

const socialInsuranceValue = computed({
  get: () => socialInsurance.value || params.socialInsurance,
  set: (value) => (socialInsurance.value = value)
})

let {
  value: socialInsurance,
  errorMessage: error,
  handleChange
} = useField('socialInsurance')

onMounted(() => (socialInsurance.value = params.socialInsurance))
</script>
