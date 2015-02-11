class SettingsController < ApplicationController
  
  before_filter :authenticate_user!
  before_action :set_setting, only: [:show, :edit, :update, :destroy]

  # GET /settings
  # GET /settings.json
  def index
    createDefaultSettings()
    @setting = Setting.where(user_id: current_user.id).first
    
    respond_to do |format|
      if @setting.present?
        format.html { redirect_to @setting }
        format.json { render action: 'show', status: :created, location: @setting }
        #else
        #format.html { render action: 'new' }
        #format.json { render json: @setting.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def createDefaultSettings
    @setting = Setting.where(user_id: current_user.id).first
    if !@setting.present? then
      @setting = Setting.new
      @setting.user_id = current_user.id
      @setting.default_template = nil
      @setting.default_language = 13 
      @setting.default_notification = current_user.email  
      @setting.notify_complete = false
      @setting.trimLeft = 0
      @setting.trimRight = 0
      @setting.trimTop = 0
      @setting.trimBottom = 0
      @setting.save
    end
  end

  # GET /settings/1
  # GET /settings/1.json
  def show
    @settings = Setting.where(user_id: current_user.id).first
  end

  # GET /settings/new
  def new
    @setting = Setting.new
  end

  # GET /settings/1/edit
  def edit
    createDefaultSettings()
    @setting = Setting.where(user_id: current_user.id).first
  end

  # POST /settings
  # POST /settings.json
  def create
    @setting = Setting.new(setting_params)

    respond_to do |format|
      if @setting.save
        format.html { redirect_to @setting, notice: 'Setting was successfully created.' }
        format.json { render action: 'show', status: :created, location: @setting }
      else
        format.html { render action: 'new' }
        format.json { render json: @setting.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /settings/1
  # PATCH/PUT /settings/1.json
  def update
    respond_to do |format|
      if @setting.update(setting_params)
        format.html { redirect_to "/settings/0/edit", notice: 'Setting was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @setting.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /settings/1
  # DELETE /settings/1.json
  def destroy
    @setting.destroy
    respond_to do |format|
      format.html { redirect_to settings_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_setting
      #@setting = Setting.find(params[:id])
      @setting = Setting.where(user_id: current_user.id).first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def setting_params
      params.require(:setting).permit(:user_id, :default_template, :default_language, :default_notification, :notify_complete, :trimLeft, :trimRight, :trimTop, :trimBottom, :primary_language_id, :secondary_language_id, :tyndale, :translate_api)
    end
end
