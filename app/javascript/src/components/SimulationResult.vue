<template>
  <LoadingAnimation v-if="loading" />
  <div v-else>
    <SimulationResultError v-if="simulationError" />
    <template v-else>
      <div class="pt-12 text-center md:mx-auto md:max-w-screen-lg md:pt-32">
        <div class="mb-6 flex flex-col md:flex-row md:justify-center">
          <p class="text-lg md:text-3xl">
            {{ formatDate(result.retirement_month) }}に退職して、
          </p>
          <p class="text-lg md:text-3xl">
            {{ formatDate(result.employment_month) }}に就職すると...
          </p>
        </div>
        <div
          class="md:mx-42 mb-10 flex flex-col gap-8 md:flex-row md:items-end md:justify-center md:gap-2"
        >
          <p>
            <span>約</span>
            <span class="mx-4">
              <span class="text-6xl tracking-wider text-primary md:text-8xl">{{
                formatAmount(result.grand_total)
              }}</span>
              <span class="ml-2 text-base text-primary md:text-3xl">円</span>
            </span>
          </p>
          <p>かかります</p>
        </div>
        <div
          class="mb-8 flex flex-col items-start px-24 md:mb-20 md:flex-row md:justify-center md:gap-x-4 md:px-56"
        >
          <div
            class="flex w-full flex-row items-center justify-between gap-y-2 md:basis-full md:flex-col"
          >
            <p
              class="text-xs underline decoration-primary decoration-4 underline-offset-2 md:text-sm"
            >
              国民健康保険
            </p>
            <p class="text-lg md:text-xl">
              {{ formatAmount(result.sub_total.insurance) }}円
            </p>
          </div>
          <div
            class="flex w-full flex-row items-center justify-between gap-y-2 md:basis-full md:flex-col"
          >
            <p
              class="text-xs underline decoration-red-600 decoration-4 underline-offset-2 md:text-sm"
            >
              国民年金
            </p>
            <p class="text-lg md:text-xl">
              {{ formatAmount(result.sub_total.pension) }}円
            </p>
          </div>
          <div
            class="flex w-full flex-row items-center justify-between gap-y-2 md:basis-full md:flex-col"
          >
            <p
              class="text-xs underline decoration-yellow-500 decoration-4 underline-offset-2 md:text-sm"
            >
              住民税
            </p>
            <p class="text-lg md:text-xl">
              {{ formatAmount(result.sub_total.residence) }}円
            </p>
          </div>
        </div>
        <div class="mb-8 flex flex-wrap justify-around md:mb-52 md:px-32">
          <button
            class="relative flex w-52 items-center justify-center rounded-full border-4 border-primary bg-primary px-6 py-5 text-sm text-white duration-100 ease-in before:absolute before:left-8 before:h-2 before:w-2 before:rotate-45 before:border-b-4 before:border-l-4 before:border-solid before:border-white before:content-[''] hover:bg-white hover:text-gray before:hover:border-gray md:w-64 md:pl-12 md:pr-4 md:text-lg md:before:h-3 md:before:w-3"
            @click="moveForm"
          >
            もういちど計算する
          </button>
          <button
            class="relative flex hidden w-64 items-center justify-center rounded-full border-4 border-accent bg-accent py-5 pr-8 pl-4 text-lg text-white duration-100 ease-in after:absolute after:right-8 after:h-3 after:w-3 after:rotate-45 after:border-t-4 after:border-r-4 after:border-solid after:border-white after:content-[''] hover:bg-white hover:text-gray after:hover:border-gray md:flex"
            @click="scrollDetail"
          >
            詳細をみる
          </button>
        </div>
      </div>
      <div class="bg-secondary py-4 md:py-12" id="detail">
        <div class="p-4 md:mx-auto md:max-w-screen-lg md:p-12">
          <h2
            class="mb-12 text-center text-xl underline decoration-primary decoration-4 underline-offset-8 md:text-3xl"
          >
            個人負担額の詳細
          </h2>
          <div
            v-for="monthly_payment in result.monthly_payment"
            :key="monthly_payment.month"
            class="mb-4 rounded-xl bg-white px-6 py-5 shadow-md last:mb-0 md:px-8 md:py-8"
          >
            <div class="separator">
              <p class="text-lg md:text-xl">
                {{ formatDate(monthly_payment.month) }}
              </p>
            </div>
            <div class="px-2 pt-4">
              <ul
                class="flex flex-col gap-y-3 md:flex-row md:items-center md:justify-around"
              >
                <li
                  class="type-icon before:bg-primary before:content-['健康保険']"
                >
                  {{ formatAmount(monthly_payment.fee.insurance) }}円
                </li>
                <li
                  class="type-icon before:bg-red-600 before:content-['国民年金']"
                >
                  {{ formatAmount(monthly_payment.fee.pension) }}円
                </li>
                <li
                  class="type-icon before:bg-yellow-500 before:content-['住民税']"
                >
                  {{ formatAmount(monthly_payment.fee.residence) }}円
                </li>
              </ul>
            </div>
          </div>
        </div>
        <div class="my-4 flex justify-center">
          <button
            class="flex w-48 items-center justify-evenly rounded-full border-4 border-primary bg-primary px-4 py-5 text-sm text-white duration-100 ease-in after:h-2 after:w-2 after:rotate-45 after:border-l-4 after:border-t-4 after:border-solid after:border-white after:content-[''] hover:bg-white hover:text-gray after:hover:border-gray md:w-52 md:px-8 md:text-lg md:after:h-3 md:after:w-3"
            @click="scrollTop"
          >
            ページ上部へ
          </button>
        </div>
      </div>
    </template>
  </div>
</template>

<script setup>
import { format } from 'date-fns'
import { useRouter } from 'vue-router'
import { useGlobalStore } from '../store/global'
import LoadingAnimation from './LoadingAnimation'
import SimulationResultError from './SimulationResultError'

const router = useRouter()
const { simulation } = useGlobalStore()

let result = $ref({})
let loading = $ref(false)
let simulationError = $ref(false)
const parameter = $computed(() => simulation.parameter)

const loadResult = async () => {
  loading = true
  simulationError = false
  try {
    const simulationApi = `/api/simulations?${parameter}`
    const response = await fetch(simulationApi, {
      method: 'GET',
      headers: { 'X-Requested-With': 'XMLHttpRequest' },
      credentials: 'same-origin',
      redirect: 'manual'
    })

    if (!response.ok) throw new Error(response.statusText)

    const json = await response.json()
    result = json.simulation
  } catch (e) {
    simulationError = true
  } finally {
    loading = false
  }
}

loadResult()

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
  @apply flex items-center after:ml-2 after:flex-1 after:border-t-2 after:border-solid after:border-boundaryBlack after:content-[''];
}

.type-icon {
  @apply relative pl-24 before:absolute before:left-0 before:top-1/2 before:inline-block before:h-6 before:w-20 before:-translate-y-2/4 before:rounded-md before:text-center before:text-xs before:leading-6 before:text-white;
}
</style>
