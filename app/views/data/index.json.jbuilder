json.array!(@data) do |datum|
  json.extract! datum, :id, :document_id, :template_id, :page_id, :path, :url, :filename, :description, :public
  json.url datum_url(datum, format: :json)
end
