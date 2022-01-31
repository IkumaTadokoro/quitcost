json.insurance @insurances do |insurance|
  json.id insurance.id
  json.year insurance.year
  json.prefecture insurance.local_government.prefecture
  json.city insurance.local_government.city
  json.prefecture_capital insurance.local_government.prefecture_capital
  json.medical_income_basis insurance.medical_income_basis
  json.medical_asset_basis insurance.medical_asset_basis
  json.medical_capita_basis insurance.medical_capita_basis
  json.medical_household_basis insurance.medical_household_basis
  json.medical_limit insurance.medical_limit
  json.elderly_income_basis insurance.elderly_income_basis
  json.elderly_asset_basis insurance.elderly_asset_basis
  json.elderly_capita_basis insurance.elderly_capita_basis
  json.elderly_household_basis insurance.elderly_household_basis
  json.elderly_limit insurance.elderly_limit
  json.care_income_basis insurance.care_income_basis
  json.care_asset_basis insurance.care_asset_basis
  json.care_capita_basis insurance.care_capita_basis
  json.care_household_basis insurance.care_household_basis
  json.care_limit insurance.care_limit
  json.january insurance.payment_target_months.january_is_target?
  json.february insurance.payment_target_months.february_is_target?
  json.march insurance.payment_target_months.march_is_target?
  json.april insurance.payment_target_months.april_is_target?
  json.may insurance.payment_target_months.may_is_target?
  json.june insurance.payment_target_months.june_is_target?
  json.july insurance.payment_target_months.july_is_target?
  json.august insurance.payment_target_months.august_is_target?
  json.september insurance.payment_target_months.september_is_target?
  json.october insurance.payment_target_months.october_is_target?
  json.november insurance.payment_target_months.november_is_target?
  json.december insurance.payment_target_months.december_is_target?
  json.edit_insurance_path edit_insurance_path(insurance)
end

json.totalPages @insurances.total_pages
