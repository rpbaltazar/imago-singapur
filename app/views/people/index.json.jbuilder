json.array!(@people) do |person|
  json.extract! person, :id, :nickname, :arrival_date, :sex, :exit_date, :birthday
  json.url person_url(person, format: :json)
end
