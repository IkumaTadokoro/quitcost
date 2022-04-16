<template>
  <form @submit="onSubmit">
    <div class="flex">
      <ProgressStep :top="current + 1" :bottom="steps" />
      <ProgressBar :top="current" :bottom="steps - 1" />
    </div>
    <div class="h-96 px-4 pt-12 text-center md:px-24">
      <router-view></router-view>
    </div>
    <div class="mt-16 flex justify-evenly gap-x-4 px-4 md:mx-auto md:w-9/12">
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
import ProgressStep from './ProgressStep'
import ProgressBar from './ProgressBar'
import { useForm } from 'vee-validate'
import { computed } from 'vue'
import { useRouter } from 'vue-router'
import { useGlobalStore } from '../store/global'
import { useValidationSchema } from '../composables/useValidationSchema'

const emit = defineEmits(['next', 'submit'])
const { simulation } = useGlobalStore()
const router = useRouter()

const prev = $computed(() => simulation.prevStep.value)
const current = $computed(() => simulation.currentStepIdx)
const next = $computed(() => simulation.nextStep.value)
const steps = $computed(() => simulation.steps)
const params = $computed(() => simulation.params)

const validationSchema = useValidationSchema(new Date(params.simulationDate))
const nextStep = computed(() => (next ? 'つぎの質問へ' : '計算結果へ'))

const { resetForm, handleSubmit } = useForm({
  validationSchema: computed(() => validationSchema[simulation.currentStep])
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
.form-label {
  @apply mb-8 inline-block h-20 text-xl md:mb-4 md:h-24 md:text-4xl;
}

.form-field {
  @apply w-full rounded-md border-4 border-boundaryBlack px-6 py-2 text-2xl leading-8 tracking-widest placeholder-boundaryBlack outline-none transition-colors duration-200 ease-in-out focus:border-primary md:w-9/12 md:text-5xl;
}

.form-field-error {
  @apply w-full rounded-md border-4 border-red-500 px-6 py-2 text-2xl leading-8 tracking-widest placeholder-boundaryBlack outline-none focus:border-red-600 md:w-9/12 md:text-5xl;
}

.form-tips {
  @apply mt-2 text-xs text-gray md:text-sm;
}

.form-error {
  @apply flex h-6 justify-end text-xs text-red-500 md:mx-auto md:w-9/12 md:text-base;
}

.next-button {
  @apply flex w-40 items-center justify-between rounded-full border-4 border-primary bg-primary px-5 py-3 text-sm text-white duration-100 ease-in after:h-2 after:w-2 after:rotate-45 after:border-t-4 after:border-r-4 after:border-solid after:border-white after:content-[''] hover:bg-white hover:text-gray after:hover:border-gray md:w-52 md:px-8 md:py-5 md:text-lg md:after:h-3 md:after:w-3;
}

.submit-button {
  @apply flex w-40 items-center justify-evenly rounded-full border-4 border-accent bg-accent px-5 py-3 text-sm text-white duration-100 ease-in after:h-3 after:w-3 after:rotate-45 after:border-t-4 after:border-r-4 after:border-solid after:border-white after:content-[''] hover:bg-white hover:text-gray after:hover:border-gray md:w-52 md:px-8 md:py-5 md:text-lg;
}

.prev-button {
  @apply flex w-40 items-center justify-between rounded-full border-4 border-secondary bg-secondary px-5 py-3 text-sm text-gray duration-100 ease-in before:h-2 before:w-2 before:rotate-45 before:border-b-4 before:border-l-4 before:border-solid before:border-gray before:content-[''] hover:bg-white hover:text-gray before:hover:border-gray md:w-52 md:px-8 md:py-5 md:text-lg md:before:h-3 md:before:w-3;
}
</style>
