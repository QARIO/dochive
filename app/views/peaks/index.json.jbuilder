json.array!(@peaks) do |peak|
  json.extract! peak, :id, :page_id, :dimension, :number, :offset, :intensity
  json.url peak_url(peak, format: :json)
end
