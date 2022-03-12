<template>
  <button
    type="button"
    class="border-0 w-48 p-3 focus:outline-none rounded-full text-sm bg-accent text-white hover:opacity-80 shadow-xl group relative cursor-pointer"
    @click="completeInsurance"
  >
    <span
      class="group-hover:opacity-100 group-hover:visible invisible opacity-0 absolute left-1/2 -translate-x-1/2 inline-block px-4 py-2 -bottom-12 whitespace-nowrap text-xs leading-tight bg-gray text-white rounded-xl ease-in duration-200 before:content-[''] before:absolute before:left-1/2 before:-top-3 before:-ml-2 before:border-8 before:border-solid before:border-transparent before:border-b-8 before:border-b-gray"
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
