import { useCurrencyFormat, useIntlNumberFormat } from 'vue-composable'

export function useFormat() {
  const lang = 'jp'
  const yenOption = { currency: 'JPY', currencyDisplay: 'symbol' }
  const percentOption = { style: 'decimal', minimumFractionDigits: 2 }
  const { formatString: formatYen } = useCurrencyFormat(yenOption, lang)
  const { formatString: formatPercent } = useIntlNumberFormat(
    percentOption,
    lang
  )

  return {
    formatYen,
    formatPercent
  }
}
