json.array!(@documents) do |document|
  json.extract! document, :id, :user_id, :description
  json.url document_url(document, format: :json)
end
