<template>
  <button
    type="button"
    class="group relative w-40 cursor-pointer rounded-full border-0 bg-accent p-3 text-xs text-white shadow-xl hover:opacity-80 focus:outline-none md:w-48 md:text-sm"
    data-test-id="completeInsuranceButton"
    @click="completeInsurance"
  >
    <span
      class="invisible absolute left-1/2 -bottom-10 inline-block -translate-x-1/2 whitespace-nowrap rounded-xl bg-gray px-4 py-2 text-xs leading-tight text-white opacity-0 duration-200 ease-in before:absolute before:left-1/2 before:-top-3 before:-ml-2 before:border-8 before:border-b-8 before:border-solid before:border-transparent before:border-b-gray before:content-[''] group-hover:visible group-hover:opacity-100 md:-bottom-12"
      >{{ tooltipText }}</span
    >
    <i class="fas fa-robot mr-2"></i>おまかせで入力する
  </button>
</template>

<script setup>
import { ref } from 'vue'

const emit = defineEmits(['completeInsurance'])
const props = defineProps({
  salary: {
    type: Number,
    required: true
  }
})

const defaultText = '所得の値からざっくり計算します'
const tooltipText = ref(defaultText)

const completeInsurance = () => {
  // 「ざっくり」補完なので、都道府県にかかわらず東京都の平均値である給与の15%で計算する
  // 社会保険料は以下の要素から構成され、令和3年度における東京都/一般事業の場合の料率は次の通り
  // 健康保険料（9.90%）、厚生年金保険料（19.3%）、介護保険料（1.73%）、雇用保険料（0.3%）、労災保険料（0.3%）
  // また社会保険料は雇用者と折半となるため、その割合はおよそ15%になることを根拠として、この値での計算を行う
  const socialInsuranceRate = 15 / 100
  const insurance = Math.round((props.salary * socialInsuranceRate) / 100) * 100
  emit('completeInsurance', insurance)
  tooltipText.value = '値を設定しました！'
  setTimeout(() => {
    tooltipText.value = defaultText
  }, 1000)
}
</script>
