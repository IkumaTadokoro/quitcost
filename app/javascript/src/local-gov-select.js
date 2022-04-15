import Choices from 'choices.js'

document.addEventListener('DOMContentLoaded', () => {
  const element = document.getElementById('js-local-gov-select')
  if (element) {
    return new Choices(element, {
      removeItemButton: true,
      allowHTML: true,
      shouldSort: false,
      searchResultLimit: 5,
      searchPlaceholderValue: '市区町村名を入力してください',
      noResultsText: '一致する情報は見つかりません',
      itemSelectText: '選択'
    })
  }
})
