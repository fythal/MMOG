class GalaxiesController < ApplicationController
  before_action :set_galaxy, only: [:show, :edit, :update, :destroy]

  # GET /galaxies
  # GET /galaxies.json
  def index
    $game_settings = Hash.new()
    $game_settings[:world_length] = 5
    $game_settings[:world_view_length] = 5
    pos = Array.new([0,0])
    unless params[:pox_x].nil? || params[:pox_y].nil?
      pos[0] = params[:x]
      pos[1] = params[:y]
    end

    near = Array.new(($game_settings[:world_view_length] * $game_settings[:world_view_length]))
    for x in (pos[0]-2)..(pos[0]+2)
      for y in (pos[0]-2)..(pos[0]+2)
        near[x*$game_settings[:world_view_length]+y] = Galaxy.calcX(x, y)
      end
    end
    @galaxies = Galaxy.where(id: near)
  end

  # GET /galaxies/1
  # GET /galaxies/1.json
  def show
  end

  # GET /galaxies/new
  def new
    @galaxy = Galaxy.new
  end

  # GET /galaxies/1/edit
  def edit
  end

  # POST /galaxies
  # POST /galaxies.json
  def create
    @galaxy = Galaxy.new(galaxy_params)

    respond_to do |format|
      if @galaxy.save
        format.html { redirect_to @galaxy, notice: 'Galaxy was successfully created.' }
        format.json { render action: 'show', status: :created, location: @galaxy }
      else
        format.html { render action: 'new' }
        format.json { render json: @galaxy.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /galaxies/1
  # PATCH/PUT /galaxies/1.json
  def update
    respond_to do |format|
      if @galaxy.update(galaxy_params)
        format.html { redirect_to @galaxy, notice: 'Galaxy was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @galaxy.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /galaxies/1
  # DELETE /galaxies/1.json
  def destroy
    @galaxy.destroy
    respond_to do |format|
      format.html { redirect_to galaxies_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_galaxy
      @galaxy = Galaxy.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def galaxy_params
      params.require(:galaxy).permit(:x, :name)
    end
end
