<template>
  <label for="age" class="form-label">年齢を教えてください</label>
  <p class="mb-1 w-9/12 mx-auto text-right">
    <span class="ml-2 text-red-600">{{ error }}</span>
  </p>
  <input
    id="age"
    class="form-field text-right"
    type="text"
    :value="age"
    :class="error ? 'form-field-error' : 'form-field'"
    @change="handleChange"
    placeholder="30"
  /><span class="form-supplement">歳</span>
</template>

<script setup>
import { onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { useField } from 'vee-validate'
import { useGlobalStore } from '../../store/global'

const { simulation } = useGlobalStore()
const params = $computed(() => simulation.params)

let { value: age, errorMessage: error, handleChange } = useField('age')

onMounted(() => {
  age.value = params.age
  simulation.setCurrentStep(useRoute().name)
})
</script>
