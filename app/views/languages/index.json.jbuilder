json.array!(@languages) do |language|
  json.extract! language, :id, :full, :short, :enabled
  json.url language_url(language, format: :json)
end
