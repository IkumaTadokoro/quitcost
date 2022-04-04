<template>
  <div class="fixed z-10 inset-0 overflow-y-auto bg-black bg-opacity-50">
    <div class="flex items-start justify-center min-h-screen pt-56">
      <div
        class="border-0 rounded-lg shadow-lg relative flex flex-col w-11/12 md:w-5/12 bg-white outline-none focus:outline-none"
      >
        <header
          class="flex items-start justify-between p-5 border-b border-solid border-boundaryBlack rounded-t"
        >
          <h3 class="text-xl">エラーが発生しました</h3>
        </header>
        <article class="relative p-4 flex-auto">
          <p class="text-black text-xs md:text-sm leading-relaxed">
            画面をリロードするか、時間をおいて、もう一度最初からお試しください。
          </p>
          <p class="mt-1 text-black text-xs md:text-sm leading-relaxed">
            エラーが出続ける場合は以下の「Twitterから連絡」から @ikuma-t
            までご連絡ください。
          </p>
        </article>
        <footer
          class="flex items-center justify-end p-2 border-t border-solid border-boundaryBlack rounded-b"
        >
          <a
            class="text-white bg-sky-500 border border-solid rounded-md text-xs px-3 py-3 rounded outline-none focus:outline-none mr-1 mb-1"
            href="https://twitter.com/ikumatdkr"
            target="_blank"
            rel="noopener noreferrer"
          >
            Twitterから連絡
          </a>
          <button
            class="text-white bg-primary border border-solid rounded-md text-xs px-3 py-3 rounded outline-none focus:outline-none mr-1 mb-1"
            @click="moveForm"
          >
            最初からやり直す
          </button>
        </footer>
      </div>
    </div>
  </div>
</template>

<script setup>
import { useRouter } from 'vue-router'
import { useGlobalStore } from '../store/global'

const router = useRouter()
const { simulation } = useGlobalStore()

const moveForm = () => {
  router.push('/simulations/new')
  simulation.reset()
}
</script>
