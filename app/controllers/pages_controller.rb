class PagesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_page, only: [:show, :edit, :update, :destroy]

  # GET /pages
  # GET /pages.json
  def index
    @pages = Page.all
  end

  # GET /pages/1
  # GET /pages/1.json
  def show
    #@page = Page.find(params[:id])
    #@document = Document.find(@page.document_id)
    #@template = Template.find(@page.template_id)
    #@section = Section.where("template = #{@template.id}")#.order("section.id ASC")
  end

  # GET /pages/new
  def new
    @page = Page.new
  end

  # GET /pages/1/edit
  def edit
  end

  # POST /pages
  # POST /pages.json
  def create
    @page = Page.new(page_params)

    respond_to do |format|
      if @page.save
        format.html { redirect_to @page, notice: 'Page was successfully created.' }
        format.json { render action: 'show', status: :created, location: @page }
      else
        format.html { render action: 'new' }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pages/1
  # PATCH/PUT /pages/1.json
  def update
    respond_to do |format|
      if @page.update(page_params)
        format.html { redirect_to action: 'edit', notice: 'Page was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pages/1
  # DELETE /pages/1.json
  def destroy
    @page.destroy
    respond_to do |format|
      format.html { redirect_to pages_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_page
      @page = Page.find(params[:id])
      @document = Document.find(@page.document_id)
      @template = Template.where("document_id = #{@page.document_id}")
      @sections = Section.where("template_id = #{@page.template_id}").order("id ASC")
      #@assets = Asset.all
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def page_params
      params.require(:page).permit(:document_id, :user_id, :template_id, :language_id, :primary_language_id, :secondary_language_id, :number, :dpi, :height, :width, :top, :bottom, :left, :right, :path, :url, :filename, :exclude, :public, :templatex, :templatey, :tyndale, :modified)
    end
end
