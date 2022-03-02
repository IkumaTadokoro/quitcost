<template>
  <div class="text-center">
    <h2 class="form-label">年齢を教えてください</h2>
    <input
      class="form-field text-right"
      type="text"
      :value="ageValue"
      @blur="handleChange"
      placeholder="30"
    /><span class="form-supplement">歳</span>
    <p class="form-error">{{ error }}</p>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { useField } from 'vee-validate'
import { useGlobalStore } from '../../store/global'

const { simulation } = useGlobalStore()
const params = $computed(() => simulation.params)

const ageValue = computed({
  get: () => age.value || params.age,
  set: (value) => (age.value = value)
})
let { value: age, errorMessage: error, handleChange } = useField('age')
const setDefaultValue = () => (age.value = params.age)
setDefaultValue()
</script>
