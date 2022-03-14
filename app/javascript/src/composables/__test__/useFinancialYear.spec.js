import { useFinancialYear } from '../useFinancialYear'

describe('#beginningOfYear', () => {
  const date = new Date('2022-03-14')

  describe('when only date is given', () => {
    it('returns the beginning day of the year of the date', () => {
      const { beginningOfYear } = useFinancialYear(date)
      const expected = new Date('2022-01-01')
      expect(beginningOfYear).toEqual(expected)
    })
  })

  describe('when beginning_of_fiscal_year is January', () => {
    it('returns the beginning day of the year of the date', () => {
      const { beginningOfYear } = useFinancialYear(date, 1)
      const expected = new Date('2022-01-01')
      expect(beginningOfYear).toEqual(expected)
    })
  })

  describe('when beginning_of_fiscal_year is NOT January', () => {
    it('returns the beginning day of the FINANCIAL year of the date', () => {
      const { beginningOfYear } = useFinancialYear(date, 4)
      const expected = new Date('2021-04-01')
      expect(beginningOfYear).toEqual(expected)
    })
  })

  describe('when date_beginning_of_fiscal_year has the SAME value as beginning_of_fiscal_year', () => {
    it('returns the beginning day of the FINANCIAL year of the date', () => {
      const { beginningOfYear } = useFinancialYear(date, 4, 4)
      const expected = new Date('2021-04-01')
      expect(beginningOfYear).toEqual(expected)
    })
  })

  describe('when date_beginning_of_fiscal_year has the DIFFERENT value from beginning_of_fiscal_year', () => {
    it('calculates the FINANCIAL based on date_beginning_of_fiscal_year and returns the beginning day of it', () => {
      const { beginningOfYear } = useFinancialYear(date, 4, 1)
      const expected = new Date('2022-04-01')
      expect(beginningOfYear).toEqual(expected)
    })

    it('AGAIN: calculates the FINANCIAL based on date_beginning_of_fiscal_year and returns the beginning day of it', () => {
      const { beginningOfYear } = useFinancialYear(date, 6, 4)
      const expected = new Date('2021-06-01')
      expect(beginningOfYear).toEqual(expected)
    })
  })
})

describe('#nextBeginningOfYear', () => {
  it('returns the next year of beginningOfyear', () => {
    const date = new Date('2022-03-14')
    const { nextBeginningOfYear } = useFinancialYear(date, 4, 1)
    const expected = new Date('2023-04-01')
    expect(nextBeginningOfYear).toEqual(expected)
  })
})

describe('#lastBeginningOfYear', () => {
  it('returns the last year of beginningOfyear', () => {
    const date = new Date('2022-03-14')
    const { lastBeginningOfYear } = useFinancialYear(date, 4, 1)
    const expected = new Date('2021-04-01')
    expect(lastBeginningOfYear).toEqual(expected)
  })
})

describe('#beforeLastBeginningOfYear', () => {
  it('returns the before last year of beginningOfyear', () => {
    const date = new Date('2022-03-14')
    const { beforeLastBeginningOfYear } = useFinancialYear(date, 4, 1)
    const expected = new Date('2020-04-01')
    expect(beforeLastBeginningOfYear).toEqual(expected)
  })
})

describe('#endOfYear', () => {
  const date = new Date('2022-03-14')

  describe('when only date is given', () => {
    it('returns the end day of the year of the date', () => {
      const { endOfYear } = useFinancialYear(date)
      const expected = new Date('2022-12-31')
      expect(endOfYear).toEqual(expected)
    })
  })

  describe('when beginning_of_fiscal_year is January', () => {
    it('returns the end day of the year of the date', () => {
      const { endOfYear } = useFinancialYear(date, 1)
      const expected = new Date('2022-12-31')
      expect(endOfYear).toEqual(expected)
    })
  })

  describe('when beginning_of_fiscal_year is NOT January', () => {
    it('returns the end day of the FINANCIAL year of the date', () => {
      const { endOfYear } = useFinancialYear(date, 4)
      const expected = new Date('2022-03-31')
      expect(endOfYear).toEqual(expected)
    })
  })

  describe('when date_beginning_of_fiscal_year has the SAME value as beginning_of_fiscal_year', () => {
    it('returns the end day of the FINANCIAL year of the date', () => {
      const { endOfYear } = useFinancialYear(date, 4, 4)
      const expected = new Date('2022-03-31')
      expect(endOfYear).toEqual(expected)
    })
  })

  describe('when date_beginning_of_fiscal_year has the DIFFERENT value from beginning_of_fiscal_year', () => {
    it('calculates the FINANCIAL based on date_beginning_of_fiscal_year and returns the end day of it', () => {
      const { endOfYear } = useFinancialYear(date, 4, 1)
      const expected = new Date('2023-03-31')
      expect(endOfYear).toEqual(expected)
    })
  })
})

describe('#nextEndOfYear', () => {
  it('returns the next year of endOfyear', () => {
    const date = new Date('2022-03-14')
    const { nextEndOfYear } = useFinancialYear(date, 4, 1)
    const expected = new Date('2024-03-31')
    expect(nextEndOfYear).toEqual(expected)
  })
})

describe('#lastEndOfYear', () => {
  it('returns the last year of endOfyear', () => {
    const date = new Date('2022-03-14')
    const { lastEndOfYear } = useFinancialYear(date, 4, 1)
    const expected = new Date('2022-03-31')
    expect(lastEndOfYear).toEqual(expected)
  })
})

describe('#beforeLastEndOfYear', () => {
  it('returns the last year of endOfyear', () => {
    const date = new Date('2022-03-14')
    const { beforeLastEndOfYear } = useFinancialYear(date, 4, 1)
    const expected = new Date('2021-03-31')
    expect(beforeLastEndOfYear).toEqual(expected)
  })
})
