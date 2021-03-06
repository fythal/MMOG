class AlliancesController < ApplicationController
  before_action :set_alliance, only: [:change_founder, :leave, :show, :edit, :update, :destroy, :useradd, :user_add_action, :change_user_rank, :remove_user, :change_description, :send_mail]
  before_filter :authenticate_user!

  # GET /alliances
  # GET /alliances.json
  def index
    if current_user.alliance_id==nil
      @alliance = Alliance.new
    else
      @alliance = current_user.alliance
      redirect_to @alliance
    end
  end

  # POST /alliances/1/edit/send_mail
  def send_mail
    @subj='[Allianznachricht] '+params['subject']
    @body=params['body']
    respond_to do |format|
      if @alliance.permission?(current_user,"massmail") and @alliance.send_mass_mail(current_user,@subj,@body)
        format.html { redirect_to @alliance, notice: GameSettings.get("SUCCESSMSG_ALLIANCE_MASSMAILSENT") }
        format.json { render action: 'show', status: :created, location: @alliance }
      else
        format.html { redirect_to @alliance, notice: GameSettings.get("ERRMSG_ALLIANCE_MASSMAILSENT") }
        format.json { render json: @alliance.errors, status: :unprocessable_entity }
      end
    end    
  end

  def change_founder
    respond_to do |format|
      new_founder=@alliance.users.find(params['uid'])
      if @alliance.permission?(current_user,"destroy") and new_founder!=nil and new_founder!=current_user
        @alliance.set_founder(new_founder,current_user)
        format.html { redirect_to @alliance, notice: GameSettings.get("SUCCESSMSG_ALLIANCE_CHANGEFOUNDER") }
        format.json { render action: 'show', status: :created, location: @alliance }
      else
        format.html { redirect_to @alliance, notice: GameSettings.get("ERRMSG_ALLIANCE_CHANGEFOUNDER") }
        format.json { render json: @alliance.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /alliances/1/edit/change_default_rank
  def change_default_rank
    @rank=@alliance.ranks.find_by_id(params['rank']['id'])
    respond_to do |format|
      if @alliance.permission?(current_user,"edit_ranks") and @alliance.change_default_rank(@rank)
        format.html { redirect_to @alliance, notice: GameSettings.get("SUCCESSMSG_ALLIANCE_CHANGEDDEFAULTRANK") }
        format.json { render action: 'show', status: :created, location: @alliance }
      else
        format.html { redirect_to @alliance, notice: GameSettings.get("ERRMSG_ALLIANCE_CHANGEDDEFAULTRANK") }
        format.json { render json: @alliance.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /alliances/1/edit/
  def change_description
    respond_to do |format|
      if @alliance.permission?(current_user,"change_description") and @alliance.set_description(params['description'])
        format.html { redirect_to @alliance, notice: GameSettings.get("SUCCESSMSG_ALLIANCE_CHANGEDDESCRIPTION") }
        format.json { render action: 'show', status: :created, location: @alliance }
      else
        format.html { redirect_to @alliance, notice: GameSettings.get("ERRMSG_ALLIANCE_CHANGEDDESCRIPTION") }
        format.json { render json: @alliance.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /alliances/1/edit/change_user_rank
  def change_user_rank
    @rank=@alliance.ranks.find_by_id(params['rank'])
    @user=@alliance.users.find_by_id(params['uid'])
    respond_to do |format|
      if @alliance.permission?(current_user,"edit_ranks") and @alliance.change_user_rank(@user,@rank)
        format.html { redirect_to @alliance, notice: GameSettings.get("SUCCESSMSG_ALLIANCE_CHANGEDUSERRANK") }
        format.json { render action: 'show', status: :created, location: @alliance }
      else
        format.html { redirect_to @alliance, notice: GameSettings.get("ERRMSG_ALLIANCE_CHANGEDUSERRANK") }
        format.json { render json: @alliance.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /alliances/1
  # GET /alliances/1.json
  def show
    @founder=@alliance.ranks.where(:is_founder=>true)[0].users[0]
  end

  # GET /alliances/1/edit
  def edit
    unless @alliance.permission?(current_user,"show_edit")
      respond_to do |format|
        format.html {redirect_to @alliance,notice: GameSettings.get("ERRMSG_ALLIANCE_SHOWEDIT")}
      end
    end
  end

  def remove_user
    @user=@alliance.users.find_by_id(params['uid'])
    respond_to do |format|
      if @alliance.permission?(current_user,"kick") and @alliance.remove_user(@user)
        format.html { redirect_to @alliance, notice: GameSettings.get("SUCCESSMSG_ALLIANCE_USERREMOVED") }
        format.json { render action: 'show', status: :created, location: @alliance }
      else
        format.html { redirect_to @alliance, notice: GameSettings.get("ERRMSG_ALLIANCE_USERREMOVED") }
        format.json { render json: @alliance.errors, status: :unprocessable_entity }
      end
    end
  end

  def leave
    respond_to do |format|
      if @alliance.permission?(current_user,"destroy")==false and @alliance.remove_user(current_user)
        #destroy all pending requests
        @pending_invites=Request.all.where(:sender => current_user, :action => "alliance_invite")
        @pending_invites.each do |invite|
          invite.destroy
        end  
        format.html { redirect_to alliances_path, notice: GameSettings.get("SUCCESSMSG_ALLIANCE_LEAVE") }
      else
        format.html { redirect_to alliances_path, notice: GameSettings.get("ERRMSG_ALLIANCE_LEAVE") }
      end
    end
  end

  # POST /alliances
  # POST /alliances.json
  def create
    #only do if user has no alliance.
    if current_user.alliance==nil and current_user.rank==nil
      @alliance = Alliance.new(alliance_params)
      respond_to do |format|
        if @alliance.save and @alliance.add_user(current_user) and @alliance.set_founder(current_user) #save both
            format.html { redirect_to @alliance, notice: GameSettings.get("SUCCESSMSG_ALLIANCE_CREATED") }
            format.json { render action: 'show', status: :created, location: @alliance }
        else
          format.html { redirect_to @alliance, notice: GameSettings.get("ERRMSG_ALLIANCE_CREATED") }
          format.json { render json: @alliance.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /alliances/1
  # DELETE /alliances/1.json
  def destroy
    #only if current user is founder
    if current_user.alliance==@alliance and @alliance.permission?(current_user,"destroy")
      #cancel all alliance members
      @alliance.users.each do |user|
        @alliance.users.delete(user)
        user.rank.users.delete(user)
        user.system_notify("Allianz","Deine Allianz wurde aufgelöst!","Tut uns leid!")
      end
      #destroy all ranks
      @alliance.ranks.each do |rank|
        rank.destroy
      end
      #destroy all pending requests
      @pending_invites=Request.all.where(:sender => current_user, :action => "alliance_invite")
      @pending_invites.each do |invite|
        invite.destroy
      end
      @alliance.destroy
    end
    #response
    respond_to do |format|
      format.html { redirect_to alliances_url }
      format.json { head :no_content }
    end
  end

  def overview
    @alliances=Alliance.all
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