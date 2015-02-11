json.array!(@builders) do |builder|
  json.extract! builder, :id, :page_id, :name, :yOrigin, :xOrigin, :width, :height
  json.url builder_url(builder, format: :json)
end
