json.array!(@tyndales) do |tyndale|
  json.extract! tyndale, :id, :full, :short, :enabled
  json.url tyndale_url(tyndale, format: :json)
end
