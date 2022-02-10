# frozen_string_literal: true

class Insurance < ApplicationRecord
  include JpLocalGov
  jp_local_gov :local_gov_code

  paginates_per 20

  has_many :payment_target_months, dependent: :destroy do
    # 責務的にはPaymentTargetMonthにおいた方がいいと思うが、おそらくCollectionProxyに対する`any?`ではなくなるため、
    # クエリ発行回数が増える。そのため一旦はhas_manyのブロック内で定義する
    PaymentTargetMonth::CALENDAR.each do |month_name, month_num|
      define_method "#{month_name}_is_target?" do
        any? { |row| row.month.month == month_num }
      end
    end
  end

  def self.rate(year:, local_gov_code:)
    prefecture_capital_code = JpLocalGov.where(prefecture: JpLocalGov.find(local_gov_code).prefecture, prefecture_capital: true).first.code

    if exists?(year: year, local_gov_code: local_gov_code)
      find_by(year: year, local_gov_code: local_gov_code)
    elsif exists?(local_gov_code: local_gov_code)
      maximum_year = where(local_gov_code: local_gov_code).maximum(:year)
      find_by(year: maximum_year, local_gov_code: local_gov_code)
    elsif exists?(year: year, local_gov_code: prefecture_capital_code)
      find_by(year: year, local_gov_code: prefecture_capital_code)
    else
      maximum_year = where(local_gov_code: prefecture_capital_code).maximum(:year)
      find_by(year: maximum_year, local_gov_code: prefecture_capital_code)
    end
  end
end
