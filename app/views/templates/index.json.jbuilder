json.array!(@templates) do |template|
  json.extract! template, :id, :user_id, :group_id, :style_id, :type_id, :name, :description, :path, :url, :filename
  json.url template_url(template, format: :json)
end
