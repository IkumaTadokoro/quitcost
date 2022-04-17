<template>
  <div>
    <div class="container mx-auto pt-10 pb-6">
      <div class="mx-auto mb-6 px-4 md:max-w-3xl">
        <img src="~logo.svg" alt="quitcost" />
      </div>
      <div class="mx-auto mb-8 p-2 md:max-w-6xl">
        <p class="text-center text-xs leading-6 text-gray md:text-base">
          転職準備のために仕事をやめたいけど、お金が心配...。
          <br />
          いくつかの質問に答えるだけで、無職期間で<br
            class="md:hidden"
          />どれだけ「保険」「税金」「年金」がかかるか計算できます
        </p>
      </div>
      <div class="flex justify-center">
        <button
          class="flex w-60 items-center justify-between rounded-full border-4 border-primary bg-primary px-8 py-5 text-lg text-white duration-100 ease-in after:h-3 after:w-3 after:rotate-45 after:border-t-4 after:border-r-4 after:border-solid after:border-white after:content-[''] hover:bg-white hover:text-gray after:hover:border-gray"
          @click="moveForm"
        >
          いますぐ計算する
        </button>
      </div>
    </div>
  </div>
  <div class="bg-secondary">
    <div class="container mx-auto py-8">
      <div
        class="mx-auto bg-white px-4 py-6 shadow-sm md:max-w-4xl md:rounded-lg md:px-12"
      >
        <div class="mb-6">
          <h2
            class="mb-4 text-center text-lg underline decoration-primary decoration-4 underline-offset-8 md:text-2xl"
          >
            準備するもの（なくてもOK！）
          </h2>
          <p class="text-center text-xs text-gray md:text-sm">
            <i class="fas fa-info-circle mr-1"></i>
            額面の年収がだいたいいくらかわかれば計算できます！
          </p>
        </div>
        <div class="flex flex-wrap gap-y-4">
          <div class="w-full px-4 md:w-1/2">
            <p class="mb-2 text-center text-sm text-gray md:text-lg">
              住民税決定通知書
            </p>
            <img
              src="~residence.svg"
              alt="住民税決定通知書のイラスト"
              class="mx-auto block shadow-md"
            />
          </div>
          <div class="w-full px-4 md:w-1/2">
            <p class="mb-2 text-center text-sm text-gray md:text-lg">
              給与明細
            </p>
            <img
              src="~salary.svg"
              alt="給与明細のイラスト"
              class="mx-auto block shadow-md"
            />
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import 'logo.svg'
import 'residence.svg'
import 'salary.svg'
import { useRouter } from 'vue-router'
import { useGlobalStore } from '../store/global'

const router = useRouter()
const { simulation } = useGlobalStore()

const moveForm = () => {
  router.push('/simulations/new')
  simulation.reset()
}
</script>
