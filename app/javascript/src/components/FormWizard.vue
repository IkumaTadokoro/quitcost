<template>
  <form class="mt-20" @submit="onSubmit">
    <div class="flex">
      <h2>
        <span class="text-6xl text-primary">{{ displayStep }}</span>
        <span class="text-3xl font-semi-bold text-gray"> / </span>
        <span class="text-4xl text-primary">{{ zeroPadStepCounter }}</span>
      </h2>
      <ProgressBar :top="current" :bottom="steps" />
    </div>
    <div class="px-24 m-16">
      <slot />
    </div>
    <div class="flex justify-evenly">
      <button class="prev-button" v-if="prev" type="button" @click="goToPrev">
        まえの質問へ
      </button>
      <button
        class="ml-auto"
        :class="next ? 'next-button' : 'submit-button'"
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
.next-button {
  @apply flex justify-between items-center bg-primary text-white rounded-full text-lg w-52 px-8 py-5 ease-in duration-100 hover:bg-white hover:text-gray border-4 border-primary after:content-[''] after:w-3 after:h-3 after:rotate-45 after:border-solid after:border-white after:border-t-4 after:border-r-4 after:hover:border-gray;
}

.submit-button {
  @apply flex justify-evenly items-center bg-accent text-white rounded-full text-lg w-52 px-8 py-5 ease-in duration-100 hover:bg-white hover:text-gray border-4 border-accent after:content-[''] after:w-3 after:h-3 after:rotate-45 after:border-solid after:border-white after:border-t-4 after:border-r-4 after:hover:border-gray;
}

.prev-button {
  @apply flex justify-between items-center bg-secondary text-gray rounded-full text-lg w-52 px-8 py-5 ease-in duration-100 hover:bg-white hover:text-gray border-4 border-secondary before:content-[''] before:w-3 before:h-3 before:rotate-45 before:border-solid before:border-gray before:border-b-4 before:border-l-4 before:hover:border-gray;
}
</style>
