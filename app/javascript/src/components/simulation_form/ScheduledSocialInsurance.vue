<template>
  <div class="text-center">
    <h2 class="form-label">
      <span class="inline-block">{{ `今年度（${from} ~ ${to}）の` }}</span
      ><span class="inline-block">「予定社会保険料」を教えてください</span>
    </h2>
    <input
      class="form-field text-right"
      type="text"
      :value="scheduledSocialInsurance"
      @change="handleChange"
      v-maska="{ mask: '#*' }"
      placeholder="500000"
    />
    <div class="form-tips flex justify-center">
      <div>
        <i class="fas fa-info-circle mr-2"></i>
      </div>
      <div class="text-left">
        <p>予定社会保険料は以下の合計です。</p>
        <ul class="list-disc pl-6 pt-0.5">
          <li>
            退職するまでの毎月の「社会保険料」「厚生年金保険料」「雇用保険料」
          </li>
          <li>
            賞与および臨時賞与の「社会保険料」「厚生年金保険料」「雇用保険料」
          </li>
        </ul>
      </div>
    </div>
    <p class="form-error">{{ error }}</p>
  </div>
</template>

<script setup>
import { onMounted } from 'vue'
import { useField } from 'vee-validate'
import { useGlobalStore } from '../../store/global'
import { useFinancialYear } from '../../composables/use-financial-year'
import { format } from 'date-fns'

const { simulation } = useGlobalStore()
const params = $computed(() => simulation.params)

const base = new Date(params.simulationDate)
const { beginningOfYear, endOfYear } = useFinancialYear(base, 1, 4)
const from = format(beginningOfYear, 'yyyy年M月d日')
const to = format(endOfYear, 'yyyy年M月d日')

let {
  value: scheduledSocialInsurance,
  errorMessage: error,
  handleChange
} = useField('scheduledSocialInsurance')

onMounted(
  () => (scheduledSocialInsurance.value = params.scheduledSocialInsurance)
)
</script>
