<template>
  <div class="container mx-auto">
    <FormWizard @submit="onSubmit">
      <router-view></router-view>
    </FormWizard>
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
  @apply text-4xl inline-block mb-12;
}

.form-field {
  @apply px-6 py-2 w-9/12 rounded-md border-4 border-boundaryBlack focus:border-primary tracking-widest text-5xl outline-none leading-8 transition-colors duration-200 ease-in-out placeholder-boundaryBlack;
}

.form-tips {
  @apply mt-4 text-sm text-gray;
}

.form-error {
  @apply flex justify-center text-red-500 mt-2;
}

.form-supplement {
  @apply pl-4 text-4xl text-black;
}
</style>
