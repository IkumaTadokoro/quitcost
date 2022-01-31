<template>
  <div class="container mx-auto">
    <div class="mx-auto">
      <div class="flex justify-between items-center">
        <div>
          <h1 class="text-3xl py-4 font-sans font-bold">国民健康保険料一覧</h1>
        </div>
        <div>
          <a
            href="/insurances/new"
            class="inline-block text-white bg-green-700 border-0 py-2 px-4 focus:outline-none hover:bg-green-800 rounded-full text-sm"
            >新規登録</a
          >
        </div>
      </div>
      <div v-if="!insurances.length" class="flex justify-center my-64">
        <div class="animate-ping h-2 w-2 bg-green-800 rounded-full"></div>
        <div class="animate-ping h-2 w-2 bg-green-800 rounded-full mx-8"></div>
        <div class="animate-ping h-2 w-2 bg-green-800 rounded-full"></div>
      </div>
      <div
        v-else
        class="overflow-x-auto bg-white rounded-lg shadow overflow-y-auto relative mb-4"
      >
        <table
          class="border-collapse table-auto w-full whitespace-no-wrap bg-white table-striped relative"
        >
          <thead class="bg-gray-200 text-xs sticky top-0">
            <tr>
              <th class="px-4 py-4 whitespace-nowrap">編集</th>
              <th class="px-2 py-4 whitespace-nowrap">削除</th>
              <th class="px-2 py-4 whitespace-nowrap">年度</th>
              <th class="px-2 py-4 whitespace-nowrap">都道府県</th>
              <th class="px-2 py-4 whitespace-nowrap">市区町村</th>
              <th class="px-2 py-4 whitespace-nowrap">都道府県庁所在地</th>
              <th class="px-2 py-4 whitespace-nowrap">所得割（医療分）</th>
              <th class="px-2 py-4 whitespace-nowrap">資産割（医療分）</th>
              <th class="px-2 py-4 whitespace-nowrap">均等割（医療分）</th>
              <th class="px-2 py-4 whitespace-nowrap">平等割（医療分）</th>
              <th class="px-2 py-4 whitespace-nowrap">限度額（医療分）</th>
              <th class="px-2 py-4 whitespace-nowrap">
                所得割（後期高齢者支援分）
              </th>
              <th class="px-2 py-4 whitespace-nowrap">
                資産割（後期高齢者支援分）
              </th>
              <th class="px-2 py-4 whitespace-nowrap">
                均等割（後期高齢者支援分）
              </th>
              <th class="px-2 py-4 whitespace-nowrap">
                平等割（後期高齢者支援分）
              </th>
              <th class="px-2 py-4 whitespace-nowrap">
                限度額（後期高齢者支援分）
              </th>
              <th class="px-2 py-4 whitespace-nowrap">所得割（介護分）</th>
              <th class="px-2 py-4 whitespace-nowrap">資産割（介護分）</th>
              <th class="px-2 py-4 whitespace-nowrap">均等割（介護分）</th>
              <th class="px-2 py-4 whitespace-nowrap">平等割（介護分）</th>
              <th class="px-2 py-4 whitespace-nowrap">限度額（介護分）</th>
              <th class="px-2 py-4 whitespace-nowrap">1月</th>
              <th class="px-2 py-4 whitespace-nowrap">2月</th>
              <th class="px-2 py-4 whitespace-nowrap">3月</th>
              <th class="px-2 py-4 whitespace-nowrap">4月</th>
              <th class="px-2 py-4 whitespace-nowrap">5月</th>
              <th class="px-2 py-4 whitespace-nowrap">6月</th>
              <th class="px-2 py-4 whitespace-nowrap">7月</th>
              <th class="px-2 py-4 whitespace-nowrap">8月</th>
              <th class="px-2 py-4 whitespace-nowrap">9月</th>
              <th class="px-2 py-4 whitespace-nowrap">10月</th>
              <th class="px-2 py-4 whitespace-nowrap">11月</th>
              <th class="px-2 py-4 whitespace-nowrap">12月</th>
            </tr>
          </thead>

          <tbody class="text-xs">
            <tr v-for="insurance in insurances" :key="insurance.id">
              <td class="border-t border-gray-200 px-2 py-2 text-center">
                <i class="fas fa-edit"></i>
              </td>
              <td class="border-t border-gray-200 px-2 py-2 text-center">
                <i class="fas fa-trash"></i>
              </td>
              <td class="border-t border-gray-200 px-2 py-2 text-center">
                {{ insurance.year }}
              </td>
              <td class="border-t border-gray-200 px-2 py-2 text-center">
                {{ insurance.prefecture }}
              </td>
              <td
                class="border-t border-gray-200 px-2 py-2 text-center whitespace-nowrap"
              >
                {{ insurance.city }}
              </td>
              <td class="border-t border-gray-200 px-2 py-2 text-center">
                {{ insurance.prefecture_capital ? '○' : '-' }}
              </td>
              <td class="border-t border-gray-200 px-2 py-2 text-right">
                {{ formatPercent(insurance.medical_income_basis) }}
              </td>
              <td class="border-t border-gray-200 px-2 py-2 text-right">
                {{ formatPercent(insurance.medical_asset_basis) }}
              </td>
              <td class="border-t border-gray-200 px-2 py-2 text-right">
                {{ formatNumber(insurance.medical_capita_basis) }}
              </td>
              <td class="border-t border-gray-200 px-2 py-2 text-right">
                {{ formatNumber(insurance.medical_household_basis) }}
              </td>
              <td class="border-t border-gray-200 px-2 py-2 text-right">
                {{ formatNumber(insurance.medical_limit) }}
              </td>
              <td class="border-t border-gray-200 px-2 py-2 text-right">
                {{ formatPercent(insurance.elderly_income_basis) }}
              </td>
              <td class="border-t border-gray-200 px-2 py-2 text-right">
                {{ formatPercent(insurance.elderly_asset_basis) }}
              </td>
              <td class="border-t border-gray-200 px-2 py-2 text-right">
                {{ formatNumber(insurance.elderly_capita_basis) }}
              </td>
              <td class="border-t border-gray-200 px-2 py-2 text-right">
                {{ formatNumber(insurance.elderly_household_basis) }}
              </td>
              <td class="border-t border-gray-200 px-2 py-2 text-right">
                {{ formatNumber(insurance.elderly_limit) }}
              </td>
              <td class="border-t border-gray-200 px-2 py-2 text-right">
                {{ formatPercent(insurance.care_income_basis) }}
              </td>
              <td class="border-t border-gray-200 px-2 py-2 text-right">
                {{ formatPercent(insurance.care_asset_basis) }}
              </td>
              <td class="border-t border-gray-200 px-2 py-2 text-right">
                {{ formatNumber(insurance.care_capita_basis) }}
              </td>
              <td class="border-t border-gray-200 px-2 py-2 text-right">
                {{ formatNumber(insurance.care_household_basis) }}
              </td>
              <td class="border-t border-gray-200 px-2 py-2 text-right">
                {{ formatNumber(insurance.care_limit) }}
              </td>
              <td class="border-t border-gray-200 px-2 py-2 text-center">
                {{ insurance.january ? '○' : '-' }}
              </td>
              <td class="border-t border-gray-200 px-2 py-2 text-center">
                {{ insurance.february ? '○' : '-' }}
              </td>
              <td class="border-t border-gray-200 px-2 py-2 text-center">
                {{ insurance.march ? '○' : '-' }}
              </td>
              <td class="border-t border-gray-200 px-2 py-2 text-center">
                {{ insurance.april ? '○' : '-' }}
              </td>
              <td class="border-t border-gray-200 px-2 py-2 text-center">
                {{ insurance.may ? '○' : '-' }}
              </td>
              <td class="border-t border-gray-200 px-2 py-2 text-center">
                {{ insurance.june ? '○' : '-' }}
              </td>
              <td class="border-t border-gray-200 px-2 py-2 text-center">
                {{ insurance.july ? '○' : '-' }}
              </td>
              <td class="border-t border-gray-200 px-2 py-2 text-center">
                {{ insurance.august ? '○' : '-' }}
              </td>
              <td class="border-t border-gray-200 px-2 py-2 text-center">
                {{ insurance.september ? '○' : '-' }}
              </td>
              <td class="border-t border-gray-200 px-2 py-2 text-center">
                {{ insurance.october ? '○' : '-' }}
              </td>
              <td class="border-t border-gray-200 px-2 py-2 text-center">
                {{ insurance.november ? '○' : '-' }}
              </td>
              <td class="border-t border-gray-200 px-2 py-2 text-center">
                {{ insurance.december ? '○' : '-' }}
              </td>
            </tr>
          </tbody>
        </table>
      </div>
      <div class="flex justify-center py-4">
        <v-pagination
          v-model="currentPage"
          :pages="totalPages"
          :range-size="1"
          active-color="#117766"
          @update:modelValue="switchPage"
        />
      </div>
    </div>
  </div>
