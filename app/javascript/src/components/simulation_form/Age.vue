<template>
  <div class="text-center">
    <h2 class="form-label">年齢を教えてください</h2>
    <input
      class="form-field text-right"
      type="text"
      :value="age"
      @change="handleChange"
      placeholder="30"
    /><span class="form-supplement">歳</span>
    <p class="form-error">{{ error }}</p>
  </div>
</template>

<script setup>
import { onMounted } from 'vue'
import { useField } from 'vee-validate'
import { useGlobalStore } from '../../store/global'

const { simulation } = useGlobalStore()
const params = $computed(() => simulation.params)

let { value: age, errorMessage: error, handleChange } = useField('age')

onMounted(() => (age.value = params.age))
</script>
