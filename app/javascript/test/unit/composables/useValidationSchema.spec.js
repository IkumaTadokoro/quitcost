import { useValidationSchema } from 'composables/useValidationSchema'

describe('#validationSchema', () => {
  const baseDate = new Date('2022-03-15')
  const validationSchema = useValidationSchema(baseDate)

  it('has all form validations', () => {
    expect(validationSchema).toHaveProperty('RetirementMonth')
    expect(validationSchema).toHaveProperty('EmploymentMonth')
    expect(validationSchema).toHaveProperty('Age')
    expect(validationSchema).toHaveProperty('PostalCode')
    expect(validationSchema).toHaveProperty('PreviousSalary')
    expect(validationSchema).toHaveProperty('Salary')
    expect(validationSchema).toHaveProperty('ScheduledSalary')
    expect(validationSchema).toHaveProperty('PreviousSocialInsurance')
    expect(validationSchema).toHaveProperty('SocialInsurance')
    expect(validationSchema).toHaveProperty('ScheduledSocialInsurance')
  })

  describe('RetirementMonth', () => {
    const schema = validationSchema['RetirementMonth']

    it('is invalid without retirementMonth', async () => {
      const target = { retirementMonth: '' }
      await expect(schema.validate(target)).rejects.toThrow(
        '退職予定月は必須です'
      )
    })

    it('is invalid with the month before the month of today', async () => {
      const target = { retirementMonth: '2022-02' }
      await expect(schema.validate(target)).rejects.toThrow(
        '退職予定月には 2022-03 以降の月を指定してください'
      )
    })

    it('is valid with the month of today', async () => {
      const target = { retirementMonth: '2022-03' }
      await expect(schema.validate(target)).resolves.toEqual({
        retirementMonth: new Date('2022-03-01')
      })
    })

    it('is invalid a month later than the beginning of the financial year two years later', async () => {
      const target = { retirementMonth: '2023-05' }
      await expect(schema.validate(target)).rejects.toThrow(
        '退職予定月には 2023-04 以前の月を指定してください'
      )
    })

    it('is valid with the beginning of the financial year two years later', async () => {
      const target = { retirementMonth: '2023-04' }
      await expect(schema.validate(target)).resolves.toEqual({
        retirementMonth: new Date('2023-04-01')
      })
    })
  })

  describe('EmploymentMonth', () => {
    const schema = validationSchema['EmploymentMonth']

    it('is invalid without employmentMonth', async () => {
      const target = { employmentMonth: '' }
      await expect(schema.validate(target)).rejects.toThrow(
        '転職予定月は必須です'
      )
    })

    it('is invalid the month before retirementMonth', async () => {
      const target = { retirementMonth: '2022-08', employmentMonth: '2022-06' }
      await expect(schema.validate(target)).rejects.toThrow(
        '転職予定月には、退職予定月以降の月を指定してください'
      )
    })

    it('is invalid a month later than the beginning of the financial year two years later', async () => {
      const target = { retirementMonth: '2022-08', employmentMonth: '2023-05' }
      await expect(schema.validate(target)).rejects.toThrow(
        '転職予定月には 2023-04 以前の月を指定してください'
      )
    })

    it('is valid with the beginning of the financial year two years later', async () => {
      const target = { retirementMonth: '2022-08', employmentMonth: '2023-04' }
      await expect(schema.validate(target)).resolves.toEqual({
        retirementMonth: new Date('2022-08-01'),
        employmentMonth: new Date('2023-04-01')
      })
    })
  })

  describe('Age', () => {
    const schema = validationSchema['Age']

    it('is invalid without age', async () => {
      const target = { age: '' }
      await expect(schema.validate(target)).rejects.toThrow('年齢は必須です')
    })

    it('is invalid with negative number', async () => {
      const target = { age: '-20' }
      await expect(schema.validate(target)).rejects.toThrow(
        '0以上の整数を入力してください'
      )
    })

    it('is valid with zero', async () => {
      const target = { age: '0' }
      await expect(schema.validate(target)).resolves.toEqual({ age: 0 })
    })

    it('is invalid with decimal', async () => {
      const target = { age: '21.2' }
      await expect(schema.validate(target)).rejects.toThrow(
        '整数で入力してください'
      )
    })
  })

  describe('PostalCode', () => {
    const schema = validationSchema['PostalCode']

    it('is invalid without postalCode', async () => {
      const target = { postalCode: '', address: 'DUMMY' }
      await expect(schema.validate(target)).rejects.toThrow(
        '郵便番号は必須です'
      )
    })

    it('is invalid without format: XXX-XXXX', async () => {
      const target = { postalCode: '1000004', address: 'DUMMY' }
      await expect(schema.validate(target)).rejects.toThrow(
        '7桁の郵便番号を入力してください'
      )
    })

    it('is invalid the address corresponding to the postcode cannot be found', async () => {
      const target = { postalCode: '100-0004', address: '' }
      await expect(schema.validate(target)).rejects.toThrow(
        '該当する市区町村がありません'
      )
    })
  })

  describe('PreviousSalary', () => {
    const schema = validationSchema['PreviousSalary']

    it('is invalid without previousSalary', async () => {
      const target = { previousSalary: '' }
      await expect(schema.validate(target)).rejects.toThrow(
        '昨昨年度の所得は必須です'
      )
    })

    it('is invalid with negative number', async () => {
      const target = { previousSalary: '-5000000' }
      await expect(schema.validate(target)).rejects.toThrow(
        '0以上の整数を入力してください'
      )
    })

    it('is valid with zero', async () => {
      const target = { previousSalary: '0' }
      await expect(schema.validate(target)).resolves.toEqual({
        previousSalary: 0
      })
    })

    it('is invalid with decimal', async () => {
      const target = { previousSalary: '5000000.1' }
      await expect(schema.validate(target)).rejects.toThrow(
        '整数で入力してください'
      )
    })
  })

  describe('PreviousSocialInsurance', () => {
    const schema = validationSchema['PreviousSocialInsurance']

    it('is invalid without previousSocialInsurance', async () => {
      const target = { previousSocialInsurance: '' }
      await expect(schema.validate(target)).rejects.toThrow(
        '昨昨年度の社会保険料は必須です'
      )
    })

    it('is invalid with negative number', async () => {
      const target = { previousSocialInsurance: '-5000000' }
      await expect(schema.validate(target)).rejects.toThrow(
        '0以上の整数を入力してください'
      )
    })

    it('is valid with zero', async () => {
      const target = { previousSocialInsurance: '0' }
      await expect(schema.validate(target)).resolves.toEqual({
        previousSocialInsurance: 0
      })
    })

    it('is invalid with decimal', async () => {
      const target = { previousSocialInsurance: '5000000.1' }
      await expect(schema.validate(target)).rejects.toThrow(
        '整数で入力してください'
      )
    })
  })

  describe('Salary', () => {
    const schema = validationSchema['Salary']

    it('is invalid without salary', async () => {
      const target = { salary: '' }
      await expect(schema.validate(target)).rejects.toThrow(
        '昨年度の所得は必須です'
      )
    })

    it('is invalid with negative number', async () => {
      const target = { salary: '-5000000' }
      await expect(schema.validate(target)).rejects.toThrow(
        '0以上の整数を入力してください'
      )
    })

    it('is valid with zero', async () => {
      const target = { salary: '0' }
      await expect(schema.validate(target)).resolves.toEqual({
        salary: 0
      })
    })

    it('is invalid with decimal', async () => {
      const target = { salary: '5000000.1' }
      await expect(schema.validate(target)).rejects.toThrow(
        '整数で入力してください'
      )
    })
  })

  describe('SocialInsurance', () => {
    const schema = validationSchema['SocialInsurance']

    it('is invalid without socialInsurance', async () => {
      const target = { socialInsurance: '' }
      await expect(schema.validate(target)).rejects.toThrow(
        '昨年度の社会保険料は必須です'
      )
    })

    it('is invalid with negative number', async () => {
      const target = { socialInsurance: '-5000000' }
      await expect(schema.validate(target)).rejects.toThrow(
        '0以上の整数を入力してください'
      )
    })

    it('is valid with zero', async () => {
      const target = { socialInsurance: '0' }
      await expect(schema.validate(target)).resolves.toEqual({
        socialInsurance: 0
      })
    })

    it('is invalid with decimal', async () => {
      const target = { socialInsurance: '5000000.1' }
      await expect(schema.validate(target)).rejects.toThrow(
        '整数で入力してください'
      )
    })
  })

  describe('ScheduledSalary', () => {
    const schema = validationSchema['ScheduledSalary']

    it('is invalid without scheduledSalary', async () => {
      const target = { scheduledSalary: '' }
      await expect(schema.validate(target)).rejects.toThrow(
        '今年度の所得は必須です'
      )
    })

    it('is invalid with negative number', async () => {
      const target = { scheduledSalary: '-5000000' }
      await expect(schema.validate(target)).rejects.toThrow(
        '0以上の整数を入力してください'
      )
    })

    it('is valid with zero', async () => {
      const target = { scheduledSalary: '0' }
      await expect(schema.validate(target)).resolves.toEqual({
        scheduledSalary: 0
      })
    })

    it('is invalid with decimal', async () => {
      const target = { scheduledSalary: '5000000.1' }
      await expect(schema.validate(target)).rejects.toThrow(
        '整数で入力してください'
      )
    })
  })

  describe('ScheduledSocialInsurance', () => {
    const schema = validationSchema['ScheduledSocialInsurance']

    it('is invalid without scheduledSocialInsurance', async () => {
      const target = { scheduledSocialInsurance: '' }
      await expect(schema.validate(target)).rejects.toThrow(
        '今年度の社会保険料は必須です'
      )
    })

    it('is invalid with negative number', async () => {
      const target = { scheduledSocialInsurance: '-5000000' }
      await expect(schema.validate(target)).rejects.toThrow(
        '0以上の整数を入力してください'
      )
    })

    it('is valid with zero', async () => {
      const target = { scheduledSocialInsurance: '0' }
      await expect(schema.validate(target)).resolves.toEqual({
        scheduledSocialInsurance: 0
      })
    })

    it('is invalid with decimal', async () => {
      const target = { scheduledSocialInsurance: '5000000.1' }
      await expect(schema.validate(target)).rejects.toThrow(
        '整数で入力してください'
      )
    })
  })
})
