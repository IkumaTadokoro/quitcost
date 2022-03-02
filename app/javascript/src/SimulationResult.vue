<template>
  <div v-if="loading" class="flex justify-center my-64">
    <div class="animate-ping h-2 w-2 bg-green-800 rounded-full"></div>
    <div class="animate-ping h-2 w-2 bg-green-800 rounded-full mx-8"></div>
    <div class="animate-ping h-2 w-2 bg-green-800 rounded-full"></div>
  </div>
  <div v-else>
    <div class="max-w-screen-lg mx-auto pt-32 text-center">
      <div class="mb-6 mx-32">
        <p class="text-3xl font-bold">
          {{ formatDate(result.retirement_month) }}に退職して、{{
            formatDate(result.employment_month)
          }}に就職すると...
        </p>
      </div>
      <div class="mb-10 mx-42">
        <p>
          <span class="font-bold">約</span>
          <span class="mx-6">
            <span class="text-8xl text-green-700 font-bold">{{
              formatAmount(result.grand_total)
            }}</span>
            <span class="text-3xl text-green-700 font-bold ml-2">円</span>
          </span>
          <span class="font-bold">かかります</span>
        </p>
      </div>
      <div class="mb-20 mx-72 flex justify-between">
        <div class="flex-1">
          <p class="text-sm">国民健康保険料</p>
          <p class="text-xl font-semi-bold">
            {{ formatAmount(result.sub_total.insurance) }}円
          </p>
        </div>
        <div class="flex-1">
          <p class="text-sm">国民年金</p>
          <p class="text-xl font-semi-bold">
            {{ formatAmount(result.sub_total.pension) }}円
          </p>
        </div>
        <div class="flex-1">
          <p class="text-sm">住民税</p>
          <p class="text-xl font-semi-bold">
            {{ formatAmount(result.sub_total.residence) }}円
          </p>
        </div>
      </div>
      <div class="flex flex-wrap justify-around mb-52 mx-64">
        <button
          class="border-0 w-56 py-6 px-6 focus:outline-none rounded-full text-lg font-bold bg-green-700 text-white hover:bg-green-800 shadow-xl"
          @click="moveForm"
        >
          もういちど計算する
        </button>
        <button
          class="border-0 w-56 py-6 px-6 focus:outline-none rounded-full text-lg font-bold bg-amber-400 text-white hover:bg-amber-500 shadow-xl"
          @click="scrollDetail"
        >
          詳細をみる
        </button>
      </div>
    </div>
    <div class="bg-gray-200 py-28" id="detail">
      <div
        class="max-w-screen-lg mx-auto px-12 py-16 bg-white rounded-3xl mb-16"
      >
        <h2 class="text-center font-bold text-4xl mb-6">個人負担額の詳細</h2>
        <div
          v-for="monthly_payment in result.monthly_payment"
          :key="monthly_payment.month"
          class="px-6 mb-8"
        >
          <div class="separator">
            <p class="font-bold text-2xl">
              {{ formatDate(monthly_payment.month) }}
            </p>
          </div>
          <div class="px-8 pt-4">
            <ul>
              <li
                class="type-icon before:content-['保'] text-lg font-semi-bold mb-4"
              >
                当月分：{{ formatAmount(monthly_payment.fee.insurance) }}円
              </li>
              <li
                class="type-icon before:content-['年'] text-lg font-semi-bold mb-4"
              >
                当月分：{{ formatAmount(monthly_payment.fee.pension) }}円
              </li>
              <li
                class="type-icon before:content-['税'] text-lg font-semi-bold mb-4"
              >
                当月分：{{ formatAmount(monthly_payment.fee.residence) }}円
              </li>
            </ul>
          </div>
        </div>
      </div>
      <div class="flex justify-center">
        <button
          class="border-0 w-56 py-6 px-6 focus:outline-none rounded-full text-lg font-bold bg-green-100 text-gray-500 hover:bg-green-200 shadow-xl"
          @click="scrollTop"
        >
          ページ上部へ
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { format } from 'date-fns'
import { useRouter } from 'vue-router'
import { useGlobalStore } from './store/global'

const router = useRouter()
const { simulation, step } = useGlobalStore()

simulation.load_result()

const result = $computed(() => simulation.result)
const loading = $computed(() => simulation.loading)

const formatDate = (dateString) => {
  return format(new Date(dateString), 'yyyy年MM月')
}

const formatAmount = (amount) => {
  return new Intl.NumberFormat('ja').format(amount)
}

const scrollTop = () => {
  window.scrollTo({
    top: 0,
    behavior: 'smooth'
  })
}

const scrollDetail = () => {
  const element = document.getElementById('detail')
  element.scrollIntoView({
    behavior: 'smooth',
    block: 'start'
  })
}

const moveForm = () => {
  router.push('/simulations/new')
  step.reset()
  simulation.reset_params()
  simulation.reset_result()
}
</script>

<style scoped>
.separator {
  @apply flex items-center after:content-[''] after:border-t-2 after:border-gray-200 after:border-solid after:flex-1 after:ml-2;
}

.type-icon {
  @apply relative before:left-0 before:top-1/2 before:-translate-y-2/4 pl-10 before:inline-block before:bg-green-700 before:text-white before:font-bold before:rounded-full before:text-base before:h-8 before:w-8 before:leading-8 before:absolute before:text-center;
}
</style>
