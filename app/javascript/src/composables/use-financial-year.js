import { addMonths, subMonths, subYears, lastDayOfMonth } from 'date-fns'

export const useFinancialYear = (
  date,
  beginning_of_fiscal_year = 1,
  date_beginning_of_fiscal_year = beginning_of_fiscal_year
) => {
  const year =
    date_beginning_of_fiscal_year === 1
      ? date.getFullYear()
      : subMonths(date, date_beginning_of_fiscal_year).getFullYear()
  const beginningOfYear = new Date(year, beginning_of_fiscal_year - 1, 1)
  const lastBeginningOfYear = subYears(beginningOfYear, 1)
  const endOfYear = lastDayOfMonth(addMonths(beginningOfYear, 11))
  const lastEndOfYear = subYears(endOfYear, 1)

  return {
    beginningOfYear: beginningOfYear,
    lastBeginningOfYear,
    endOfYear: endOfYear,
    lastEndOfYear,
    year
  }
}
