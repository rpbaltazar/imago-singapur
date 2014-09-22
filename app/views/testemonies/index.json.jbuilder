json.array!(@testemonies) do |testemony|
  json.extract! testemony, :id, :lat, :lon, :story_date, :memory, :audio_url, :video_url
  json.url testemony_url(testemony, format: :json)
end
