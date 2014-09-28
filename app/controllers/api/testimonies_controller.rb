module Api
  class TestimoniesController < ApplicationController

    def index
      testimonies = Testimony.all
      render json: testimonies.to_json
    end

    def show
      testimony = Testimony.find params[:id]
      render :json => testimony.to_json
    end

  end
end
