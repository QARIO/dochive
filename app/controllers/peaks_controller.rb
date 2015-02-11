class PeaksController < ApplicationController
  before_action :set_peak, only: [:show, :edit, :update, :destroy]

  # GET /peaks
  # GET /peaks.json
  def index
    @peaks = Peak.all
  end

  # GET /peaks/1
  # GET /peaks/1.json
  def show
  end

  # GET /peaks/new
  def new
    @peak = Peak.new
  end

  # GET /peaks/1/edit
  def edit
  end

  # POST /peaks
  # POST /peaks.json
  def create
    @peak = Peak.new(peak_params)

    respond_to do |format|
      if @peak.save
        format.html { redirect_to @peak, notice: 'Peak was successfully created.' }
        format.json { render action: 'show', status: :created, location: @peak }
      else
        format.html { render action: 'new' }
        format.json { render json: @peak.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /peaks/1
  # PATCH/PUT /peaks/1.json
  def update
    respond_to do |format|
      if @peak.update(peak_params)
        format.html { redirect_to @peak, notice: 'Peak was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @peak.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /peaks/1
  # DELETE /peaks/1.json
  def destroy
    @peak.destroy
    respond_to do |format|
      format.html { redirect_to peaks_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_peak
      @peak = Peak.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def peak_params
      params.require(:peak).permit(:page_id, :dimension, :number, :offset, :intensity)
    end
end
