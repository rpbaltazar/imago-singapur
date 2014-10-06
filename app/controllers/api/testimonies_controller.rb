module Api
  class TestimoniesController < ApplicationController
    before_action :authenticate_api_user!

    def index
      testimonies = @person.testimonies.order('story_date DESC')
      testimonies.each do |t|
        t.visible = true
      end
      render json: testimonies.to_json
    end

    def show
      testimony = Testimony.find params[:id]
      time_nearby_testimonies = get_surrounding_testimonies testimony
      res = {testimony: testimony, nearby: time_nearby_testimonies}
      render :json => res.to_json
    end

    def get_surrounding_testimonies(testimony)

      # dt = DateTime.new(year)
      # boy = dt.beginning_of_year
      # eoy = dt.end_of_year
      # where("published_at >= ? and published_at <= ?", boy, eoy)

      time_nearby_testimonies = Testimony.where 'extract(year from story_date) = ? AND id != ?', "#{testimony.story_date.year}", testimony.id
      # time_nearby_testimonies = Testimony.where "strftime('%Y', story_date) = ? AND id != ?", "#{testimony.story_date.year}", testimony.id
      time_nearby_testimonies.each do |t|
        friends_ids = (@person.friends).map(&:id)
        p @person.id
        t.visible = ( (t.person.id == @person.id) || (friends_ids.include?t.person.id))
      end
    end

  end
end
