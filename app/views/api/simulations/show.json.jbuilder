json.simulation do
  json.retirement_month @simulation.retirement_month
  json.employment_month @simulation.employment_month
  json.grand_total @simulation.grand_total
  json.sub_total @simulation.sub_total
  json.monthly_payment @simulation.monthly_payment
end
