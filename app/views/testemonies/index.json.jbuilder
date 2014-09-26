json.array!(@testimonies) do |testimony|
  json.extract! testimony, :id, :lat, :lon, :story_date, :memory, :audio_url, :video_url
  json.url testimony_url(testimony, format: :json)
end
