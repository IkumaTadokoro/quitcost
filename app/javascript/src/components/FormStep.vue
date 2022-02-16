<template>
  <div v-if="shouldShow" class="text-center">
    <slot />
  </div>
</template>

<script setup>
import { computed, inject } from 'vue'

const stepCounter = inject('STEP_COUNTER').value++
const currentStepIdx = inject('CURRENT_STEP_INDEX')
const shouldShow = computed(() => stepCounter === currentStepIdx.value)
</script>
