<template>
  <div class="container mx-auto">
    <header class="flex justify-between items-center">
      <h1 class="text-3xl py-4">国民健康保険料一覧</h1>
      <a
        href="/admin/insurances/new"
        class="inline-block text-white bg-primary border-0 py-2 px-4 focus:outline-none hover:bg-green-900 rounded-full text-sm"
        >新規登録</a
      >
    </header>
    <LoadingAnimation v-if="!insurances.length" />
    <div
      v-else
      class="overflow-x-auto bg-white rounded-md shadow overflow-y-auto relative mb-4"
    >
      <table class="table-auto w-full whitespace-no-wrap bg-white relative">
        <thead class="bg-boundaryBlack text-xs sticky top-0">
          <tr>
            <th class="admin-table-header">編集</th>
            <th class="admin-table-header">削除</th>
            <th class="admin-table-header">年度</th>
            <th class="admin-table-header">都道府県</th>
            <th class="admin-table-header">市区町村</th>
            <th class="admin-table-header">都道府県庁所在地</th>
            <th class="admin-table-header">所得割（医療分）</th>
            <th class="admin-table-header">資産割（医療分）</th>
            <th class="admin-table-header">均等割（医療分）</th>
            <th class="admin-table-header">平等割（医療分）</th>
            <th class="admin-table-header">限度額（医療分）</th>
            <th class="admin-table-header">所得割（後期高齢者支援分）</th>
            <th class="admin-table-header">資産割（後期高齢者支援分）</th>
            <th class="admin-table-header">均等割（後期高齢者支援分）</th>
            <th class="admin-table-header">平等割（後期高齢者支援分）</th>
            <th class="admin-table-header">限度額（後期高齢者支援分）</th>
            <th class="admin-table-header">所得割（介護分）</th>
            <th class="admin-table-header">資産割（介護分）</th>
            <th class="admin-table-header">均等割（介護分）</th>
            <th class="admin-table-header">平等割（介護分）</th>
            <th class="admin-table-header">限度額（介護分）</th>
            <th class="admin-table-header">1月</th>
            <th class="admin-table-header">2月</th>
            <th class="admin-table-header">3月</th>
            <th class="admin-table-header">4月</th>
            <th class="admin-table-header">5月</th>
            <th class="admin-table-header">6月</th>
            <th class="admin-table-header">7月</th>
            <th class="admin-table-header">8月</th>
            <th class="admin-table-header">9月</th>
            <th class="admin-table-header">10月</th>
            <th class="admin-table-header">11月</th>
            <th class="admin-table-header">12月</th>
          </tr>
        </thead>

        <tbody class="text-xs">
          <tr v-for="insurance in insurances" :key="insurance.id">
            <td class="admin-table-data-center">
              <a
                :href="insurance.edit_insurance_path"
                title="国民健康保険料編集"
                ><i class="fas fa-edit"></i>
              </a>
            </td>
            <td class="admin-table-data-center">
              <button @click="deleteInsurance(insurance.id)">
                <i class="fas fa-trash"></i>
              </button>
            </td>
            <td class="admin-table-data-center">{{ insurance.year }}</td>
            <td class="admin-table-data-center">
              {{ insurance.prefecture }}
            </td>
            <td class="admin-table-data-center whitespace-nowrap">
              {{ insurance.city }}
            </td>
            <td class="admin-table-data-center">
              {{ insurance.prefecture_capital ? '○' : '-' }}
            </td>
            <td class="admin-table-data-right">
              {{ formatPercent(insurance.medical_income_basis) }}
            </td>
            <td class="admin-table-data-right">
              {{ formatPercent(insurance.medical_asset_basis) }}
            </td>
            <td class="admin-table-data-right">
              {{ formatYen(insurance.medical_capita_basis) }}
            </td>
            <td class="admin-table-data-right">
              {{ formatYen(insurance.medical_household_basis) }}
            </td>
            <td class="admin-table-data-right">
              {{ formatYen(insurance.medical_limit) }}
            </td>
            <td class="admin-table-data-right">
              {{ formatPercent(insurance.elderly_income_basis) }}
            </td>
            <td class="admin-table-data-right">
              {{ formatPercent(insurance.elderly_asset_basis) }}
            </td>
            <td class="admin-table-data-right">
              {{ formatYen(insurance.elderly_capita_basis) }}
            </td>
            <td class="admin-table-data-right">
              {{ formatYen(insurance.elderly_household_basis) }}
            </td>
            <td class="admin-table-data-right">
              {{ formatYen(insurance.elderly_limit) }}
            </td>
            <td class="admin-table-data-right">
              {{ formatPercent(insurance.care_income_basis) }}
            </td>
            <td class="admin-table-data-right">
              {{ formatPercent(insurance.care_asset_basis) }}
            </td>
            <td class="admin-table-data-right">
              {{ formatYen(insurance.care_capita_basis) }}
            </td>
            <td class="admin-table-data-right">
              {{ formatYen(insurance.care_household_basis) }}
            </td>
            <td class="admin-table-data-right">
              {{ formatYen(insurance.care_limit) }}
            </td>
            <td class="admin-table-data-center">
              {{ insurance.january ? '○' : '-' }}
            </td>
            <td class="admin-table-data-center">
              {{ insurance.february ? '○' : '-' }}
            </td>
            <td class="admin-table-data-center">
              {{ insurance.march ? '○' : '-' }}
            </td>
            <td class="admin-table-data-center">
              {{ insurance.april ? '○' : '-' }}
            </td>
            <td class="admin-table-data-center">
              {{ insurance.may ? '○' : '-' }}
            </td>
            <td class="admin-table-data-center">
              {{ insurance.june ? '○' : '-' }}
            </td>
            <td class="admin-table-data-center">
              {{ insurance.july ? '○' : '-' }}
            </td>
            <td class="admin-table-data-center">
              {{ insurance.august ? '○' : '-' }}
            </td>
            <td class="admin-table-data-center">
              {{ insurance.september ? '○' : '-' }}
            </td>
            <td class="admin-table-data-center">
              {{ insurance.october ? '○' : '-' }}
            </td>
            <td class="admin-table-data-center">
              {{ insurance.november ? '○' : '-' }}
            </td>
            <td class="admin-table-data-center">
              {{ insurance.december ? '○' : '-' }}
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    <nav class="flex justify-center py-4">
      <v-pagination
        v-model="currentPage"
        :pages="totalPages"
        :range-size="1"
        active-color="#117766"
        @update:modelValue="switchPage"
      />
    </nav>
  </div>
