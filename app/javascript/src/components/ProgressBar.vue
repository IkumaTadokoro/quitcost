<template>
  <div class="grow mx-32 flex justify-center items-center">
    <div class="w-full bg-gray-200 rounded-full">
      <div
        v-if="progress"
        class="bg-green-700 text-xs font-medium text-green-700 text-center p-0.5 leading-none rounded-full"
        :style="{ width: progress + '%' }"
      >
        1
      </div>
      <div
        v-else
        class="bg-gray-200 text-xs font-medium text-gray-200 text-left py-0.5 pl-8 leading-none rounded-full"
      >
        0
      </div>
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

const progress = computed(() =>
  Math.ceil((props.top / (props.bottom - 1)) * 100)
)
</script>
