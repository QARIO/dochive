class TyndalesController < ApplicationController
  before_action :set_tyndale, only: [:show, :edit, :update, :destroy]

  # GET /tyndales
  # GET /tyndales.json
  def index
    @tyndales = Tyndale.all
  end

  # GET /tyndales/1
  # GET /tyndales/1.json
  def show
  end

  # GET /tyndales/new
  def new
    @tyndale = Tyndale.new
  end

  # GET /tyndales/1/edit
  def edit
  end

  # POST /tyndales
  # POST /tyndales.json
  def create
    @tyndale = Tyndale.new(tyndale_params)

    respond_to do |format|
      if @tyndale.save
        format.html { redirect_to @tyndale, notice: 'Tyndale was successfully created.' }
        format.json { render action: 'show', status: :created, location: @tyndale }
      else
        format.html { render action: 'new' }
        format.json { render json: @tyndale.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tyndales/1
  # PATCH/PUT /tyndales/1.json
  def update
    respond_to do |format|
      if @tyndale.update(tyndale_params)
        format.html { redirect_to @tyndale, notice: 'Tyndale was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @tyndale.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tyndales/1
  # DELETE /tyndales/1.json
  def destroy
    @tyndale.destroy
    respond_to do |format|
      format.html { redirect_to tyndales_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tyndale
      @tyndale = Tyndale.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tyndale_params
      params.require(:tyndale).permit(:full, :short, :enabled)
    end
end
