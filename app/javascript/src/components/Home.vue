<template>
  <div>
    <div class="container mx-auto pt-10 pb-6">
      <div class="md:max-w-3xl mb-6 mx-auto px-4">
        <img src="~logo.svg" alt="quitcost" />
      </div>
      <div class="md:max-w-6xl mb-8 mx-auto p-2">
        <p class="text-center text-xs md:text-base text-gray">
          転職準備のために仕事をやめたいけど、お金が心配...。
        </p>
        <p class="text-center text-xs md:text-base text-gray">
          いくつかの質問に答えるだけで、無職期間でどれだけ「保険」「税金」「年金」がかかるか計算できます
        </p>
      </div>
      <div class="flex justify-center">
        <button
          class="flex justify-between items-center bg-primary text-white rounded-full text-lg w-60 px-8 py-5 ease-in duration-100 hover:bg-white hover:text-gray border-4 border-primary after:content-[''] after:w-3 after:h-3 after:rotate-45 after:border-solid after:border-white after:border-t-4 after:border-r-4 after:hover:border-gray"
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
        class="md:max-w-6xl mx-auto bg-white md:rounded-lg px-4 md:px-12 py-6 shadow-sm"
      >
        <div class="mb-6">
          <h2
            class="text-lg md:text-2xl text-center underline underline-offset-8 decoration-4 decoration-primary mb-4"
          >
            準備するもの（なくてもOK！）
          </h2>
          <p class="text-xs md:text-sm text-center text-gray">
            <i class="fas fa-info-circle mr-1"></i>
            額面の年収がだいたいいくらかわかれば計算できます！
          </p>
        </div>
        <div class="flex flex-wrap gap-y-4">
          <div class="w-full md:w-1/2 px-4">
            <p class="text-sm md:text-lg text-center mb-2 text-gray">
              住民税決定通知書
            </p>
            <img
              src="~residence.svg"
              alt="住民税決定通知書のイラスト"
              class="block mx-auto shadow-md"
            />
          </div>
          <div class="w-full md:w-1/2 px-4">
            <p class="text-sm md:text-lg text-center mb-2 text-gray">
              給与明細
            </p>
            <img
              src="~salary.svg"
              alt="給与明細のイラスト"
              class="block mx-auto shadow-md"
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
