module Api
  class TestimoniesController < ApplicationController
    before_action :authenticate_api_user!

    def index
      testimonies = @person.testimonies
      render json: testimonies.to_json
    end

    def show
      testimony = Testimony.find params[:id]
      render :json => testimony.to_json
    end

  end
end
