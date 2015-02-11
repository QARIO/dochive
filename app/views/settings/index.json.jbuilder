json.array!(@settings) do |setting|
  json.extract! setting, :id, :user_id, :default_template, :default_language, :default_notification, :notify_complete, :trimLeft, :trimRight, :trimTop, :trimBottom
  json.url setting_url(setting, format: :json)
end
