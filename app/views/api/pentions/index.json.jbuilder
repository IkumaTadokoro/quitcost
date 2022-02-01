json.pentions @pentions do |pention|
  json.id pention.id
  json.year pention.year
  json.contribution pention.contribution
end

json.totalPages @pentions.total_pages
