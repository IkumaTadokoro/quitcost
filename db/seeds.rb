# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require 'csv'

ActiveRecord::Base.transaction do
  # Create Admin User
  Rails.logger.debug 'Create Admin User...'
  User.create!(email: 'quitcost@example.com', password: 'quitcost')

  # Create Pensions
  Rails.logger.debug 'Create Pensions...'
  Pension.create!(year: 2021, contribution: 16_610)
  Pension.create!(year: 2022, contribution: 16_590)

  # Create Insurance & Payment Target Month
  Rails.logger.debug 'Create Insurance & Payment Target Month...'
  CSV.foreach('db/seeds/csv/insurances.csv', headers: true) do |row|
    insurance = Insurance.create!(
      year: row['year'],
      local_gov_code: row['local_gov_code'],
      medical_income_basis: row['medical_income_basis'],
      medical_asset_basis: row['medical_asset_basis'],
      medical_capita_basis: row['medical_capita_basis'],
      medical_household_basis: row['medical_household_basis'],
      medical_limit: row['medical_limit'],
      elderly_income_basis: row['elderly_income_basis'],
      elderly_asset_basis: row['elderly_asset_basis'],
      elderly_capita_basis: row['elderly_capita_basis'],
      elderly_household_basis: row['elderly_household_basis'],
      elderly_limit: row['elderly_limit'],
      care_income_basis: row['care_income_basis'],
      care_asset_basis: row['care_asset_basis'],
      care_capita_basis: row['care_capita_basis'],
      care_household_basis: row['care_household_basis'],
      care_limit: row['care_limit']
    )

    PaymentTargetMonth::CALENDAR.each do |month_name_symbol, month|
      month_name = month_name_symbol.to_s

      if row[month_name] == 'TRUE'
        year = month >= PaymentTargetMonth::CALENDAR[:april] ? row['year'] : row['year'].next
        insurance.payment_target_months.create!(month: Time.zone.parse("#{year}-#{format('%02d', month)}-01"))
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength
