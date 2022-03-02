<template>
  <div class="container mx-auto">
    <FormWizard :validation-schema="validationSchema" @submit="onSubmit">
      <router-view></router-view>
    </FormWizard>
  </div>
</template>

<script setup>
import FormWizard from './components/FormWizard'
import { useValidationSchema } from './validation-schema'
import { useRouter } from 'vue-router'
import { useGlobalStore } from './store/global'

const { simulation } = useGlobalStore()
const params = $computed(() => simulation.params)
const router = useRouter()

const validationSchema = useValidationSchema(new Date(params.simulationDate))

const onSubmit = () => router.push('/simulations')
</script>

<style scope>
.form-label {
  @apply font-bold text-4xl h-32;
}

.form-field {
  @apply px-6 py-2 w-9/12 rounded-md border-4 border-gray-200 focus:border-green-700 tracking-widest text-5xl outline-none leading-8 transition-colors duration-200 ease-in-out;
}

.form-tips {
  @apply mt-4 text-sm text-gray-400;
}

.form-error {
  @apply flex justify-center text-red-500 font-bold mt-2;
}

.form-supplement {
  @apply pl-4 text-4xl text-gray-900 font-bold;
}
</style>
