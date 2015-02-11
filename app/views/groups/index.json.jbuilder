json.array!(@groups) do |group|
  json.extract! group, :id, :user_id, :name, :description, :public
  json.url group_url(group, format: :json)
end
