<template>
  <div>
    <span class="text-6xl text-primary">{{ progress }}</span>
    <span class="text-3xl font-semi-bold text-gray"> / </span>
    <span class="text-4xl text-primary">{{ steps }}</span>
  </div>
</template>

<script setup>
import { computed } from 'vue'

const props = defineProps({
  top: {
    required: true
  },
  bottom: {
    required: true
  }
})

const progress = computed(() => ('00' + props.top).slice(-2))
const steps = computed(() => ('00' + props.bottom).slice(-2))
</script>
