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
import { inject, computed } from 'vue'
import { useField } from 'vee-validate'

const formData = inject('FORM_DATA')
const ageValue = computed({
  get: () => age.value || formData.value.age,
  set: (value) => {
    age.value = value
  }
})
let { value: age, errorMessage: error, handleChange } = useField('age')
const setDefaultValue = () => (age.value = formData.value.age)
setDefaultValue()
</script>
