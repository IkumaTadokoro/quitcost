import { object, string, number, date, ref } from 'yup'
import { useFinancialYear } from './useFinancialYear'
import { format } from 'date-fns'

export const useValidationSchema = (baseDate) => {
  const { afterNextBeginningOfYear } = useFinancialYear(baseDate, 4)
  const from = format(baseDate, 'yyyy-MM')
  const to = format(afterNextBeginningOfYear, 'yyyy-MM')

  const numberPresence = (columnName) => {
    return number()
      .transform((value) => (isNaN(value) ? undefined : value))
      .required(`${columnName}は必須です`)
      .typeError('無効な数値です。')
  }

  const datePresence = (columnName) => {
    return date()
      .nullable()
      .transform((value, original) => (original === '' ? null : value))
      .required(`${columnName}は必須です`)
      .typeError('無効な日付形式です。')
  }

  const RetirementMonth = object({
    retirementMonth: datePresence('退職予定月')
      .min(from, `退職予定月には ${from} 以降の月を指定してください`)
      .max(to, `退職予定月には ${to} 以前の月を指定してください`)
  })

  const EmploymentMonth = object({
    retirementMonth: date(),
    employmentMonth: datePresence('転職予定月')
      .min(
        ref('retirementMonth'),
        `転職予定月には、退職予定月以降の月を指定してください`
      )
      .max(to, `転職予定月には ${to} 以前の月を指定してください`)
  })

  const Age = object({
    age: numberPresence('年齢')
      .min(0, '0以上の整数を入力してください')
      .integer('整数で入力してください')
  })

  const PostalCode = object({
    postalCode: string()
      .matches(/^[0-9]{3}-[0-9]{4}$/, {
        message: '7桁の郵便番号を入力してください',
        excludeEmptyString: true
      })
      .required('郵便番号は必須です'),
    address: string().required('該当する市区町村がありません')
  })

  const PreviousSalary = object({
    previousSalary: numberPresence('昨昨年度の所得')
      .min(0, '0以上の整数を入力してください')
      .integer('整数で入力してください')
  })

  const PreviousSocialInsurance = object({
    previousSocialInsurance: numberPresence('昨昨年度の社会保険料')
      .min(0, '0以上の整数を入力してください')
      .integer('整数で入力してください')
  })

  const Salary = object({
    salary: numberPresence('昨年度の所得')
      .min(0, '0以上の整数を入力してください')
      .integer('整数で入力してください')
  })

  const SocialInsurance = object({
    socialInsurance: numberPresence('昨年度の社会保険料')
      .min(0, '0以上の整数を入力してください')
      .integer('整数で入力してください')
  })

  const ScheduledSalary = object({
    scheduledSalary: numberPresence('今年度の所得')
      .min(0, '0以上の整数を入力してください')
      .integer('整数で入力してください')
  })

  const ScheduledSocialInsurance = object({
    scheduledSocialInsurance: numberPresence('今年度の社会保険料')
      .min(0, '0以上の整数を入力してください')
      .integer('整数で入力してください')
  })

  const validationSchema = {
    RetirementMonth,
    EmploymentMonth,
    Age,
    PostalCode,
    PreviousSalary,
    PreviousSocialInsurance,
    Salary,
    SocialInsurance,
    ScheduledSalary,
    ScheduledSocialInsurance
  }

  return validationSchema
}
