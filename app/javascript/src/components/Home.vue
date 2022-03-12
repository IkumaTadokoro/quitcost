<template>
  <div>
    <div class="container mx-auto pt-8 pb-6">
      <div class="md:max-w-3xl mb-6 mx-auto px-4">
        <img src="~logo.svg" alt="" />
      </div>
      <div class="md:max-w-6xl mb-6 mx-auto bg-secondary p-2">
        <p class="text-center text-xs md:text-base">
          転職準備のために仕事をやめたいけど、お金が心配...。
        </p>
        <p class="text-center text-xs md:text-base">
          いくつかの質問に答えるだけで、無職期間でどれだけ「保険」「税金」「年金」がかかるか計算できます
        </p>
      </div>
      <div class="flex justify-center">
        <button
          class="border-0 w-40 md:w-56 p-4 md:p-6 focus:outline-none rounded-full text-sm md:text-lg bg-primary text-white hover:bg-accent shadow-xl"
          @click="moveForm"
        >
          いますぐ計算する
        </button>
      </div>
    </div>
  </div>
  <div class="bg-boundaryBlack">
    <div class="container mx-auto py-8">
      <div
        class="md:max-w-6xl mx-auto bg-white md:rounded-lg px-4 md:px-12 py-6"
      >
        <div class="mb-6">
          <h2
            class="text-lg md:text-2xl text-center underline underline-offset-8 decoration-4 decoration-primary"
          >
            準備するもの
          </h2>
        </div>
        <div class="flex flex-wrap gap-y-4">
          <div class="w-full md:w-1/2 px-4">
            <p class="text-sm md:text-lg text-center mb-2 text-gray">
              住民税決定通知書
            </p>
            <img src="~dummy.svg" alt="" class="block mx-auto" />
          </div>
          <div class="w-full md:w-1/2 px-4">
            <p class="text-sm md:text-lg text-center mb-2 text-gray">
              今年1月から現在までの給与明細
            </p>
            <img src="~dummy.svg" alt="" class="block mx-auto" />
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import 'logo.svg'
import 'dummy.svg'
import { useRouter } from 'vue-router'
import { useGlobalStore } from '../store/global'

const router = useRouter()
const { simulation } = useGlobalStore()

const moveForm = () => {
  router.push('/simulations/new')
  simulation.reset()
}
</script>