</template>

<script>
import { computed, ref } from 'vue'
import VPagination from '@hennge/vue3-pagination'
import '@hennge/vue3-pagination/dist/vue3-pagination.css'

export default {
  components: {
    VPagination
  },
  setup() {
    const pageParam = () => {
      const url = new URL(location.href)
      const page = url.searchParams.get('page')
      return parseInt(page || 1)
    }

    const insurances = ref([])
    const totalPages = ref(0)
    const currentPage = ref(pageParam())

    const newParams = computed(() => {
      const params = new URL(location.href).searchParams
      params.set('page', currentPage.value)
      return params
    })

    const newUrl = computed(() => {
      return `${location.pathname}?${newParams.value}`
    })

    const getInsurances = async () => {
      const insurancesAPI = `/api/insurances.json?${newParams.value}`
      const response = await fetch(insurancesAPI, {
        method: 'GET',
        headers: { 'X-Requested-With': 'XMLHttpRequest' },
        credentials: 'same-origin',
        redirect: 'manual'
      })
      const json = await response
        .json()
        .catch((e) => console.warn('Failed to parsing', e))
      insurances.value = json.insurance
      totalPages.value = parseInt(json.totalPages)
    }

    const switchPage = (pageNum) => {
      currentPage.value = pageNum
      history.pushState(null, null, newUrl.value)
      getInsurances()
    }

    // e.g. 30000 → ¥30,000
    const formatNumber = (number) => {
      return new Intl.NumberFormat('ja', {
        style: 'currency',
        currency: 'JPY',
        currencyDisplay: 'symbol'
      }).format(number)
    }

    // e.g. 7.1 → 7.10%
    const formatPercent = (decimal) => {
      return `${new Intl.NumberFormat('ja', {
        minimumFractionDigits: 2
      }).format(decimal)}%`
    }

    getInsurances()

    window.addEventListener('popstate', () => {
      location.href = window.location.href
    })

    return {
      insurances,
      totalPages,
      currentPage,
      formatNumber,
      formatPercent,
      switchPage
    }
  }
}
</script>
