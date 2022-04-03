json.pensions @pensions do |pension|
  json.id pension.id
  json.year pension.year
  json.contribution pension.contribution
  json.edit_pension_path edit_admin_pension_path(pension)
end

json.totalPages @pensions.total_pages
