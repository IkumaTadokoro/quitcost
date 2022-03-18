<template>
  <label for="postalCode" class="form-label whitespace-nowrap">
    お住まいの地域の郵便番号を教えてください
  </label>
  <input
    id="postalCode"
    class="form-field text-center"
    type="text"
    v-maska="{ mask: '###-####' }"
    :value="postalCode"
    @change="handleChange"
    @blur="setAddress"
    placeholder="100-0004"
  />
  <p class="form-tips">
    <i class="fas fa-info-circle mr-2"></i>お住まいの地域： {{ address }}
  </p>
  <p class="form-error">{{ error }}</p>
  <p v-if="!error" class="form-error">{{ addressError }}</p>
</template>

<script setup>
import { onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { useField } from 'vee-validate'
import axios from 'axios'
import axiosJsonpAdapter from 'axios-jsonp'
import { useGlobalStore } from '../../store/global'

const { simulation } = useGlobalStore()
const params = $computed(() => simulation.params)

let {
  value: postalCode,
  errorMessage: error,
  handleChange
} = useField('postalCode')
let { value: address, errorMessage: addressError } = useField('address')

const setAddress = async () => {
  address.value = ''

  if (!postalCode.value) return
  const zipCode = postalCode.value.replace(/[^\d]+/g, '')

  if (!/^\d{7}$/.test(zipCode)) return

  const url = `https://api.zipaddress.net/?zipcode=${zipCode}`
  const config = { adapter: axiosJsonpAdapter }

  try {
    const response = await axios.get(url, config)
    const { code, pref, city } = response.data
    if (!code) {
      address.value = `${pref} ${city}`
    } else {
      return
    }
  } catch (err) {
    console.warn(err)
  }
}

onMounted(async () => {
  postalCode.value = params.postalCode
  simulation.setCurrentStep(useRoute().name)
  if (postalCode.value) await setAddress()
})
</script>
