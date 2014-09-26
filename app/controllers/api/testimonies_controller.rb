module Api
  class TestimoniesController < ApplicationController

    def index
      p "#{params}"
    end

    def show
      testimony = Testemony.find params[:id]
      render :json => testimony.to_json
    end

  end
end
