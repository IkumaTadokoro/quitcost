<template>
  <div class="fixed inset-0 z-10 overflow-y-auto bg-black bg-opacity-50">
    <div class="flex min-h-screen items-start justify-center pt-56">
      <div
        class="relative flex w-11/12 flex-col rounded-lg border-0 bg-white shadow-lg outline-none focus:outline-none md:w-5/12"
      >
        <header
          class="flex items-start justify-between rounded-t border-b border-solid border-boundaryBlack p-5"
        >
          <h3 class="text-xl">エラーが発生しました</h3>
        </header>
        <article class="relative flex-auto p-4">
          <p class="text-xs leading-relaxed text-black md:text-sm">
            画面をリロードするか、時間をおいて、もう一度最初からお試しください。
          </p>
          <p class="mt-1 text-xs leading-relaxed text-black md:text-sm">
            エラーが出続ける場合は以下の「Twitterから連絡」から @ikuma-t
            までご連絡ください。
          </p>
        </article>
        <footer
          class="flex items-center justify-end rounded-b border-t border-solid border-boundaryBlack p-2"
        >
          <a
            class="mr-1 mb-1 rounded-md rounded border border-solid bg-sky-500 px-3 py-3 text-xs text-white outline-none focus:outline-none"
            href="https://twitter.com/ikumatdkr"
            target="_blank"
            rel="noopener noreferrer"
          >
            Twitterから連絡
          </a>
          <button
            class="mr-1 mb-1 rounded-md rounded border border-solid bg-primary px-3 py-3 text-xs text-white outline-none focus:outline-none"
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
