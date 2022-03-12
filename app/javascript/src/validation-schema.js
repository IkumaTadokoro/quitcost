import * as yup from 'yup'
import { getYear, subMonths, addYears, format } from 'date-fns'

export const useValidationSchema = (baseDate) => {
  const computableFrom = format(baseDate, 'yyyy/MM')
  const computableTo = format(
    new Date(getYear(addYears(subMonths(baseDate, 3), 2)), 3, 1),
    'yyyy/MM'
  )

  const validationSchema = [
    yup.object({
      retirementMonth: yup
        .date()
        .required('退職予定月は必須です')
        .typeError('無効な日付です。YYYY/MMの形式で入力してください。')
        .min(
          computableFrom,
          `退職予定月には ${computableFrom} 以降の月を指定してください`
        )
        .max(
          computableTo,
          `退職予定月には ${computableTo} 以前の月を指定してください`
        )
    }),
    yup.object({
      retirementMonth: yup.date(),
      employmentMonth: yup
        .date()
        .required('転職予定月は必須です')
        .typeError('無効な日付です。YYYY/MMの形式で入力してください。')
        .min(
          yup.ref('retirementMonth'),
          `転職予定月には、退職月以降の月を指定してください`
        )
        .max(
          computableTo,
          `転職予定月には ${computableTo} 以前の月を指定してください`
        )
    }),
    yup.object({
      age: yup
        .number()
        .required('年齢は必須です')
        .typeError('無効な数値です。')
        .min(0, '0以上の整数を入力してください')
        .integer('整数で入力してください')
    }),
    yup.object({
      postalCode: yup
        .string()
        .matches(/^[0-9]{3}-[0-9]{4}$/, {
          message: '7桁の郵便番号を入力してください',
          excludeEmptyString: true
        })
        .required('郵便番号は必須です'),
      address: yup.string().required('該当する市区町村がありません')
    }),
    yup.object({
      previousSalary: yup
        .number()
        .required('昨昨年度の所得は必須です')
        .typeError('無効な数値です。')
        .min(0, '0以上の整数を入力してください')
        .integer('整数で入力してください')
    }),
    yup.object({
      previousSocialInsurance: yup
        .number()
        .required('昨昨年度の社会保険料は必須です')
        .typeError('無効な数値です。')
        .min(0, '0以上の整数を入力してください')
        .integer('整数で入力してください')
    }),
    yup.object({
      salary: yup
        .number()
        .required('昨年度の所得は必須です')
        .typeError('無効な数値です。')
        .min(0, '0以上の整数を入力してください')
        .integer('整数で入力してください')
    }),
    yup.object({
      socialInsurance: yup
        .number()
        .required('昨年度の社会保険料は必須です')
        .typeError('無効な数値です。')
        .min(0, '0以上の整数を入力してください')
        .integer('整数で入力してください')
    }),
    yup.object({
      scheduledSalary: yup
        .number()
        .required('今年度の所得は必須です')
        .typeError('無効な数値です。')
        .min(0, '0以上の整数を入力してください')
        .integer('整数で入力してください')
    }),
    yup.object({
      scheduledSocialInsurance: yup
        .number()
        .required('今年度の所得は必須です')
        .typeError('無効な数値です。')
        .min(0, '0以上の整数を入力してください')
        .integer('整数で入力してください')
    })
  ]

  return validationSchema
}
