<template>
  <div class="container mx-auto">
    <div class="mx-auto">
      <div class="flex justify-between items-center">
        <div>
          <h1 class="text-3xl py-4">国民年金保険料一覧</h1>
        </div>
        <div>
          <a
            href="/pensions/new"
            class="inline-block text-white bg-primary border-0 py-2 px-4 focus:outline-none hover:bg-green-900 rounded-full text-sm"
            >新規登録</a
          >
        </div>
      </div>
      <div v-if="!pensions.length" class="flex justify-center my-64">
        <div class="animate-ping h-2 w-2 bg-green-800 rounded-full"></div>
        <div class="animate-ping h-2 w-2 bg-green-800 rounded-full mx-8"></div>
        <div class="animate-ping h-2 w-2 bg-green-800 rounded-full"></div>
      </div>
      <div
        v-else
        class="overflow-x-auto bg-white rounded-md shadow overflow-y-auto relative mb-4"
      >
        <table
          class="border-collapse table-auto w-full whitespace-no-wrap bg-white table-striped relative"
        >
          <thead class="bg-boundaryBlack text-xs sticky top-0">
            <tr>
              <th class="admin-table-header">編集</th>
              <th class="admin-table-header">削除</th>
              <th class="admin-table-header">年度</th>
              <th class="admin-table-header">保険料</th>
            </tr>
          </thead>

          <tbody class="text-xs">
            <tr v-for="pension in pensions" :key="pension.id">
              <td class="admin-table-data-center">
                <a :href="pension.edit_pension_path" title="国民年金保険料編集"
                  ><i class="fas fa-edit"></i>
                </a>
              </td>
              <td class="admin-table-data-center">
                <button @click="deletePension(pension.id)">
                  <i class="fas fa-trash"></i>
                </button>
              </td>
              <td class="admin-table-data-center">
                {{ pension.year }}
              </td>
              <td class="admin-table-data-center">
                {{ formatNumber(pension.contribution) }}
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
import Swal from 'sweetalert2'

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

    const pensions = ref([])
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

    const getPensions = async () => {
      const pensionsAPI = `/api/pensions.json?${newParams.value}`
      const response = await fetch(pensionsAPI, {
        method: 'GET',
        headers: { 'X-Requested-With': 'XMLHttpRequest' },
        credentials: 'same-origin',
        redirect: 'manual'
      })
      const json = await response
        .json()
        .catch((e) => console.warn('Failed to parsing', e))
      pensions.value = json.pensions
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

    const deletePension = async (pensionId) => {
      const pensionAPI = `/api/pensions/${pensionId}`
      const result = confirm('本当にこのレコードを削除しますか')
      if (result) {
        await fetch(pensionAPI, {
          method: 'DELETE',
          headers: {
            'X-Requested-With': 'XMLHttpRequest',
            'X-CSRF-Token': token()
          },
          credentials: 'same-origin',
          redirect: 'manual'
        })
        toast('保険料率を削除しました。')
        await getPensions()
      }
    }

    const switchPage = (pageNum) => {
      currentPage.value = pageNum
      history.pushState(null, null, newUrl.value)
      getPensions()
    }

    // e.g. 30000 → ¥30,000
    const formatNumber = (number) => {
      return new Intl.NumberFormat('ja', {
        style: 'currency',
        currency: 'JPY',
        currencyDisplay: 'symbol'
      }).format(number)
    }

    getPensions()

    window.addEventListener('popstate', () => {
      location.href = window.location.href
    })

    return {
      pensions,
      totalPages,
      currentPage,
      switchPage,
      formatNumber,
      deletePension
    }
  }
}
</script>
