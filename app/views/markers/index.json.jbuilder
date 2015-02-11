json.array!(@markers) do |marker|
  json.extract! marker, :id, :template_id, :dimension, :number, :offset, :intensity
  json.url marker_url(marker, format: :json)
end