</template>

<script setup>
import { computed, ref } from 'vue'
import VPagination from '@hennge/vue3-pagination'
import '@hennge/vue3-pagination/dist/vue3-pagination.css'
import { useFormat } from '../composables/useFormat'
import Swal from 'sweetalert2'
import LoadingAnimation from './LoadingAnimation'

const { formatYen, formatPercent } = useFormat()

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

const token = () => {
  const meta = document.querySelector('meta[name="csrf-token"]')
  return meta ? meta.getAttribute('content') : ''
}

// FIXME: toastにデザインを適用する
const toast = (title) => {
  Swal.fire({
    title: title,
    toast: true,
    position: 'top-end',
    showConfirmButton: false,
    timer: 3000,
    timerProgressBar: true
  })
}

const deleteInsurance = async (insuranceId) => {
  const insuranceAPI = `/api/insurances/${insuranceId}`
  const result = confirm('本当にこのレコードを削除しますか')
  if (result) {
    await fetch(insuranceAPI, {
      method: 'DELETE',
      headers: {
        'X-Requested-With': 'XMLHttpRequest',
        'X-CSRF-Token': token()
      },
      credentials: 'same-origin',
      redirect: 'manual'
    })
    toast('保険料率を削除しました。')
    await getInsurances()
  }
}

const switchPage = (pageNum) => {
  currentPage.value = pageNum
  history.pushState(null, null, newUrl.value)
  getInsurances()
}

getInsurances()

window.addEventListener('popstate', () => {
  location.href = window.location.href
})
</script>
