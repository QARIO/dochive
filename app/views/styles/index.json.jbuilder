json.array!(@styles) do |style|
  json.extract! style, :id, :name
  json.url style_url(style, format: :json)
end
