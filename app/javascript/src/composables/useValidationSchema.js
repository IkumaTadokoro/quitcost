import * as yup from 'yup'
import { getYear, subMonths, addYears, format } from 'date-fns'

export const useValidationSchema = (baseDate) => {
  const computableFrom = format(baseDate, 'yyyy/MM')
  const computableTo = format(
    new Date(getYear(addYears(subMonths(baseDate, 3), 2)), 3, 1),
    'yyyy/MM'
  )

  const numberPresence = (columnName) => {
    return yup
      .number()
      .transform((value) => (isNaN(value) ? undefined : value))
      .required(`${columnName}は必須です`)
      .typeError('無効な数値です。')
  }

  const datePresence = (columnName) => {
    return yup
      .date()
      .nullable()
      .transform((value, originalValue) =>
        originalValue === '' ? null : value
      )
      .required(`${columnName}は必須です`)
  }

  const validationSchema = {
    RetirementMonth: yup.object({
      retirementMonth: datePresence('退職予定月')
        .min(
          computableFrom,
          `退職予定月には ${computableFrom} 以降の月を指定してください`
        )
        .max(
          computableTo,
          `退職予定月には ${computableTo} 以前の月を指定してください`
        )
    }),
    EmploymentMonth: yup.object({
      retirementMonth: yup.date(),
      employmentMonth: datePresence('転職予定月')
        .min(
          yup.ref('retirementMonth'),
          `転職予定月には、退職予定月以降の月を指定してください`
        )
        .max(
          computableTo,
          `転職予定月には ${computableTo} 以前の月を指定してください`
        )
    }),
    Age: yup.object({
      age: numberPresence('年齢')
        .min(0, '0以上の整数を入力してください')
        .integer('整数で入力してください')
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
      previousSalary: numberPresence('昨昨年度の所得')
        .min(0, '0以上の整数を入力してください')
        .integer('整数で入力してください')
    }),
    PreviousSocialInsurance: yup.object({
      previousSocialInsurance: numberPresence('昨昨年度の社会保険料')
        .min(0, '0以上の整数を入力してください')
        .integer('整数で入力してください')
    }),
    Salary: yup.object({
      salary: numberPresence('昨年度の所得')
        .min(0, '0以上の整数を入力してください')
        .integer('整数で入力してください')
    }),
    SocialInsurance: yup.object({
      socialInsurance: numberPresence('昨年度の社会保険料')
        .min(0, '0以上の整数を入力してください')
        .integer('整数で入力してください')
    }),
    ScheduledSalary: yup.object({
      scheduledSalary: numberPresence('今年度の所得')
        .min(0, '0以上の整数を入力してください')
        .integer('整数で入力してください')
    }),
    ScheduledSocialInsurance: yup.object({
      scheduledSocialInsurance: numberPresence('今年度の社会保険料')
        .min(0, '0以上の整数を入力してください')
        .integer('整数で入力してください')
    })
  }

  return validationSchema
}
