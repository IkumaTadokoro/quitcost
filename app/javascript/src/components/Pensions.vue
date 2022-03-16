<template>
  <div class="container mx-auto">
    <div class="mx-auto">
      <header class="flex justify-between items-center">
        <h1 class="text-3xl py-4">国民年金保険料一覧</h1>
        <a
          href="/admin/pensions/new"
          class="inline-block text-white bg-primary border-0 py-2 px-4 focus:outline-none hover:bg-green-900 rounded-full text-sm"
          >新規登録</a
        >
      </header>
      <LoadingAnimation v-if="!pensions.length" />
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
                <button @click="destroy(pension.id)">
                  <i class="fas fa-trash"></i>
                </button>
              </td>
              <td class="admin-table-data-center">
                {{ pension.year }}
              </td>
              <td class="admin-table-data-center">
                {{ formatYen(pension.contribution) }}
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
  </div>
</template>

<script setup>
import { onMounted, ref } from 'vue'
import VPagination from '@hennge/vue3-pagination'
import '@hennge/vue3-pagination/dist/vue3-pagination.css'
import Swal from 'sweetalert2'
import LoadingAnimation from './LoadingAnimation'
import { useFormat } from '../composables/useFormat'
import { usePensions } from '../composables/usePensions'

const { formatYen } = useFormat()
const { pensions, totalPages, getPensions, deletePension } = usePensions()

const pageParam = () => {
  const url = new URL(location.href)
  const page = url.searchParams.get('page')
  return parseInt(page || 1)
}

const currentPage = ref(pageParam())

const newParams = $computed(() => {
  const params = new URL(location.href).searchParams
  params.set('page', currentPage.value)
  return params
})

const newUrl = $computed(() => `${location.pathname}?${newParams}`)

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

const destroy = async (pensionId) => {
  const result = confirm('本当にこのレコードを削除しますか')
  if (result) await deletePension(pensionId)
  toast('保険料率を削除しました。')
  await getPensions(newParams)
}

const switchPage = (pageNum) => {
  currentPage.value = pageNum
  history.pushState(null, null, newUrl)
  getPensions(newParams)
}

onMounted(() => getPensions(newParams))

window.addEventListener('popstate', () => {
  location.href = window.location.href
})
</script>
