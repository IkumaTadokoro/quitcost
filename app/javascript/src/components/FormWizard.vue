<template>
  <form class="mt-24" @submit="onSubmit">
    <div class="flex">
      <h2>
        <span class="text-6xl font-bold text-green-700">{{
          zeroPadCurrentIdx
        }}</span>
        <span class="text-3xl font-semi-bold text-gray-400"> / </span>
        <span class="text-4xl font-bold text-green-700">{{
          zeroPadStepCounter
        }}</span>
      </h2>
      <ProgressBar :top="currentStepIdx" :bottom="stepCounter" />
    </div>
    <div class="px-24 m-24">
      <slot />
    </div>
    <div class="flex justify-between">
      <button
        class="button text-white bg-gray-300 hover:bg-gray-400 rounded-full"
        v-if="hasPrevious"
        type="button"
        @click="goToPrev"
      >
        まえの質問へ
      </button>
      <button
        class="ml-auto button text-white bg-green-700 hover:bg-green-800"
        type="submit"
      >
        {{ nextStep }}
      </button>
    </div>
  </form>
</template>

<script setup>
import { useForm } from 'vee-validate'
import { computed, provide } from 'vue'
import ProgressBar from './ProgressBar'
import { useRouter } from 'vue-router'
import { useStorage } from '@vueuse/core'

const router = useRouter()
const emit = defineEmits(['next', 'submit'])
const props = defineProps({
  validationSchema: {
    type: Array,
    required: true
  }
})
let formData = useStorage('formData', {})
let currentStepIdx = useStorage('currentStepIdx', 0)
const stepCounter = 8
provide('STEP_COUNTER', $$(stepCounter))
provide('CURRENT_STEP_INDEX', currentStepIdx)
provide('FORM_DATA', formData)
const isLastStep = computed(() => currentStepIdx.value === stepCounter - 1)
const nextStep = computed(() =>
  isLastStep.value ? '計算結果へ' : 'つぎの質問へ'
)
const hasPrevious = computed(() => currentStepIdx.value > 0)
const zeroPadCurrentIdx = computed(() =>
  ('00' + (currentStepIdx.value + 1)).slice(-2)
)
const zeroPadStepCounter = computed(() => ('00' + stepCounter).slice(-2))
const currentSchema = computed(
  () => props.validationSchema[currentStepIdx.value]
)

// useFormでバリデーションスキーマを定義する
const { resetForm, handleSubmit } = useForm({
  validationSchema: currentSchema
})

// handleSubmitでバリデーションチェックが終わってから処理を行う。
const onSubmit = handleSubmit((values) => {
  formData.value = {
    ...formData.value,
    ...values
  }
  // すでに入力された値を引数として初期値設定を行うことで、
  // 「まえの質問へ」を選択しても、値がセットされた状態になる。
  resetForm({
    values: {
      ...formData.value
    }
  })
  if (!isLastStep.value) {
    currentStepIdx.value++
    router.push(`${currentStepIdx.value + 1}`)
    return
  }
  emit('submit', formData.value)
})

const goToPrev = () => {
  if (currentStepIdx.value === 0) return
  currentStepIdx.value--
  resetForm({
    values: {
      ...formData.value
    }
  })
  router.push(`${currentStepIdx.value + 1}`)
}
</script>

<style scope>
.button {
  @apply border-0 py-4 px-8 focus:outline-none rounded-full text-xl;
}
</style>
