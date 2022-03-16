<template>
  <LoadingAnimation v-if="loading" />
  <div v-else>
    <div class="max-w-screen-lg mx-auto pt-32 text-center">
      <div class="mb-6 mx-32">
        <p class="text-3xl">
          {{ formatDate(result.retirement_month) }}に退職して、{{
            formatDate(result.employment_month)
          }}に就職すると...
        </p>
      </div>
      <div class="mb-10 mx-42">
        <p>
          <span>約</span>
          <span class="mx-6">
            <span class="text-8xl text-primary">{{
              formatAmount(result.grand_total)
            }}</span>
            <span class="text-3xl text-primary ml-2">円</span>
          </span>
          <span>かかります</span>
        </p>
      </div>
      <div class="mb-20 mx-72 flex justify-between">
        <div class="flex-1">
          <p
            class="text-sm underline underline-offset-2 decoration-4 decoration-primary"
          >
            国民健康保険
          </p>
          <p class="text-xl mt-2">
            {{ formatAmount(result.sub_total.insurance) }}円
          </p>
        </div>
        <div class="flex-1">
          <p
            class="text-sm underline underline-offset-2 decoration-4 decoration-red-600"
          >
            国民年金
          </p>
          <p class="text-xl mt-2">
            {{ formatAmount(result.sub_total.pension) }}円
          </p>
        </div>
        <div class="flex-1">
          <p
            class="text-sm underline underline-offset-2 decoration-4 decoration-yellow-500"
          >
            住民税
          </p>
          <p class="text-xl mt-2">
            {{ formatAmount(result.sub_total.residence) }}円
          </p>
        </div>
      </div>
      <div class="flex flex-wrap justify-around mb-52 mx-52">
        <button
          class="text-lg w-64 flex justify-between items-center bg-primary text-white rounded-full px-8 py-5 ease-in duration-100 hover:bg-white hover:text-gray border-4 border-primary before:content-[''] before:w-3 before:h-3 before:rotate-45 before:border-solid before:border-white before:border-b-4 before:border-l-4 before:hover:border-gray"
          @click="moveForm"
        >
          もういちど計算する
        </button>
        <button
          class="text-lg w-60 flex justify-evenly items-center bg-accent text-white rounded-full px-8 py-5 ease-in duration-100 hover:bg-white hover:text-gray border-4 border-accent after:content-[''] after:w-3 after:h-3 after:rotate-45 after:border-solid after:border-white after:border-t-4 after:border-r-4 after:hover:border-gray"
          @click="scrollDetail"
        >
          詳細をみる
        </button>
      </div>
    </div>
    <div class="bg-secondary py-12" id="detail">
      <div class="max-w-screen-lg mx-auto p-12">
        <h2
          class="text-center text-3xl mb-12 underline underline-offset-8 decoration-4 decoration-primary"
        >
          個人負担額の詳細
        </h2>
        <div
          v-for="monthly_payment in result.monthly_payment"
          :key="monthly_payment.month"
          class="px-8 py-8 mb-4 last:mb-0 shadow-md bg-white rounded-xl"
        >
          <div class="separator">
            <p class="text-xl">
              {{ formatDate(monthly_payment.month) }}
            </p>
          </div>
          <div class="px-2 pt-4">
            <ul>
              <li
                class="type-icon before:content-['健康保険'] mb-4 before:bg-primary"
              >
                {{ formatAmount(monthly_payment.fee.insurance) }}円
              </li>
              <li
                class="type-icon before:content-['国民年金'] mb-4 before:bg-red-600"
              >
                {{ formatAmount(monthly_payment.fee.pension) }}円
              </li>
              <li
                class="type-icon before:content-['住民税'] before:bg-yellow-500"
              >
                {{ formatAmount(monthly_payment.fee.residence) }}円
              </li>
            </ul>
          </div>
        </div>
      </div>
      <div class="flex justify-center">
        <button
          class="w-52 flex justify-evenly items-center bg-primary text-white rounded-full px-8 py-5 ease-in duration-100 hover:bg-white hover:text-gray border-4 border-primary after:content-[''] after:w-3 after:h-3 after:rotate-45 after:border-solid after:border-white after:border-l-4 after:border-t-4 after:hover:border-gray"
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
import { useGlobalStore } from '../store/global'
import LoadingAnimation from './LoadingAnimation'

const router = useRouter()
const { simulation } = useGlobalStore()

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
  simulation.reset()
}
</script>

<style scoped>
.separator {
  @apply flex items-center after:content-[''] after:border-t-2 after:border-boundaryBlack after:border-solid after:flex-1 after:ml-2;
}

.type-icon {
  @apply relative before:left-0 before:top-1/2 before:-translate-y-2/4 pl-24 before:inline-block before:text-white before:rounded-md before:text-xs before:h-6 before:w-20 before:leading-6 before:absolute before:text-center;
}
</style>
