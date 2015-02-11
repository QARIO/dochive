json.array!(@assets) do |asset|
  json.extract! asset, :id, :document_id, :page_id, :section_id, :path, :url, :filename, :tpath, :turl, :tfilename, :language, :value
  json.url asset_url(asset, format: :json)
end
