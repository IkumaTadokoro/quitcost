<template>
  <div class="text-center">
    <h2 class="form-label">年齢を教えてください</h2>
    <input
      class="form-field text-right"
      type="text"
      :value="age"
      @blur="handleChange"
      placeholder="30"
    /><span class="form-supplement">歳</span>
    <p class="form-error">{{ error }}</p>
  </div>
</template>

<script setup>
import { useField } from 'vee-validate'
const { value: age, errorMessage: error, handleChange } = useField('age')
</script>
