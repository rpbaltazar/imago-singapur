class TestemoniesController < ApplicationController
  before_action :set_testemony, only: [:show, :edit, :update, :destroy]

  # GET /testemonies
  # GET /testemonies.json
  def index
    @testemonies = Testemony.all
  end

  # GET /testemonies/1
  # GET /testemonies/1.json
  def show
  end

  # GET /testemonies/new
  def new
    @testemony = Testemony.new
  end

  # GET /testemonies/1/edit
  def edit
  end

  # POST /testemonies
  # POST /testemonies.json
  def create
    @testemony = Testemony.new(testemony_params)

    respond_to do |format|
      if @testemony.save
        format.html { redirect_to @testemony, notice: 'Testemony was successfully created.' }
        format.json { render action: 'show', status: :created, location: @testemony }
      else
        format.html { render action: 'new' }
        format.json { render json: @testemony.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /testemonies/1
  # PATCH/PUT /testemonies/1.json
  def update
    respond_to do |format|
      if @testemony.update(testemony_params)
        format.html { redirect_to @testemony, notice: 'Testemony was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @testemony.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /testemonies/1
  # DELETE /testemonies/1.json
  def destroy
    @testemony.destroy
    respond_to do |format|
      format.html { redirect_to testemonies_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_testemony
      @testemony = Testemony.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def testemony_params
      params.require(:testemony).permit(:lat, :lon, :story_date, :memory, :audio_url, :video_url, :image_url, :person_id)
    end
end
