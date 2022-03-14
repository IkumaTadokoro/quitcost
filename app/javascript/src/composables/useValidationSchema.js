import * as yup from 'yup'
import { getYear, subMonths, addYears, format } from 'date-fns'

export const useValidationSchema = (baseDate) => {
  const computableFrom = format(baseDate, 'yyyy/MM')
  const computableTo = format(
    new Date(getYear(addYears(subMonths(baseDate, 3), 2)), 3, 1),
    'yyyy/MM'
  )

  const validationSchema = {
    RetirementMonth: yup.object({
      retirementMonth: yup
        .date()
        .nullable()
        .transform((value, originalValue) =>
          originalValue === '' ? null : value
        )
        .required('退職予定月は必須です')
        .min(
          computableFrom,
          `退職予定月には ${computableFrom} 以降の月を指定してください`
        )
        .max(
          computableTo,
          `退職予定月には ${computableTo} 以前の月を指定してください`
        )
        .typeError('無効な日付です。YYYY/MMの形式で入力してください。')
    }),
    EmploymentMonth: yup.object({
      retirementMonth: yup.date(),
      employmentMonth: yup
        .date()
        .nullable()
        .transform((value, originalValue) =>
          originalValue === '' ? null : value
        )
        .required('転職予定月は必須です')
        .min(
          yup.ref('retirementMonth'),
          `転職予定月には、退職予定月以降の月を指定してください`
        )
        .max(
          computableTo,
          `転職予定月には ${computableTo} 以前の月を指定してください`
        )
        .typeError('無効な日付です。YYYY/MMの形式で入力してください。')
    }),
    Age: yup.object({
      age: yup
        .number()
        .transform((value) => (isNaN(value) ? undefined : value))
        .required('年齢は必須です')
        .min(0, '0以上の整数を入力してください')
        .integer('整数で入力してください')
        .typeError('無効な数値です。')
    }),
    PostalCode: yup.object({
      postalCode: yup
        .string()
        .matches(/^[0-9]{3}-[0-9]{4}$/, {
          message: '7桁の郵便番号を入力してください',
          excludeEmptyString: true
        })
        .required('郵便番号は必須です'),
      address: yup.string().required('該当する市区町村がありません')
    }),
    PreviousSalary: yup.object({
      previousSalary: yup
        .number()
        .transform((value) => (isNaN(value) ? undefined : value))
        .required('昨昨年度の所得は必須です')
        .min(0, '0以上の整数を入力してください')
        .integer('整数で入力してください')
        .typeError('無効な数値です。')
    }),
    PreviousSocialInsurance: yup.object({
      previousSocialInsurance: yup
        .number()
        .transform((value) => (isNaN(value) ? undefined : value))
        .required('昨昨年度の社会保険料は必須です')
        .min(0, '0以上の整数を入力してください')
        .integer('整数で入力してください')
        .typeError('無効な数値です。')
    }),
    Salary: yup.object({
      salary: yup
        .number()
        .transform((value) => (isNaN(value) ? undefined : value))
        .required('昨年度の所得は必須です')
        .min(0, '0以上の整数を入力してください')
        .integer('整数で入力してください')
        .typeError('無効な数値です。')
    }),
    SocialInsurance: yup.object({
      socialInsurance: yup
        .number()
        .transform((value) => (isNaN(value) ? undefined : value))
        .required('昨年度の社会保険料は必須です')
        .min(0, '0以上の整数を入力してください')
        .integer('整数で入力してください')
        .typeError('無効な数値です。')
    }),
    ScheduledSalary: yup.object({
      scheduledSalary: yup
        .number()
        .transform((value) => (isNaN(value) ? undefined : value))
        .required('今年度の所得は必須です')
        .min(0, '0以上の整数を入力してください')
        .integer('整数で入力してください')
        .typeError('無効な数値です。')
    }),
    ScheduledSocialInsurance: yup.object({
      scheduledSocialInsurance: yup
        .number()
        .transform((value) => (isNaN(value) ? undefined : value))
        .required('今年度の社会保険料は必須です')
        .min(0, '0以上の整数を入力してください')
        .integer('整数で入力してください')
        .typeError('無効な数値です。')
    })
  }

  return validationSchema
}
