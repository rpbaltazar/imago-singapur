class TestimoniesController < ApplicationController
  before_action :set_testimony, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /testimonies
  # GET /testimonies.json
  def index
    @person = Person.find 1
    @testimonies = @person.testimonies
    if params[:view] == "grid"
      render :index_map
    else
      render :index_grid
    end
  end

  # GET /testimonies/1
  # GET /testimonies/1.json
  def show
  end

  # GET /testimonies/new
  def new
    @testimony = Testimony.new
  end

  # GET /testimonies/1/edit
  def edit
  end

  # POST /testimonies
  # POST /testimonies.json
  def create
    @testimony = Testimony.new(testimony_params)

    respond_to do |format|
      if @testimony.save
        format.html { redirect_to @testimony, notice: 'testimony was successfully created.' }
        format.json { render action: 'show', status: :created, location: @testimony }
      else
        format.html { render action: 'new' }
        format.json { render json: @testimony.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /testimonies/1
  # PATCH/PUT /testimonies/1.json
  def update
    respond_to do |format|
      if @testimony.update(testimony_params)
        format.html { redirect_to @testimony, notice: 'testimony was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @testimony.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /testimonies/1
  # DELETE /testimonies/1.json
  def destroy
    @testimony.destroy
    respond_to do |format|
      format.html { redirect_to testimonies_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_testimony
      @testimony = Testimony.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def testimony_params
      params.require(:testimony).permit(:lat, :lon, :story_date, :memory, :audio_url, :video_url, :image_url, :person_id)
    end
end
