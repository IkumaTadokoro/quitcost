<template>
  <form class="mt-24" @submit="onSubmit">
    <div class="flex">
      <h2>
        <span class="text-6xl font-bold text-green-700">{{ displayStep }}</span>
        <span class="text-3xl font-semi-bold text-gray-400"> / </span>
        <span class="text-4xl font-bold text-green-700">{{
          zeroPadStepCounter
        }}</span>
      </h2>
      <ProgressBar :top="raw" :bottom="stepCounter" />
    </div>
    <div class="px-24 m-24">
      <slot />
    </div>
    <div class="flex justify-between">
      <button
        class="button text-white bg-gray-300 hover:bg-gray-400 rounded-full"
        v-if="step.hasPrevious"
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
import ProgressBar from './ProgressBar'
import { useForm } from 'vee-validate'
import { computed } from 'vue'
import { useRouter } from 'vue-router'
import { useGlobalStore } from '../store/global'

const emit = defineEmits(['next', 'submit'])
const props = defineProps({
  validationSchema: {
    type: Array,
    required: true
  }
})

const { simulation, step } = useGlobalStore()
const router = useRouter()

const raw = $computed(() => step.raw)
const displayStep = computed(() => ('00' + step.current).slice(-2))

const params = $computed(() => simulation.params)
const stepCounter = 8
const lastStep = $computed(() => step.raw === stepCounter - 1)
const nextStep = computed(() => (lastStep ? '計算結果へ' : 'つぎの質問へ'))
const zeroPadStepCounter = computed(() => ('00' + stepCounter).slice(-2))

const { resetForm, handleSubmit } = useForm({
  validationSchema: computed(() => props.validationSchema[raw])
})

const onSubmit = handleSubmit((values) => {
  simulation.add_params(values)
  resetForm({ values: { ...params } })
  if (!lastStep) {
    step.increment()
    router.push(`${step.current}`)
    return
  }
  emit('submit')
})

const goToPrev = () => {
  if (raw === 0) return
  step.decrement()
  resetForm({ values: { ...params } })
  router.push(`${step.current}`)
}
</script>

<style scope>
.button {
  @apply border-0 py-4 px-8 focus:outline-none rounded-full text-xl;
}
</style>
