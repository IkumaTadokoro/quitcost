<template>
  <div>
    <span class="text-3xl text-primary md:text-6xl">{{ progress }}</span>
    <span class="text-base text-gray md:text-3xl"> / </span>
    <span class="text-2xl text-primary md:text-4xl">{{ steps }}</span>
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
