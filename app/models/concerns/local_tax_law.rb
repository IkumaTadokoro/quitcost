# frozen_string_literal: true

module LocalTaxLaw
  extend self

  # 第二十条の四の二 第一項
  def calc_tax_base(&process)
    result = yield process
    result.floor(-3)
  end

  # 第二十条の四の二 第三項
  # 住民税と国民健康保険は「政令で定める地方税」に相当しないため簡素化して実装
  def calc_determined_amount(&process)
    result = yield process
    result.floor(-2)
  end

  # 第二十条の四の二 第六項
  def calc_installments(total, dues, municipal_ordinance: false, special_insurance: false)
    number_of_payments = dues.size
    digits = calc_digits(municipal_ordinance, special_insurance)
    not_first_month = (total / number_of_payments).floor(digits)
    first_month = total - not_first_month * (number_of_payments - 1)
    [first_month, Array.new(number_of_payments - 1) { not_first_month }].flatten
  end

  private

  # 第二十条の四の二 第九項（特別徴収の国民保険）および第二十条の四の二 第六項（条例の定める範囲）
  def calc_digits(municipal_ordinance, special_insurance)
    municipal_ordinance || special_insurance ? -2 : -3
  end
end
