import {
  addMonths,
  subMonths,
  addYears,
  subYears,
  lastDayOfMonth
} from 'date-fns'

export const useFinancialYear = (
  date,
  beginning_of_fiscal_year = 1,
  date_beginning_of_fiscal_year = beginning_of_fiscal_year
) => {
  const year =
    date_beginning_of_fiscal_year === 1
      ? date.getFullYear()
      : subMonths(date, date_beginning_of_fiscal_year - 1).getFullYear()
  const beginningOfYear = new Date(year, beginning_of_fiscal_year - 1, 1)
  const nextBeginningOfYear = addYears(beginningOfYear, 1)
  const lastBeginningOfYear = subYears(beginningOfYear, 1)
  const beforeLastBeginningOfYear = subYears(beginningOfYear, 2)
  const endOfYear = lastDayOfMonth(addMonths(beginningOfYear, 11))
  const nextEndOfYear = addYears(endOfYear, 1)
  const lastEndOfYear = subYears(endOfYear, 1)
  const beforeLastEndOfYear = subYears(endOfYear, 2)

  return {
    beginningOfYear,
    nextBeginningOfYear,
    lastBeginningOfYear,
    beforeLastBeginningOfYear,
    endOfYear,
    nextEndOfYear,
    lastEndOfYear,
    beforeLastEndOfYear,
    year
  }
}
