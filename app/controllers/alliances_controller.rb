class AlliancesController < ApplicationController
  before_action :set_alliance, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!

  # GET /alliances
  # GET /alliances.json
  def index
    @alliances = Alliance.all
  end

  # GET /alliances/1
  # GET /alliances/1.json
  def show
  end

  # GET /alliances/new
  def new
    if current_user.alliance_id==nil
      @alliance = Alliance.new
      
    end
  end

  # GET /alliances/1/edit
  def edit
  end

  # POST /alliances
  # POST /alliances.json
  def create
    @alliance = Alliance.new(alliance_params)
<<<<<<< HEAD
    @founder=current_user
=======
    
    @alliance.alliance_founder_id=current_user.id
    current_user.alliance_id=@alliance.id
    
>>>>>>> 74272d803705c6fecf902e0c01afee963fe21a1c
    respond_to do |format|
      if @alliance.save
        format.html { redirect_to @alliance, notice: 'Alliance was successfully created.' }
        format.json { render action: 'show', status: :created, location: @alliance }
      else
        format.html { render action: 'new' }
        format.json { render json: @alliance.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /alliances/1
  # PATCH/PUT /alliances/1.json
  def update
    respond_to do |format|
      if @alliance.update(alliance_params)
        format.html { redirect_to @alliance, notice: 'Alliance was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @alliance.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /alliances/1
  # DELETE /alliances/1.json
  def destroy
    @alliance.destroy
    respond_to do |format|
      format.html { redirect_to alliances_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_alliance
      @alliance = Alliance.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def alliance_params
      params.require(:alliance).permit(:name, :default_rank, :description)
    end
end
