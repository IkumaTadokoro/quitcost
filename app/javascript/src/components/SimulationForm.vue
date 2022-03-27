<template>
  <div class="container mx-auto">
    <div class="px-4 pt-16">
      <FormWizard @submit="onSubmit" />
    </div>
  </div>
</template>

<script setup>
import FormWizard from './FormWizard'
import { useRouter } from 'vue-router'

const router = useRouter()

const onSubmit = () => router.push('/simulations')
</script>
