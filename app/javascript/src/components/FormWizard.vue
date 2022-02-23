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

const router = useRouter()
const emit = defineEmits(['next', 'submit'])
const props = defineProps({
  validationSchema: {
    type: Array,
    required: true
  }
})
let formData = $ref({})
let currentStepIdx = $ref(0)
const stepCounter = 8
provide('STEP_COUNTER', $$(stepCounter))
provide('CURRENT_STEP_INDEX', $$(currentStepIdx))
const isLastStep = computed(() => currentStepIdx === stepCounter - 1)
const nextStep = computed(() =>
  isLastStep.value ? '計算結果へ' : 'つぎの質問へ'
)
const hasPrevious = computed(() => currentStepIdx > 0)
const zeroPadCurrentIdx = computed(() =>
  ('00' + (currentStepIdx + 1)).slice(-2)
)
const zeroPadStepCounter = computed(() => ('00' + stepCounter).slice(-2))
const currentSchema = computed(() => props.validationSchema[currentStepIdx])

// useFormでバリデーションスキーマを定義する
const { resetForm, handleSubmit } = useForm({
  validationSchema: currentSchema
})

// handleSubmitでバリデーションチェックが終わってから処理を行う。
const onSubmit = handleSubmit((values) => {
  formData = {
    ...formData,
    ...values
  }
  // すでに入力された値を引数として初期値設定を行うことで、
  // 「まえの質問へ」を選択しても、値がセットされた状態になる。
  resetForm({
    values: {
      ...formData
    }
  })
  if (!isLastStep.value) {
    currentStepIdx++
    router.push(`${currentStepIdx + 1}`)
    return
  }
  emit('submit', formData)
})

const goToPrev = () => {
  if (currentStepIdx === 0) return
  currentStepIdx--
  resetForm({
    values: {
      ...formData
    }
  })
  router.push(`${currentStepIdx + 1}`)
}
</script>

<style scope>
.button {
  @apply border-0 py-4 px-8 focus:outline-none rounded-full text-xl;
}
</style>
