<template>
  <div class="container mx-auto">
    <FormWizard @submit="onSubmit" />
  </div>
</template>

<script setup>
import FormWizard from './FormWizard'
import { useRouter } from 'vue-router'

const router = useRouter()

const onSubmit = () => router.push('/simulations')
</script>

<style scope>
.form-label {
  @apply h-20 text-4xl inline-block mb-2;
}

.form-field {
  @apply px-6 py-2 w-9/12 rounded-md border-4 border-boundaryBlack focus:border-gray tracking-widest text-5xl outline-none leading-8 transition-colors duration-200 ease-in-out placeholder-boundaryBlack;
}

.form-field-error {
  @apply px-6 py-2 w-9/12 rounded-md border-4 border-red-600 tracking-widest text-5xl outline-none leading-8 placeholder-boundaryBlack;
}

.form-field-success {
  @apply px-6 py-2 w-9/12 rounded-md border-4 border-primary tracking-widest text-5xl outline-none leading-8 placeholder-boundaryBlack;
}

.form-tips {
  @apply mt-2 text-sm text-gray;
}

.form-error {
  @apply flex h-6 justify-center text-red-500 mb-2;
}

.form-supplement {
  @apply pl-4 text-4xl text-black;
}
</style>
