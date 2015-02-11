json.array!(@sections) do |section|
  json.extract! section, :id, :template_id, :name, :yOrigin, :xOrigin, :width, :height
  json.url section_url(section, format: :json)
end
