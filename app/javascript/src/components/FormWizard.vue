<template>
  <form @submit="onSubmit">
    <div class="flex">
      <ProgressStep :top="current + 1" :bottom="steps" />
      <ProgressBar :top="current" :bottom="steps - 1" />
    </div>
    <div class="h-96 px-4 md:px-24 pt-12 text-center">
      <router-view></router-view>
    </div>
    <div class="md:w-9/12 md:mx-auto mt-16 flex px-4 justify-evenly gap-x-4">
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
  @apply h-20 md:h-24 text-xl md:text-4xl inline-block mb-8 md:mb-4;
}

.form-field {
  @apply md:px-6 py-2 md:w-9/12 rounded-md border-4 border-boundaryBlack focus:border-primary tracking-widest text-2xl md:text-5xl outline-none leading-8 transition-colors duration-200 ease-in-out placeholder-boundaryBlack;
}

.form-field-error {
  @apply px-6 py-2 md:w-9/12 rounded-md border-4 border-red-500 focus:border-red-600 tracking-widest text-2xl md:text-5xl outline-none leading-8 placeholder-boundaryBlack;
}

.form-tips {
  @apply mt-2 text-xs md:text-sm text-gray;
}

.form-error {
  @apply flex md:w-9/12 md:mx-auto h-6 justify-end text-red-500 text-xs md:text-base;
}

.next-button {
  @apply flex justify-between items-center bg-primary text-white rounded-full text-sm md:text-lg w-40 md:w-52 px-5 md:px-8 py-3 md:py-5 ease-in duration-100 hover:bg-white hover:text-gray border-4 border-primary after:content-[''] after:w-2 md:after:w-3 after:h-2 md:after:h-3 after:rotate-45 after:border-solid after:border-white after:border-t-4 after:border-r-4 after:hover:border-gray;
}

.submit-button {
  @apply flex justify-evenly items-center bg-accent text-white rounded-full text-sm md:text-lg w-40 md:w-52 px-5 md:px-8 py-3 md:py-5 ease-in duration-100 hover:bg-white hover:text-gray border-4 border-accent after:content-[''] after:w-3 after:h-3 after:rotate-45 after:border-solid after:border-white after:border-t-4 after:border-r-4 after:hover:border-gray;
}

.prev-button {
  @apply flex justify-between items-center bg-secondary text-gray rounded-full text-sm md:text-lg w-40 md:w-52 px-5 md:px-8 py-3 md:py-5 ease-in duration-100 hover:bg-white hover:text-gray border-4 border-secondary before:content-[''] before:w-2 md:before:w-3 before:h-2 md:before:h-3 before:rotate-45 before:border-solid before:border-gray before:border-b-4 before:border-l-4 before:hover:border-gray;
}
</style>
