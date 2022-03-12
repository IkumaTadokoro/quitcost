<template>
  <form class="mt-24" @submit="onSubmit">
    <div class="flex">
      <h2>
        <span class="text-6xl text-primary">{{ displayStep }}</span>
        <span class="text-3xl font-semi-bold text-gray"> / </span>
        <span class="text-4xl text-primary">{{ zeroPadStepCounter }}</span>
      </h2>
      <ProgressBar :top="current" :bottom="steps" />
    </div>
    <div class="px-24 m-24">
      <slot />
    </div>
    <div class="flex justify-between">
      <button
        class="button text-gray bg-secondary hover:bg-primary hover:text-white rounded-full"
        v-if="prev"
        type="button"
        @click="goToPrev"
      >
        まえの質問へ
      </button>
      <button
        class="ml-auto button text-white bg-primary hover:bg-green-900"
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
    type: Object,
    required: true
  }
})

const { simulation } = useGlobalStore()
const router = useRouter()

const prev = $computed(() => simulation.prevStep.value)
const current = $computed(() => simulation.currentStepIdx)
const next = $computed(() => simulation.nextStep.value)
const steps = $computed(() => simulation.steps)
const params = $computed(() => simulation.params)

const displayStep = computed(() => ('00' + (current + 1)).slice(-2))
const nextStep = computed(() => (next ? 'つぎの質問へ' : '計算結果へ'))
const zeroPadStepCounter = computed(() => ('00' + steps).slice(-2))

const { resetForm, handleSubmit } = useForm({
  validationSchema: computed(
    () => props.validationSchema[simulation.currentStep]
  )
})

const onSubmit = handleSubmit((values) => {
  simulation.add_params(values)
  resetForm({ values: { ...params } })
  if (next) {
    router.push({ name: `${next}` })
    return
  }
  emit('submit')
})

const goToPrev = () => {
  if (current === 0) return
  resetForm({ values: { ...params } })
  router.push({ name: `${prev}` })
}
</script>

<style scope>
.button {
  @apply border-0 py-4 px-8 focus:outline-none rounded-full text-xl;
}
</style>
