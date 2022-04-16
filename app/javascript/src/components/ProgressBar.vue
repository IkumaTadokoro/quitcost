<template>
  <div class="mx-4 flex grow items-center justify-center md:mx-32">
    <div class="w-full rounded-full bg-secondary">
      <div
        v-if="progress"
        class="h-3 rounded-full bg-primary p-0.5 text-center text-xs font-medium leading-none text-primary"
        :style="{ width: progress + '%' }"
        data-test-id="Progress"
      ></div>
      <div
        v-else
        class="h-3 rounded-full bg-secondary py-0.5 pl-8 text-left text-xs font-medium leading-none text-secondary"
        data-test-id="Steps"
      ></div>
    </div>
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

const progress = computed(() => Math.ceil((props.top / props.bottom) * 100))
</script>
