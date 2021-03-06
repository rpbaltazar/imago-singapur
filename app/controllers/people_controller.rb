class PeopleController < ApplicationController
  before_action :set_person, only: [:show, :edit, :update, :destroy, :user_testimonies]

  # GET /people
  # GET /people.json
  def index
    @people = Person.all
  end

  # GET /people/1
  # GET /people/1.json
  def show
  end

  # GET /people/new
  def new
    @person = Person.new
  end

  # GET /people/1/edit
  def edit
  end

  # POST /people
  # POST /people.json
  def create
    @person = Person.new(person_params)

    respond_to do |format|
      if @person.save
        format.html { redirect_to @person, notice: 'Person was successfully created.' }
        format.json { render action: 'show', status: :created, location: @person }
      else
        format.html { render action: 'new' }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /people/1
  # PATCH/PUT /people/1.json
  def update
    respond_to do |format|
      if @person.update(person_params)
        format.html { redirect_to @person, notice: 'Person was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /people/1
  # DELETE /people/1.json
  def destroy
    @person.destroy
    respond_to do |format|
      format.html { redirect_to people_url }
      format.json { head :no_content }
    end
  end

  def user_testimonies
    tlist = @person.testimonies
    render json: (build_testimonies(tlist))
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_person
      @person = Person.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def person_params
      params.require(:person).permit(:nickname, :arrival_date, :sex, :exit_date, :birthday)
    end

    def build_testimonies t_list
      final_struct = []
      t_list.each do |t|
        tmp_struct = {}
        tmp_struct[:id] = t.id
        tmp_struct[:date] = t.story_date
        tmp_struct[:location] = {
          latitude: t.lat,
          longitude: t.lon
        }
        tmp_struct[:memory] = t.memory
        tmp_struct[:image_url] = t.image_url
        final_struct << tmp_struct
      end
      final_struct
    end
end
