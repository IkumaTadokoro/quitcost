json.pentions @pentions do |pention|
  json.id pention.id
  json.year pention.year
  json.contribution pention.contribution
  json.edit_pention_path edit_pention_path(pention)
end

json.totalPages @pentions.total_pages
