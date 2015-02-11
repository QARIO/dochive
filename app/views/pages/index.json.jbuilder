json.array!(@pages) do |page|
  json.extract! page, :id, :document_id, :user_id, :template_id, :number, :dpi, :height, :width, :top, :bottom, :left, :right, :path, :url, :filename, :exclude, :public
  json.url page_url(page, format: :json)
end
