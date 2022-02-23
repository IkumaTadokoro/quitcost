<template>
  <div class="text-center">
    <h2 class="form-label whitespace-nowrap">
      お住まいの地域の郵便番号を教えてください
    </h2>
    <input
      class="form-field text-center"
      type="text"
      v-maska="{ mask: '###-####' }"
      v-model="postalCodeValue"
      @keyup="searchAddress"
      placeholder="100-0004"
    />
    <p class="form-tips">
      <i class="fas fa-info-circle mr-2"></i>お住まいの地域： {{ result }}
    </p>
    <p class="form-error">{{ error }}</p>
  </div>
</template>

<script setup>
import { inject, computed } from 'vue'
import { useField } from 'vee-validate'
import axios from 'axios'
import axiosJsonpAdapter from 'axios-jsonp'

let { value: postalCode, errorMessage: error } = useField('postalCode')
const formData = inject('FORM_DATA')
const postalCodeValue = computed({
  get: () => postalCode.value || formData.value.postalCode,
  set: (value) => {
    postalCode.value = value
  }
})
const result = computed(() => {
  if (!postalCode.value) return `該当する市区町村がありません`
  const zipCode = postalCode.value.replace(/[^\d]+/g, '')
  if (prefecture && city && /^\d{7}$/.test(zipCode)) {
    return `${prefecture} ${city}`
  } else {
    return `該当する市区町村がありません`
  }
})
let prefecture = $ref('')
let city = $ref('')
const searchAddress = async () => {
  const zipCode = postalCode.value.replace(/[^\d]+/g, '')
  if (!/^\d{7}$/.test(zipCode)) return
  const response = await axios.get(
    `https://api.zipaddress.net/?zipcode=${zipCode}`,
    { adapter: axiosJsonpAdapter }
  )
  prefecture = response.data.pref
  city = response.data.city
}
const setDefaultValue = () => (postalCode.value = formData.value.postalCode)
setDefaultValue()
</script>
