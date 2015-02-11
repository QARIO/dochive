class DocumentsController < ApplicationController
  require 'RMagick'
  require 'fileutils'
  require 'zip'
  require 'to_lang'
  require 'Gchart'
  #require 'googlecharts' 
  require 'mathn'
  
  before_filter :authenticate_user!
  before_action :set_document, only: [:show, :edit, :update, :destroy, :pageActions, :toggleexclude, :prepPage, :separatePages, :zipBatchImport, :createDefaultSettings, :convert, :deletePreviousOutput, :convertAll, :convertPage]


  # -- standard -------------------------------------------

  # GET /documents
  # GET /documents.json
  def index
    #
    @documents = Document.where(user_id: current_user.id)  
  end

  # GET /documents/1
  # GET /documents/1.json
  def show
    @thumb =  "#{@document.source.url}".split("?")[0].gsub("/original/","/original/thumb/")
    @medium =  "#{@document.source.url}".split("?")[0].gsub("/original/","/original/medium/")
  end

  # GET /documents/new
  def new
    # 
    @document = Document.new
  end

  # GET /documents/1/edit
  def edit

    @document = Document.find(params[:id], :conditions => {:user_id => current_user.id}) #bubu
  end

  # POST /documents
  # POST /documents.json
  def create
    @document = Document.create( document_params )
    @document.user_id = current_user.id
    @document.description = document_params[:description]
    @document.phase_id = 1

    respond_to do |format|
      if @document.save

        fileType = File.extname("#{@document.source.path}")

        # perform delayed import and separation based on the file type
        case fileType
        when ".pdf"
          DocumentsController.delay(:queue => 'separate').separatePages(@document.id)
        when ".zip"
          DocumentsController.delay(:queue => 'separate').zipBatchImport(@document.id)
          #zipBatchImport(@document.id)
        #when ".png"
        #when ".tiff"
        #when ".jpg"
        #when ".jpeg"
      else
      end

        #DocumentsController.delay(:queue => 'separate').separatePages(@document.id)          

        format.html { redirect_to documents_url, notice: 'upload successful' }
        format.json { render action: 'index', status: :created, location: @document }
      else
        format.html { render action: 'new' }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /documents/1
  # PATCH/PUT /documents/1.json
  def update
    respond_to do |format|
      if @document.update(document_params)
        format.html { redirect_to @document, notice: 'pdf update successful' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /documents/1
  # DELETE /documents/1.json
  def destroy
    @document.destroy
    
    directory_name = File.dirname("#{@document.source.path}")
    
    p "---------"
    p "---------"
    p "---------"
    p directory_name
    p "---------"
    p "---------"
    p "---------"
    
    #if File.directory?(directory_name) 
    #  FileUtils.rm_r directory_name
    #end
    
    respond_to do |format|
      format.html { redirect_to documents_url }
      format.json { head :no_content }
    end
  end
  

  # -------------------------------------------------------

  #
  def pages
    #
    @document = Document.find(params[:id])
    @pages = Page.where("document_id = "+params[:id]).order("id asc")
    #@pages = Page.where("document_id = "+params[:id]).order("id asc")
    @pages = Page.paginate(:page => params[:page], :per_page => 9).where("document_id = "+params[:id]).order("id asc")
  end
  
  #
  def templates
    #
    @document = Document.find(params[:id])
    @pages = Page.where("document_id = #{@document.id} and (template_id IS NOT NULL or template_id <> '0')").order("id asc")
  end

  #
  def data
    #
    @documents = Document.where(user_id: current_user.id)
  end
  
  #
  def tembuilder
    #
    @page = Page.find(params[:id])
    params[:url]="woot"
  end

  # 
  def inspection
    #
    @page = Page.find(params[:id])
    #@pages = Page.paginate(:page => params[:page], :per_page => 3).where("document_id = "+params[:id]).order("id asc")
  end

  # -------------------------------------------------------

  # 
  def exclude
    p params[:id]
    p params[:checked]

    @pg = Page.find(params[:id])
    
    if(params[:checked]=='true') 
      @pg.exclude = 1
    else
      @pg.exclude = 0
    end

    @pg.save

    render :nothing => true 
  end

  # 
  def settemplate
    p "template set"
    p params[:id]
    p params[:template_id]

    @pg = Page.find(params[:id])
    @pg.template_id = params[:template_id]
    @pg.save

    render :nothing => true 
  end

  # 
  def addsection 
    name = params[:name]
    page_id = params[:page_id]
    yOrigin = params[:yOrigin]
    xOrigin = params[:xOrigin]
    width = params[:width]
    height = params[:height]

    @page = Page.find(page_id)

    yOriginView = yOrigin.to_i
    xOriginView = xOrigin.to_i
    widthView = width.to_i
    heightView = height.to_i

    yOrigin = ((yOrigin.to_i*@page.height.to_i).round / 1230).round
    xOrigin = ((xOrigin.to_i*@page.width.to_i).round / 925).round
    width = ((width.to_i*@page.width.to_i).round / 925).round
    height = ((height.to_i*@page.height.to_i).round / 1230).round

    # Section template_id:integer name:string yOrigin:integer xOrigin:integer width:integer height:integer
    # find template for page

    @builder = Builder.new
    @builder.page_id = page_id
    @builder.name = name
    @builder.xOrigin = xOrigin
    @builder.yOrigin = yOrigin
    @builder.width = width
    @builder.height = height
    @builder.xOriginView = xOriginView
    @builder.yOriginView = yOriginView
    @builder.widthView = widthView
    @builder.heightView = heightView
    @builder.save

    render :nothing => true
  end
  
  # clear builder items per page
  def clearbuilder
    p "Clear Builder"
    # destroy data (csv file) entries
    p params[:id]
    @builders = Builder.where("page_id = "+params[:id])
    @builders.destroy_all

    render :nothing => true 
  end

  # create a new template based on the items in Builder
  def xout___createtemplate
    # get page id
    page_id = params[:id]

    # create new template
    @template = Template.new
    @template.user_id = current_user.id
    @template.group_id = nil
    @template.style_id = nil
    @template.type_id = nil
    @template.name = "Template"
    @template.description = nil
    @template.path = nil
    @template.url = nil
    @template.filename = nil
    @template.save

    # get all builder entries
    @builders = Builder.where("page_id = "+page_id).order("id ASC")   
    
    # create the sections based on builders
    @builders.each { |b|
      @section = Section.new
      @section.template_id = @template.id
      @section.name = b.name
      @section.xOrigin = b.xOrigin
      @section.yOrigin = b.yOrigin
      @section.width = b.width
      @section.height = b.height
      @section.save
    }

    # delete builder entries
    #Builder.delete_all(:page_id => page_id)
    @builders.destroy_all

    # set page t new template id
    @page = Page.find(page_id)
    @page.template_id = @template_id
    @page.save

    # redirect to all templates
    redirect_to "/templates/"
  end

  # 
  def nametemplate
    p params[:id]
    p params[:name]
    p params[:url]

    # get page id
    page_id = params[:id]

    @page = Page.find(params[:id])

    # create new template
    @template = Template.new
    @template.user_id = current_user.id
    @template.group_id = nil
    @template.style_id = nil
    @template.type_id = nil
    @template.name = params[:name]
    @template.description = nil
    @template.path = @page.path
    @template.url = @page.url
    @template.filename = @page.filename
    @template.vpc = @page.vpc
    @template.hpc = @page.hpc
    @template.selfie = 0
    @template.save

    # get all builder entries
    @builders = Builder.where("page_id = "+page_id).order("id ASC")   
    
    # create the sections based on builders
    @builders.each { |b|
      @section = Section.new
      @section.template_id = @template.id
      @section.name = b.name
      @section.xOrigin = b.xOrigin
      @section.yOrigin = b.yOrigin
      @section.width = b.width
      @section.height = b.height
      @section.xOriginView = b.xOriginView
      @section.yOriginView = b.yOriginView
      @section.widthView = b.widthView
      @section.heightView = b.heightView
      @section.save
    }

    # delete builder entries
    #Builder.delete_all(:page_id => page_id)
    @builders.destroy_all

    # set page t new template id
    #@page = Page.find(page_id)
    @page.template_id = @template.id
    @page.save

    #-------------
    
    readFileExtension = ".pdf"
    writeFileExtension = ".png"

    origionalFile = "#{@page.path}".split("?")[0]
    
    filePath = File.dirname("#{@page.path}")
    fileURL = File.dirname("#{@page.url}")
    fileName = File.basename("#{@page.url}".split("?")[0],readFileExtension)
    
    render :nothing => true 
  end

  # 
  def selfie
    p params[:id]
    p params[:name]
    p params[:url]

    # get page id
    page_id = params[:id]

    @page = Page.find(params[:id])

    # create new template
    @template = Template.new
    @template.user_id = current_user.id
    @template.group_id = nil
    @template.style_id = nil
    @template.type_id = nil
    @template.name = params[:name]
    @template.description = nil
    @template.path = @page.path
    @template.url = @page.url
    @template.filename = @page.filename
    @template.vpc = @page.vpc
    @template.hpc = @page.hpc
    @template.selfie = 1
    @template.save

    # get all builder entries
    @builders = Builder.where("page_id = "+page_id).order("id ASC")   
    
    # create the sections based on builders
    @builders.each { |b|
      @section = Section.new
      @section.template_id = @template.id
      @section.name = b.name
      @section.xOrigin = b.xOrigin
      @section.yOrigin = b.yOrigin
      @section.width = b.width
      @section.height = b.height
      @section.xOriginView = b.xOriginView
      @section.yOriginView = b.yOriginView
      @section.widthView = b.widthView
      @section.heightView = b.heightView
      @section.save
    }

    # delete builder entries
    #Builder.delete_all(:page_id => page_id)
    @builders.destroy_all

    # set page t new template id
    #@page = Page.find(page_id)
    @page.template_id = @template.id
    @page.save

    #-------------
    
    readFileExtension = ".pdf"
    writeFileExtension = ".png"

    origionalFile = "#{@page.path}".split("?")[0]
    
    filePath = File.dirname("#{@page.path}")
    fileURL = File.dirname("#{@page.url}")
    fileName = File.basename("#{@page.url}".split("?")[0],readFileExtension)
    
    render :nothing => true 
  end

  # 
  def xout___sselfie
    p params[:id]
    p params[:name]
    p params[:url]

    # get page id
    page_id = params[:id]

    @page = Page.find(params[:id])

    # create new template
    @template = Template.new
    @template.user_id = current_user.id
    @template.group_id = nil
    @template.style_id = nil
    @template.type_id = nil
    @template.name = params[:name]
    @template.description = nil
    @template.path = @page.path
    @template.url = @page.url
    @template.filename = @page.filename
    @template.vpc = @page.vpc
    @template.hpc = @page.hpc
    @template.selfie = 1
    @template.save

    # get all builder entries
    @builders = Builder.where("page_id = "+page_id).order("id ASC")   
    
    # create the sections based on builders
    @builders.each { |b|
      @section = Section.new
      @section.template_id = @template.id
      @section.name = b.name
      @section.xOrigin = b.xOrigin
      @section.yOrigin = b.yOrigin
      @section.width = b.width
      @section.height = b.height
      @section.save
    }

    # delete builder entries
    #Builder.delete_all(:page_id => page_id)
    @builders.destroy_all

    # set page t new template id
    #@page = Page.find(page_id)
    @page.template_id = @template.id
    @page.save

    #-------------
    
    readFileExtension = ".pdf"
    writeFileExtension = ".png"

    origionalFile = "#{@page.path}".split("?")[0]
    
    filePath = File.dirname("#{@page.path}")
    fileURL = File.dirname("#{@page.url}")
    fileName = File.basename("#{@page.url}".split("?")[0],readFileExtension)

    # redirect to all templates
    #redirect_to "/documents/@page.document_id/pages"
    render :nothing => true 
  end

  # -------------------------------------------------------

  # repage a single page and export all csv
  def repage
    # find the page
    @page = Page.find(params[:id]) 

    # convert new page
    self.reprepPage(@page.id)
    
    # convert new page
    self.convertPage(@page.id)

    # export all again to csv
    self.export(@page.document_id)

    # redirect to individual page
    redirect_to "/pages/#{@page.id}/edit"
  end

  # convert
  def convert
    # remove any previous generate files for this document
    deletePreviousOutput(params[:id])

    #remove previous chopped out parts

    # 
    DocumentsController.delay(:queue => 'extraction').convertAll(params[:id])

    # 
    redirect_to "/data/"
  end

  # 
  def toggleexclude(id)
    p "------------------------------------------------------------------------"

    render :text => "success" 
  end

  # delete and cleanup previous output
  def deletePreviousOutput(id)
    # find document
    @document = Document.find(id)
    
    # identify origional file
    origionalFile = "#{@document.source.path}".split("?")[0]
    
    # get the path and url from the document
    filePath = File.dirname("#{@document.source.path}")
    fileURL = File.dirname("#{@document.source.url}")

    # establish path to csv directory
    csvDirectory = filePath + "/csv"

    # remove and csv extracts
    if File.exists?(csvDirectory) then
      FileUtils.rm_rf "#{csvDirectory}", secure: true
    end

    # destroy data (csv file) entries
    Asset.delete_all(:document_id => id)

    # remove any data file entry
    Datum.delete_all(:document_id => id)
  end
  
  # -- self -----------------------------------------------
  
  #
  def self.createDefaultSettings(id)
    #
    @document = Document.find(id)

    # 
    @setting = Setting.where(user_id: @document.user_id).first
    if !@setting.present? then
      @setting = Setting.new
      @setting.user_id = @document.user_id
      @setting.default_template = nil
      @setting.default_language = 13 
      @setting.default_notification = User.find(@document.user_id).email  
      @setting.notify_complete = false
      @setting.trimLeft = 0
      @setting.trimRight = 0
      @setting.trimTop = 0
      @setting.trimBottom = 0
      @setting.save
    end
  end
  
  # prepare a single page       ***************************
  def self.prepPage(id)
    # find document
    @document = Document.find(id)

    # set state to "preprocessing"
    @document.phase_id = 2
    @document.save
    
    # create default settings if necessary
    createDefaultSettings(id)

    #@setting = Setting.where(user_id: current_user.id).first
    @setting = Setting.where(user_id: @document.user_id).first
    
    trimLeft = @setting.trimLeft
    trimRight = @setting.trimRight
    trimTop = @setting.trimTop
    trimBottom = @setting.trimBottom
    
    readFileExtension = ".pdf"
    writeFileExtension = ".png"
    
    origionalFile = "#{@document.source.path}".split("?")[0]
    
    filePath = File.dirname("#{@document.source.path}")
    fileURL = File.dirname("#{@document.source.url}")
    fileName = File.basename("#{@document.source.url}".split("?")[0],readFileExtension)
    
    counter = "0000"

    # separate and align pages create thumbs for pages
    # add the aligned pages to list of document assets
    #img1 = Magick::Image::read(filePath + "/" + fileName + readFileExtension) { 
    img1 = Magick::Image::read(origionalFile) { 

      self.density = 300
      self.image_type = Magick::GrayscaleType
      
      }.each { |img1, i|  

      #
      directory_name = filePath + "/" + "thumb"
      Dir.mkdir(directory_name) unless File.exists?(directory_name)
      #thumb = img1.scale(100, 133)
      #thumb = img1.scale(150, 199)
      thumb = img1.scale(200, 266)
      thumb.write(filePath + "/thumb/" + fileName + "-%04d_th" + writeFileExtension) { }
      
      #
      directory_name = filePath + "/" + "img1"
      Dir.mkdir(directory_name) unless File.exists?(directory_name)
      img1.write(filePath + "/img1/" + fileName + "-%04d" + writeFileExtension) { }
      
      #
      directory_name = filePath + "/" + "img2"
      Dir.mkdir(directory_name) unless File.exists?(directory_name)
      img2 = img1.deskew("40%")   
      img2.write(filePath + "/img2/" + fileName + "-%04d" + writeFileExtension) { }
      
      # quantitize
      directory_name = filePath + "/" + "img3"
      Dir.mkdir(directory_name) unless File.exists?(directory_name)
      img3 = img2.quantize(2, Magick::GRAYColorspace)
      img3.write(filePath + "/img3/" + fileName + "-%04d" + writeFileExtension) { }
      
      # metrics
      width = img3.columns
      height = img3.rows

      # left
      directory_name = filePath + "/" + "img4"
      Dir.mkdir(directory_name) unless File.exists?(directory_name)

      # 
      width = width-trimLeft-trimRight
      height = height-trimTop-trimBottom
      img4 = img3.crop(trimLeft,trimTop,width,height,true)

      # 
      img4.fuzz = "5%"
      img4.write(filePath + "/img4/" + fileName + "-%04d" + writeFileExtension) { }
      
      #
      directory_name = filePath + "/" + "img5"
      Dir.mkdir(directory_name) unless File.exists?(directory_name)
      img5 = img4.trim(true)
      img5.write(filePath + "/img5/" + fileName + "-%04d" + writeFileExtension) { }
      
      # create a medium thumbnail
      directory_name = filePath + "/" + "medium"
      Dir.mkdir(directory_name) unless File.exists?(directory_name)
      #medium = img5.scale(200, 266)
      medium = img5.scale(275, 366)
      medium.write(filePath + "/medium/" + fileName + "-%04d_md" + writeFileExtension) { }
      
      # create a large thumbnail
      directory_name = filePath + "/" + "large"
      Dir.mkdir(directory_name) unless File.exists?(directory_name)
      large = img5.scale(0.3)
      large.write(filePath + "/large/" + fileName + "-%04d_lg" + writeFileExtension) { }
      
      # create extra large thumbnail
      directory_name = filePath + "/" + "xlarge"
      Dir.mkdir(directory_name) unless File.exists?(directory_name)
      xlarge = img5.scale(925,1230)
      xlarge.write(filePath + "/xlarge/" + fileName + "-%04d_xlg" + writeFileExtension) { }
      
      #new metrics
      wdth = img5.columns
      hght = img5.rows
      
      #p "-~-~^-"
      #imgX = img5.scale(wdth, 1)
      #imgY = img5.scale(1, hght)
      
      imgX1 = img5.scale(640, 1)
      imgY1 = img5.scale(1, 640)

      
      #
      #
      directory_name = filePath + "/" + "template"
      Dir.mkdir(directory_name) unless File.exists?(directory_name)
      imgX1.write(filePath + "/template/" + fileName + "-%04d-imgX1" + writeFileExtension) { }
      imgY1.write(filePath + "/template/" + fileName + "-%04d-imgY1" + writeFileExtension) { }
      
      #imgX1.write(filePath + "/template/" + fileName + "-%02d-imgX1" + ".txt") { }
      #imgY1.write(filePath + "/template/" + fileName + "-%02d-imgY1" + ".txt") { }
      
      #create graph
      
      imgX2 = imgX1.scale(640, 1)
      imgY2 = imgY1.scale(1, 640)
      
      imgX2.write(filePath + "/template/" + fileName + "-%04d-imgX2" + writeFileExtension) { }
      imgY2.write(filePath + "/template/" + fileName + "-%04d-imgy2" + writeFileExtension) { }
      
      #log page
      @page = Page.new
      @page.document_id = id
      @page.user_id = @document.user_id
      @page.template_id = @setting.default_template
      @page.language_id = @setting.default_language
      @page.number = counter
      @page.dpi = 300
      @page.height = hght
      @page.width = wdth
      @page.top = trimTop
      @page.bottom = trimBottom
      @page.left = trimLeft
      @page.right = trimRight
      @page.filename = fileName + "-#{counter}" + writeFileExtension
      @page.path = filePath + "/img5/"
      @page.url = fileURL + "/img5/"
      @page.exclude = false
      @page.public = false
      @page.save

      #next counter
      counter = counter.next
    }

    # set state to "ready"
    @document.phase_id = 4
    @document.save

    notify(id, 1)
  end
  
  # re prepare a single page    ***************************
  def self.reprepPage(id)
    # find page
    @page = Page.find(id)

    # find document
    @document = Document.find(@page.document_id)

    # set state to "preprocessing"
    @document.phase_id = 2
    @document.save
    
    # create default settings if necessary
    createDefaultSettings(id)

    #@setting = Setting.where(user_id: current_user.id).first
    @setting = Setting.where(user_id: @document.user_id).first
    
    trimLeft = @page.left
    trimRight = @page.right
    trimTop = @page.top
    trimBottom = @page.bottom
    
    readFileExtension = ".pdf"
    writeFileExtension = ".png"
    
    origionalFile = "#{@document.source.path}".split("?")[0]
    
    ###--### filePath = File.dirname("#{@document.source.path}")
    ###--### fileURL = File.dirname("#{@document.source.url}")
    ###--### fileName = File.basename("#{@document.source.url}".split("?")[0],readFileExtension)
    
    ###--### counter = "0000"

    # separate and align pages create thumbs for pages
    # add the aligned pages to list of document assets
    #img1 = Magick::Image::read(filePath + "/" + fileName + readFileExtension) { 
    img1 = Magick::Image::read(origionalFile) { 

      self.density = 300
      self.image_type = Magick::GrayscaleType
      
      }.each { |img1, i|  

      #
      directory_name = filePath + "/" + "thumb"
      Dir.mkdir(directory_name) unless File.exists?(directory_name)
      #thumb = img1.scale(100, 133)
      #thumb = img1.scale(150, 199)
      thumb = img1.scale(200, 266)
      thumb.write(filePath + "/thumb/" + fileName + "-%04d_th" + writeFileExtension) { }
      
      #
      directory_name = filePath + "/" + "img1"
      Dir.mkdir(directory_name) unless File.exists?(directory_name)
      img1.write(filePath + "/img1/" + fileName + "-%04d" + writeFileExtension) { }
      
      #
      directory_name = filePath + "/" + "img2"
      Dir.mkdir(directory_name) unless File.exists?(directory_name)
      img2 = img1.deskew("40%")   
      img2.write(filePath + "/img2/" + fileName + "-%04d" + writeFileExtension) { }
      
      # quantitize
      directory_name = filePath + "/" + "img3"
      Dir.mkdir(directory_name) unless File.exists?(directory_name)
      img3 = img2.quantize(2, Magick::GRAYColorspace)
      img3.write(filePath + "/img3/" + fileName + "-%04d" + writeFileExtension) { }
      
      # metrics
      width = img3.columns
      height = img3.rows

      # left
      directory_name = filePath + "/" + "img4"
      Dir.mkdir(directory_name) unless File.exists?(directory_name)

      # 
      width = width-trimLeft-trimRight
      height = height-trimTop-trimBottom
      img4 = img3.crop(trimLeft,trimTop,width,height,true)

      # 
      img4.fuzz = "5%"
      img4.write(filePath + "/img4/" + fileName + "-%04d" + writeFileExtension) { }
      
      #
      directory_name = filePath + "/" + "img5"
      Dir.mkdir(directory_name) unless File.exists?(directory_name)
      img5 = img4.trim(true)
      img5.write(filePath + "/img5/" + fileName + "-%04d" + writeFileExtension) { }
      
      # create a medium thumbnail
      directory_name = filePath + "/" + "medium"
      Dir.mkdir(directory_name) unless File.exists?(directory_name)
      #medium = img5.scale(200, 266)
      medium = img5.scale(275, 366)
      medium.write(filePath + "/medium/" + fileName + "-%04d_md" + writeFileExtension) { }
      
      # create a large thumbnail
      directory_name = filePath + "/" + "large"
      Dir.mkdir(directory_name) unless File.exists?(directory_name)
      large = img5.scale(0.3)
      large.write(filePath + "/large/" + fileName + "-%04d_lg" + writeFileExtension) { }
      
      # create extra large thumbnail
      directory_name = filePath + "/" + "xlarge"
      Dir.mkdir(directory_name) unless File.exists?(directory_name)
      xlarge = img5.scale(925,1230)
      xlarge.write(filePath + "/xlarge/" + fileName + "-%04d_xlg" + writeFileExtension) { }
      
      #new metrics
      wdth = img5.columns
      hght = img5.rows
      
      # 
      imgX1 = img5.scale(640, 1)
      imgY1 = img5.scale(1, 640)

      # 
      directory_name = filePath + "/" + "template"
      Dir.mkdir(directory_name) unless File.exists?(directory_name)
      imgX1.write(filePath + "/template/" + fileName + "-%04d-imgX1" + writeFileExtension) { }
      imgY1.write(filePath + "/template/" + fileName + "-%04d-imgY1" + writeFileExtension) { }
      
      #
      #imgX1.write(filePath + "/template/" + fileName + "-%02d-imgX1" + ".txt") { }
      #imgY1.write(filePath + "/template/" + fileName + "-%02d-imgY1" + ".txt") { }
      
      #create graph
      
      #
      imgX2 = imgX1.scale(640, 1)
      imgY2 = imgY1.scale(1, 640)
      
      #
      imgX2.write(filePath + "/template/" + fileName + "-%04d-imgX2" + writeFileExtension) { }
      imgY2.write(filePath + "/template/" + fileName + "-%04d-imgy2" + writeFileExtension) { }
      
      #
      #imgX2.write(filePath + "/template/" + fileName + "-%02d-imgX2" + ".txt") { }
      #imgY2.write(filePath + "/template/" + fileName + "-%02d-imgY2" + ".txt") { }
      
      #create graph      
      
      #create hash
      #search hash
      #determine if template exists
      # set page template id below

      #
      @page.height = hght
      @page.width = wdth
      ###--### @page.filename = fileName + "-#{counter}" + writeFileExtension
      ###--### @page.path = filePath + "/img5/"
      ###--### @page.url = fileURL + "/img5/"
      ###--### @page.exclude = false
      ###--### @page.public = false
      @page.save

      #next counter
      counter = counter.next
    }

    # set state to "ready"
    @document.phase_id = 4
    @document.save

    notify(id, 2)
  end

  # separate pages and prepare  ***************************
  def self.separatePages(id)
    # find document
    @document = Document.find(id)

    # set state to "preprocessing"
    @document.phase_id = 2
    @document.save
    
    # create default settings if necessary
    createDefaultSettings(id)

    #@setting = Setting.where(user_id: current_user.id).first
    @setting = Setting.where(user_id: @document.user_id).first
    
    trimLeft = @setting.trimLeft
    trimRight = @setting.trimRight
    trimTop = @setting.trimTop
    trimBottom = @setting.trimBottom
    
    readFileExtension = ".pdf"
    writeFileExtension = ".png"
    
    origionalFile = "#{@document.source.path}".split("?")[0]
    
    filePath = File.dirname("#{@document.source.path}")
    fileURL = File.dirname("#{@document.source.url}")
    fileName = File.basename("#{@document.source.url}".split("?")[0],readFileExtension)
    
    counter = "0000"

    # separate and align pages create thumbs for pages
    # add the aligned pages to list of document assets
    #img1 = Magick::Image::read(filePath + "/" + fileName + readFileExtension) { 
    img1 = Magick::Image::read(origionalFile) { 

      self.density = 300
      self.image_type = Magick::GrayscaleType
      
      }.each { |img1, i|  

      #
      directory_name = filePath + "/" + "thumb"
      Dir.mkdir(directory_name) unless File.exists?(directory_name)
      #thumb = img1.scale(100, 133)
      #thumb = img1.scale(150, 199)
      thumb = img1.scale(200, 266)
      thumb.write(filePath + "/thumb/" + fileName + "-%04d_th" + writeFileExtension) { }
      
      #
      directory_name = filePath + "/" + "img1"
      Dir.mkdir(directory_name) unless File.exists?(directory_name)
      img1.write(filePath + "/img1/" + fileName + "-%04d" + writeFileExtension) { }
      
      #
      directory_name = filePath + "/" + "img2"
      Dir.mkdir(directory_name) unless File.exists?(directory_name)
      img2 = img1.deskew("40%")   
      img2.write(filePath + "/img2/" + fileName + "-%04d" + writeFileExtension) { }
      
      # quantitize
      directory_name = filePath + "/" + "img3"
      Dir.mkdir(directory_name) unless File.exists?(directory_name)
      img3 = img2.quantize(2, Magick::GRAYColorspace)
      img3.write(filePath + "/img3/" + fileName + "-%04d" + writeFileExtension) { }
      
      # metrics
      width = img3.columns
      height = img3.rows

      # left
      directory_name = filePath + "/" + "img4"
      Dir.mkdir(directory_name) unless File.exists?(directory_name)

      # 
      width = width-trimLeft-trimRight
      height = height-trimTop-trimBottom
      img4 = img3.crop(trimLeft,trimTop,width,height,true)

      # 
      img4.fuzz = "5%"
      img4.write(filePath + "/img4/" + fileName + "-%04d" + writeFileExtension) { }
      
      #
      directory_name = filePath + "/" + "img5"
      Dir.mkdir(directory_name) unless File.exists?(directory_name)
      img5 = img4.trim(true)
      img5.write(filePath + "/img5/" + fileName + "-%04d" + writeFileExtension) { }
      
      # create a medium thumbnail
      directory_name = filePath + "/" + "medium"
      Dir.mkdir(directory_name) unless File.exists?(directory_name)
      #medium = img5.scale(200, 266)
      medium = img5.scale(275, 366)
      medium.write(filePath + "/medium/" + fileName + "-%04d_md" + writeFileExtension) { }
      
      # create a large thumbnail
      directory_name = filePath + "/" + "large"
      Dir.mkdir(directory_name) unless File.exists?(directory_name)
      large = img5.scale(0.3)
      large.write(filePath + "/large/" + fileName + "-%04d_lg" + writeFileExtension) { }
      
      # create extra large thumbnail
      directory_name = filePath + "/" + "xlarge"
      Dir.mkdir(directory_name) unless File.exists?(directory_name)
      xlarge = img5.scale(925,1230)
      xlarge.write(filePath + "/xlarge/" + fileName + "-%04d_xlg" + writeFileExtension) { }
      
      #new metrics
      wdth = img5.columns
      hght = img5.rows
      
      #p "-~-~^--~-~^--~-~^--~-~^--~-~^--~-~^--~-~^--~-~^--~-~^--~-~^--~-~^--~-~^-"
      #p "-~-~^--~-~^--~-~^--~-~^--~-~^--~-~^--~-~^--~-~^--~-~^--~-~^--~-~^--~-~^-"
      
      h1A = img5.scale(wdth.to_i, 1)
      w1A = img5.scale(1, hght.to_i)
      
      directory_name = filePath + "/" + "H1"
      Dir.mkdir(directory_name) unless File.exists?(directory_name)
      h1A.write(filePath + "/H1/" + fileName + "-%04d-xH1A" + writeFileExtension) { }
      w1A.write(filePath + "/H1/" + fileName + "-%04d-xW1A" + writeFileExtension) { }
      
      #h2A = h1A.scale(640, 25)
      #w2A = w1A.scale(25, 640)
      h2A = h1A.scale(640, 25)
      w2A = w1A.scale(25, 640)
      
      directory_name = filePath + "/" + "H2"
      Dir.mkdir(directory_name) unless File.exists?(directory_name)
      #h2A.write(filePath + "/H2/" + fileName + "-%04d-xH2A" + writeFileExtension) { }
      #w2A.write(filePath + "/H2/" + fileName + "-%04d-xW2A" + writeFileExtension) { }
      h2A.write(filePath + "/H2/" + fileName + "-%04d-xH2A" + writeFileExtension) { }
      w2A.write(filePath + "/H2/" + fileName + "-%04d-xW2A" + writeFileExtension) { }
      
      imgHorzSpectrum = h1A.scale(640, 1)
      imgVertSpectrum = w1A.scale(1, 640)
      
      directory_name = filePath + "/" + "H3"
      Dir.mkdir(directory_name) unless File.exists?(directory_name)
      #h3A.write(filePath + "/H3/" + fileName + "-%04d-xH3A" + writeFileExtension) { }
      #w3A.write(filePath + "/H3/" + fileName + "-%04d-xW3A" + writeFileExtension) { }
      imgHorzSpectrum.write(filePath + "/H3/" + fileName + "-%04d-xH3A" + writeFileExtension) { }
      imgVertSpectrum.write(filePath + "/H3/" + fileName + "-%04d-xW3A" + writeFileExtension) { }
      
      directory_name = filePath + "/" + "H3txt"
      Dir.mkdir(directory_name) unless File.exists?(directory_name)
      #h3A.write(filePath + "/H3txt/" + fileName + "-%04d-xH3A" + ".txt") { }
      #w3A.write(filePath + "/H3txt/" + fileName + "-%04d-xW3A" + ".txt") { }
      imgHorzSpectrum.write(filePath + "/H3txt/" + fileName + "-%04d-xH3A" + ".txt") { }
      imgVertSpectrum.write(filePath + "/H3txt/" + fileName + "-%04d-xW3A" + ".txt") { }

      #p "-~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~-"
      

      # Get the greyscale pixel vaues. Used to build spectrum.

      (horz ||= []) << imgHorzSpectrum.get_pixels(0, 0, 640, 1) 
      (vert ||= []) << imgVertSpectrum.get_pixels(0, 0, 1, 640)


      #p "-~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~-"

      p "***********************************************************************"  

      #p "**************** horz array ******************************************"  

      @horz_array = Array.new
      horz.each { |x| 

        horzSplit = x.split(/\r?\n/).join().split()
        
        horzSplit.each { |hs|
          temp = hs.match /red=\d{1,}/
          
          if (temp!=nil)
            part = temp[0].partition('=').last
            #p part.to_i
            @horz_array << part.to_i
          end
          
        }                  
      }
      

      #p "**************** vert array ****************************************"  

      @vert_array = Array.new
      vert.each { |y| 

        vertSplit = y.split(/\r?\n/).join().split()
        
        vertSplit.each { |vs|
          temp = vs.match /red=\d{1,}/
          
          if (temp!=nil)
            part = temp[0].partition('=').last
            #p part.to_i
            @vert_array << part.to_i
          end
          
        }                  
      }

      #p "-~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~--~-"

      directory_name = filePath + "/" + "intensity"
      Dir.mkdir(directory_name) unless File.exists?(directory_name)
      
      #p "-~-~^--~-~^--~-~^--~-~^--~-~^--~-~^--~-~^--~-~^--~-~^--~-~^--~-~^--~-~^-"

      # perform operations based on extracted spectra
      
      # invert
      @horz_inv = invert(@horz_array)
      @vert_inv = invert(@vert_array)

      # binomial soomthing
      @horz_binsmo = binsmo(2,@horz_inv)
      @vert_binsmo = binsmo(2,@vert_inv)

      # find peaks (2d array)
      @twod_horz_peaks = findPeaks(@horz_binsmo)
      @twod_vert_peaks = findPeaks(@vert_binsmo)

      # build peaks for visual plotting
      @horz_peaks = findPlotPeaks(@horz_binsmo)
      @vert_peaks = findPlotPeaks(@vert_binsmo)

      # build exagarated peaks for visual plotting
      @horz_alt = alternatePeakView(@horz_peaks)
      @vert_alt = alternatePeakView(@vert_peaks)
      
      #p "-~-~^--~-~^--~-~^--~-~^--~-~^--~-~^--~-~^--~-~^--~-~^--~-~^--~-~^--~-~^-"

      @idTemplate = nil
      @idTemplate = findTemplate(@twod_horz_peaks,@twod_vert_peaks)
      
      #p "-~-~^--~-~^--~-~^--~-~^--~-~^--~-~^--~-~^--~-~^--~-~^--~-~^--~-~^--~-~^-"

      fn1 = filePath + "/intensity/" + fileName + "-" + "#{counter}" + "-A.png"
      p fn1
      
      fn2 = filePath + "/intensity/" + fileName + "-" + "#{counter}" + "-B.png"
      p fn2
      
      fn3 = filePath + "/intensity/" + fileName + "-" + "#{counter}" + "-C.png"
      p fn3
      
      fn4 = filePath + "/intensity/" + fileName + "-" + "#{counter}" + "-D.png"
      p fn4
      
      fn5 = filePath + "/intensity/" + fileName + "-" + "#{counter}" + "-E.png"
      #p fn5

      #p "-~-~^--~-~^--~-~^--~-~^--~-~^--~-~^--~-~^--~-~^--~-~^--~-~^--~-~^--~-~^-"

      Gchart.line(:data =>  [@horz_array, @horz_binsmo, @horz_peaks], 
        :format => 'file', 
        :size => '640x200',
        :filename => fn1, 
        :line_colors => "993300,834C24,6600CC",
                  :stacked => false#,
                  #:legend => ["Height", "Width"]
                  )

      Gchart.line(:data =>  [@horz_array, @horz_binsmo, @horz_alt], 
        :format => 'file', 
        :size => '640x200',
        :filename => fn2, 
        :line_colors => "993300,834C24,6600CC",
                  :stacked => false#,
                  #:legend => ["Height", "Width"]
                  )
      Gchart.line(:data =>  [@vert_array, @vert_binsmo, @vert_peaks], 
        :format => 'file', 
        :size => '640x200',
        :filename => fn3, 
        :line_colors => "993300,834C24,6600CC",
                  :stacked => false#,
                  #:legend => ["Height", "Width"]
                  )
      Gchart.line(:data =>  [@vert_array, @vert_binsmo, @vert_alt], 
        :format => 'file', 
        :size => '640x200',
        :filename => fn4, 
        :line_colors => "993300,834C24,6600CC",
                  :stacked => false#,
                  #:legend => ["Height", "Width"]
                  )

      #p "-~-~^--~-~^--~-~^--~-~^--~-~^--~-~^--~-~^--~-~^--~-~^--~-~^--~-~^--~-~^-"

      #@setting = Setting.where(user_id: current_user.id).first
      @setting = Setting.where(user_id: @document.user_id).first

      #log page
      @page = Page.new
      @page.document_id = id
      @page.user_id = @document.user_id

      if (@idTemplate!=nil)
        # set template
      #  @page.template_id = @idTemplate
      else
        # set to default
        # @page.template_id = @setting.default_template.to_i

        # create new template
        @template = Template.new
        @template.user_id = @document.user_id
        @template.group_id = nil
        @template.style_id = nil
        @template.type_id = nil
        @template.name = "selfie"
        @template.description = nil
        @template.path = filePath + "/img5/"
        @template.url = fileURL + "/img5/"
        @template.filename = fileName + "-#{counter}" + writeFileExtension
        @template.vpc = @twod_horz_peaks.length
        @template.hpc = @twod_vert_peaks.length
        @template.selfie = 1
        @template.save

        @section = Section.new
        @section.template_id = @template.id
        @section.name = "selfie"
        @section.xOrigin = ((10*hght.to_i).round / 1230).round
        @section.yOrigin = ((10*wdth.to_i).round / 925).round
        @section.width = ((905*wdth.to_i).round / 925).round 
        @section.height = ((1210*hght.to_i).round / 1230).round
        @section.xOriginView = 10             
        @section.yOriginView = 10             
        @section.widthView = 905               
        @section.heightView = 1210             
        @section.save

        #
        #
        #yOriginView = yOrigin.to_i
        #xOriginView = xOrigin.to_i
        #widthView = width.to_i
        #heightView = height.to_i

        #yOrigin = ((10*hght.to_i).round / 1230).round
        #xOrigin = ((10*wdth.to_i).round / 925).round
        #width = ((905*wdth.to_i).round / 925).round
        #height = ((1210*hght.to_i).round / 1230).round
        #
        #

        @page.template_id = @template.id
      end
      
      @page.language_id = @setting.default_language.to_i
      @page.number = counter
      @page.dpi = 300
      @page.height = hght
      @page.width = wdth
      @page.top = trimTop
      @page.bottom = trimBottom #@setting.default_template
      @page.left = trimLeft
      @page.right = trimRight
      @page.templatex = 0
      @page.templatey = 0
      @page.filename = fileName + "-#{counter}" + writeFileExtension
      @page.vpc = @twod_horz_peaks.length
      @page.hpc = @twod_vert_peaks.length
      @page.path = filePath + "/img5/"
      @page.url = fileURL + "/img5/"
      @page.exclude = false
      @page.public = false
      @page.save

      #p "-~-~^--~-~^--~-~^--~-~^--~-~^--~-~^--~-~^--~-~^--~-~^--~-~^--~-~^--~-~^-"

      savePagePeaks(@twod_horz_peaks, "X", @page.id)
      savePagePeaks(@twod_vert_peaks, "Y", @page.id)

      #p "-~-~^--~-~^--~-~^--~-~^--~-~^--~-~^--~-~^--~-~^--~-~^--~-~^--~-~^--~-~^-"

      counter = counter.next
    }

    # set state to "ready"
    @document.phase_id = 4
    @document.save

    #notify(id,1)
  end

  #p "-~-~^--~-~^--~-~^--~-~^--~-~^--~-~^--~-~^--~-~^--~-~^--~-~^--~-~^--~-~^--~-~^-"

  # invert the given array
  def self.invert(array)
    # new array built here
    result = [] 

    # invert
    array.each_index do |i|
      result[i] = 65535 - array[i]
    end

    # return the result array
    return result
  end

  # binomial smoothing
  def self.binsmo(n,array)
    # new array built here
    result = [] 

    # smooth based on n
    # n must be a positive even integer
    array.each_index do |i|

      if((i>n)and(i<(array.length-n)))
        sum = 0
        
        for iteration in 1..(2*n+1) do
          sum = sum + (array[(i-n-1)+iteration]*(1/(2*n+1)))
        end
        
        result[i] = sum
      else
        result[i] = array[i]
      end

    end

    # return smoothed array
    return result
  end

  # return array with peaks highlighted, all else zeros
  def self.findPeaks(array)
    twod_result = [] # new array built here

    offset        = 0
    first         = true
    firstFalling  = false
    increasing    = false
    threshold     = 2500
    currentValue  = 0
    x             = 0

    count = 0

    array.each_index do |i|
      if((i>4)and(i<(array.length-5)))
        if((array[i-4]<=array[i-3]) and (array[i-3]<=array[i-2]) and (array[i-2]<=array[i-1]) and (array[i-1]<=array[i]) and (array[i]>=array[i+1]) and (array[i+1]>=array[i+2]) and (array[i+2]>=array[i+3]) and (array[i+3]>=array[i+4]))
          if(array[i]>threshold)
            twod_result[count] = []
            twod_result[count][0] = i
            twod_result[count][1] = array[i]
            count = count + 1
          else
            #result[i] = 0
          end
        else
          #result[i] = 0
        end
      else
        #result[i] = 0
      end
    end

    # return the result array
    return twod_result
  end

  # return array with peaks highlighted, all else zeros
  def self.findPlotPeaks(array)
    result = [] # new array built here

    offset        = 0
    first         = true
    firstFalling  = false
    increasing    = false
    threshold     = 2500
    currentValue  = 0
    x             = 0;

    array.each_index do |i|
      if((i>4)and(i<(array.length-5)))
        if((array[i-4]<=array[i-3]) and (array[i-3]<=array[i-2]) and (array[i-2]<=array[i-1]) and (array[i-1]<=array[i]) and (array[i]>=array[i+1]) and (array[i+1]>=array[i+2]) and (array[i+2]>=array[i+3]) and (array[i+3]>=array[i+4]))
          if(array[i]>threshold)
            result[i] = array[i]
          else
            result[i] = 0
          end
        else
          result[i] = 0
        end
      else
        result[i] = 0
      end
    end

    # return the result array
    return result
  end

  # iterate through array and save peaks
  def self.savePagePeaks(twod_array, dimension, page_id)

    # skip pages that did not have clear metrics
    if(twod_array.length>0) 
      twod_array.each_index do |i|
        @peak           = Peak.new
        @peak.page_id   = page_id
        @peak.dimension = dimension
        @peak.number    = i
        @peak.offset    = twod_array[i][0]
        @peak.intensity = twod_array[i][1]
        @peak.save
      end
    end
  end

  # generate exagerated peek representation (visualization)
  def self.alternatePeakView(array)
    result = [] # new array built here

    array.each_index do |i|
      if(array[i] > 0)
        result[i] = array[i] + 40000
      else
        result[i] = 1000
      end
    end

    # return the result array
    return result
  end

  # find template based of page arrays
  def self.findTemplate(twod_horz_peaks, twod_vert_peaks)

    template_id = nil

    hpc = twod_horz_peaks.length
    vpc = twod_vert_peaks.length

    if ((hpc>0) and (vpc>0))

      # find template set with matching hpc and vpc

      # for each found

        # find the marker
        # is the vertical positioning about the same
        # is the horizontal positioning about the same
        # then we found a match
        # set template_id
      # 

    end
    
    # find all markers with same number number of peaks
    # @marker = Marker.find()
    # return template id

    return template_id
  end

  #p "-~-~^--~-~^--~-~^--~-~^--~-~^--~-~^--~-~^--~-~^--~-~^--~-~^--~-~^--~-~^--~-~^-"

  #
  def self.pageActions(id)      
  end

  #
  def self.unzip_file (file, destination)
    Zip::File.open(file) { |zip_file|
     zip_file.each { |f|
       f_path=File.join(destination, f.name)
       FileUtils.mkdir_p(File.dirname(f_path))
       zip_file.extract(f, f_path) unless File.exist?(f_path)
     }
   }
 end

  #
  def self.zipBatchImport(id)
    # find document
    @document = Document.find(id)

    # set state to "preprocessing"
    @document.phase_id = 2
    @document.save
    
    # create default settings if necessary
    createDefaultSettings(id)

    @setting = Setting.where(user_id: @document.user_id).first
    
    trimLeft = @setting.trimLeft
    trimRight = @setting.trimRight
    trimTop = @setting.trimTop
    trimBottom = @setting.trimBottom
    
    readFileExtension = ".pdf"
    writeFileExtension = ".png"
    
    filePath = File.dirname("#{@document.source.path}")
    fileURL = File.dirname("#{@document.source.url}")
    fileName = File.basename("#{@document.source.url}".split("?")[0],".zip")
    
    zipPath = filePath.gsub("thumb/","")
    counter = "0000"

    # extract zip contents to directory
    unzip_file(zipPath + "/" + fileName + ".zip", zipPath + "/")


    # work on all .pdf files in the directory
    Dir.glob(zipPath + "/*.pdf") do |file|
    # do work on files ending in .rb in the desired directory

      #
      origionalFile = file
      p file

      # separate and align pages create thumbs for pages
      # add the aligned pages to list of document assets
      img1 = Magick::Image::read(origionalFile) { 

        self.density = 300
        self.image_type = Magick::GrayscaleType

        }.each { |img1, i|  
        #
        directory_name = filePath + "/" + "thumb"
        Dir.mkdir(directory_name) unless File.exists?(directory_name)
        #thumb = img1.scale(100, 133)
        #thumb = img1.scale(150, 199)
        thumb = img1.scale(200, 266)
        thumb.write(filePath + "/thumb/" + fileName + "-#{counter}_th" + writeFileExtension) { }
        
        #
        directory_name = filePath + "/" + "img1"
        Dir.mkdir(directory_name) unless File.exists?(directory_name)
        img1.write(filePath + "/img1/" + fileName + "-#{counter}" + writeFileExtension) { }
        
        #
        directory_name = filePath + "/" + "img2"
        Dir.mkdir(directory_name) unless File.exists?(directory_name)
        img2 = img1.deskew("40%")   
        img2.write(filePath + "/img2/" + fileName + "-#{counter}" + writeFileExtension) { }
        
        # quantitize
        directory_name = filePath + "/" + "img3"
        Dir.mkdir(directory_name) unless File.exists?(directory_name)
        img3 = img2.quantize(2, Magick::GRAYColorspace)
        img3.write(filePath + "/img3/" + fileName + "-#{counter}" + writeFileExtension) { }
        
        # metrics
        width = img3.columns
        height = img3.rows

        # left
        directory_name = filePath + "/" + "img4"
        Dir.mkdir(directory_name) unless File.exists?(directory_name)

        # 
        width = width-trimLeft-trimRight
        height = height-trimTop-trimBottom
        img4 = img3.crop(trimLeft,trimTop,width,height,true)

        # 
        img4.fuzz = "5%"
        img4.write(filePath + "/img4/" + fileName + "-#{counter}" + writeFileExtension) { }
        
        #
        directory_name = filePath + "/" + "img5"
        Dir.mkdir(directory_name) unless File.exists?(directory_name)
        img5 = img4.trim(true)
        img5.write(filePath + "/img5/" + fileName + "-#{counter}" + writeFileExtension) { }
        
        # create a medium thumbnail
        directory_name = filePath + "/" + "medium"
        Dir.mkdir(directory_name) unless File.exists?(directory_name)
        #medium = img5.scale(200, 266)
        medium = img5.scale(275, 366)
        medium.write(filePath + "/medium/" + fileName + "-#{counter}_md" + writeFileExtension) { }
        
        # create a large thumbnail
        directory_name = filePath + "/" + "large"
        Dir.mkdir(directory_name) unless File.exists?(directory_name)
        large = img5.scale(0.3)
        large.write(filePath + "/large/" + fileName + "-#{counter}_lg" + writeFileExtension) { }
        
        # create extra large thumbnail
        directory_name = filePath + "/" + "xlarge"
        Dir.mkdir(directory_name) unless File.exists?(directory_name)
        xlarge = img5.scale(925,1230)
        xlarge.write(filePath + "/xlarge/" + fileName + "-#{counter}_xlg" + writeFileExtension) { }
        
        #new metrics
        wdth = img5.columns
        hght = img5.rows
        
        #p "-~-~^-"
        #imgX = img5.scale(wdth, 1)
        #imgY = img5.scale(1, hght)
        
        imgX1 = img5.scale(640, 1)
        imgY1 = img5.scale(1, 640)

        
        #
        #
        directory_name = filePath + "/" + "template"
        Dir.mkdir(directory_name) unless File.exists?(directory_name)
        imgX1.write(filePath + "/template/" + fileName + "-#{counter}-imgX1" + writeFileExtension) { }
        imgY1.write(filePath + "/template/" + fileName + "-#{counter}-imgY1" + writeFileExtension) { }
        
        #imgX1.write(filePath + "/template/" + fileName + "-%02d-imgX1" + ".txt") { }
        #imgY1.write(filePath + "/template/" + fileName + "-%02d-imgY1" + ".txt") { }
        
        #create graph
        
        imgX2 = imgX1.scale(640, 1)
        imgY2 = imgY1.scale(1, 640)
        
        imgX2.write(filePath + "/template/" + fileName + "-#{counter}-imgX2" + writeFileExtension) { }
        imgY2.write(filePath + "/template/" + fileName + "-#{counter}-imgy2" + writeFileExtension) { }
        
        #imgX2.write(filePath + "/template/" + fileName + "-%02d-imgX2" + ".txt") { }
        #imgY2.write(filePath + "/template/" + fileName + "-%02d-imgY2" + ".txt") { }
        
        #create graph      
        #create hash
        #search hash
        #determine if template exists
        # set page template id below

        #log page
        @page = Page.new
        @page.document_id = id
        @page.user_id = @document.user_id
        @page.template_id = 0 #@setting.default_template
        @page.language_id = @setting.default_language
        @page.number = counter
        @page.dpi = 300
        @page.height = hght
        @page.width = wdth
        @page.top = trimTop
        @page.bottom = trimBottom
        @page.left = trimLeft
        @page.right = trimRight
        @page.filename = fileName + "-#{counter}" + writeFileExtension
        @page.path = filePath + "/img5/"
        @page.url = fileURL + "/img5/"
        @page.exclude = false
        @page.public = false
        @page.save

        #next counter
        counter = counter.next
      }
    end

    # set state to "ready"
    @document.phase_id = 4
    @document.save

    notify(id,1)
  end

  # export based on document id 
  def self.export(id)

    # find document
    @document = Document.find(id)

    #set state to "extracting"
    @document.phase_id = 5
    @document.save

    # find the applicable pages
    @pages = Page.where("document_id = "+id+" and exclude = 0").order("number ASC")  
    #@again = true

    # iterate through each page
    @pages.each { |po|
      p po.id
      po.template_id

      @template = Template.find(po.template_id)
      @sections = Section.where("template_id = #{@template.id}")
      @assets = Asset.where("page_id = #{po.id}").order("id ASC")
      
      line = ""
      @assets.each { |az|
        line = line + " \"" + az.value + "\", "
      }
      
      p line
      ln = line.length-3
      line = line[0..ln]

      csvDirectory = po.path.gsub("/img5/","/csv/")
      Dir.mkdir(csvDirectory) unless File.exists?(csvDirectory)
      
      #@doc = Document.find(po.document_id)
      fn = File.basename("#{@document.source.url}".split("?")[0],".pdf") + "-#{@template.name}.csv"
      
      p fn
      somefile = File.open(csvDirectory + fn, "a")
      somefile.puts line
      
      p @template.id

      @datum = Datum.where("template_id = #{@template.id} and document_id = #{po.document_id}")
      
      if (@datum.count < 1) then
        #@again = false
        
        @datum = Datum.new
        @datum.document_id = @document.id
        @datum.template_id = @template.id
        @datum.page_id = po.id
        @datum.path = csvDirectory
        @datum.url = po.url.gsub("/img5/","/csv/")
        @datum.filename = fn
        @datum.description = @document.description
        @datum.save  
      end
      
      somefile.close

      # set state_id to "ready / extracted"
      @document.phase_id = 6
      @document.save
    }    
  end

  #
  def self.convertAll(id)
    p "convertAll"
    # find document
    @document = Document.find(id)

    # set state to "extracting"
    @document.phase_id = 5
    @document.save

    # 
    @pages = Page.where("document_id = "+id+" and exclude = 0").order("number ASC")   
    
    # 
    @pages.each { |po|
      p po.id
      convertPage(po.id)
    } 
    
    # export data
    export(id)

    # set state to "ready / extracted"
    @document.phase_id = 6
    @document.save

    # notify
    #notify(id, 3)
  end

  # ocr convert a page with 
  # configured template      
  def self.convertPage(id)
    @page = Page.find(id)

    #@rmassets = Asset.where("page_id = #{@page.id}")
    #@rmassets.delete_all
    
    p @page.template_id
    @template = Template.find(@page.template_id)
    @sections = Section.where("template_id = #{@template.id}")

    gc = Magick::Draw.new

    p @page.path
    p @page.filename

    img1 = Magick::Image::read(@page.path + @page.filename) { }.each { |img1, i| 

     # Picture Section
     width,height = img1.columns, img1.rows
     img2 = img1

     @sections.each  { |s|      
      # make section directory
      directory_name = @page.path.gsub("/img5/","/sections/")
      Dir.mkdir(directory_name) unless File.exists?(directory_name)
      p "nil"    

      # make section-page directories
      directory_name = directory_name + "#{@page.number}/"
      Dir.mkdir(directory_name) unless File.exists?(directory_name)

      p "one"
      filePath = directory_name
      tessPath = filePath.gsub("/sections/#{@page.number}/", "/tesseract/")
      fileName = @page.filename.gsub(".png","") + "_#{s.id}.png"
      tessName = fileName.gsub(".png","")

      p "two"
      temp = img1.crop(s.xOrigin, s.yOrigin, s.width, s.height, true)
      temp.write(directory_name + fileName) { }

          # draw extracted areas
          gc.fill("none")
          gc.stroke_width(5)
          gc.stroke("LightSlateGray")
          gc.rectangle(s.xOrigin, s.yOrigin, (s.width+s.xOrigin), (s.height+s.yOrigin))
          gc.draw(img2)

          # make tesseract directory
          Dir.mkdir(tessPath) unless File.exists?(tessPath)
          tessPath = tessPath + "#{@page.number}/"
          Dir.mkdir(tessPath) unless File.exists?(tessPath)
          
          # 
          @language = Language.find(@page.language_id)

          
          # generate tesseract command
          convertString = "tesseract " + filePath + fileName + " " + tessPath + tessName + " -l #{@language.short}"
          
          # execute tesseract command
          system(convertString) 
          
          # Insert into Assets
          root = filePath.gsub("/assets/products/#{@page.document_id}/original/#{fileName}","")

          @asset = Asset.new
          @asset.document_id = @page.document_id
          @asset.page_id =  @page.id
          @asset.section_id = s.id 
          @asset.path = filePath
          @asset.url = "/assets/products/#{@page.document_id}/original/sections/#{@page.number}/" 
          @asset.filename = fileName
          @asset.tpath = tessPath
          @asset.turl = "/assets/products/#{@page.document_id}/original/tesseract/#{@page.number}/" 
          @asset.tfilename = tessName + ".txt"
          @asset.language = 13
          @asset.value =  File.read(tessPath + tessName + ".txt").encode('UTF-16', :invalid => :replace, :replace => '').encode('UTF-8')
          @asset.save
        }
        
        # make preview directory
        imgPath = @page.path.gsub("/img5/","/preview/")
        Dir.mkdir(imgPath) unless File.exists?(imgPath)
        imgPath = imgPath + "#{@page.number}/"
        Dir.mkdir(imgPath) unless File.exists?(imgPath)
        
        # create full image
        img2.write(imgPath + @page.filename.gsub(".png","") + "_#{@template.id}.png") { }     
        
        # create thumbnail
        thumbDirectory = @page.path.gsub("/img5/","/thumb/")
        Dir.mkdir(thumbDirectory) unless File.exists?(thumbDirectory)
        thumb = img2.scale(200, 266)
        thumb.write(thumbDirectory + @page.filename.gsub(".png","_thx.png") ) { }

        # create medium thumbnail 
        mediumDirectory = @page.path.gsub("/img5/","/medium/")
        Dir.mkdir(mediumDirectory) unless File.exists?(mediumDirectory)
        #medium = img2.scale(200, 266)
        medium = img2.scale(300, 366)
        medium.write(mediumDirectory + @page.filename.gsub(".png","_mdx.png") ) { }

        # create large thumbnail 
        largeDirectory = @page.path.gsub("/img5/","/large/")
        Dir.mkdir(largeDirectory) unless File.exists?(largeDirectory)
        large = img2.scale(0.3)
        large.write(largeDirectory + @page.filename.gsub(".png","_lgx.png") ) { }
      }
    end

  # notify user job is done
  def self.notify(id,number)
    @doc = Document.find(id)
    @user = User.find(@doc.user_id)
    message = "-"

    case number
    when 1
      message = "Hi "+@user.email.split("@")[0]+", "+File.basename("#{@doc.source.url}".split("?")[0])  +" is ready for template adjustments and data extraction."
    when 2
      message = "Hi "+@user.email.split("@")[0]+", "+File.basename("#{@doc.source.url}".split("?")[0])  +" has been reprocessed."
    when 3
      message = "Hi "+@user.email.split("@")[0]+", "+File.basename("#{@doc.source.url}".split("?")[0])  +" has been extracted as CSV data set(s)."
    else
      message = "Hi "+@user.email.split("@")[0]+", "+File.basename("#{@doc.source.url}".split("?")[0])  +" encountered an unknown message."
    end
    
    # Do something like ~~~
    # !@#$% !@#$% !@#$% !@#$% !@#$% !@#$% !@#$% !@#$% !@#$% !@#$%
    # !@#$% !@#$% !@#$% !@#$% !@#$% !@#$% !@#$% !@#$% !@#$% !@#$%
    # Send Email or Text Notification
  end

  # -- private --------------------------------------------
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_document
      # set doc
      @document = Document.find(params[:id])
    end

    # sanitize string by replacing spaces " " with underscores "_"
    def sanitize(string)
      str = string.strip
      return str.gsub(" ","_")
    end

    # create a directory if one does not exist
    def create_directory_if_not_exists(directory_name)
      # create dir in one does not exist
      Dir.mkdir(directory_name) unless File.exists?(directory_name)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def document_params
      # doc params
      params.require(:document).permit(:user_id, :phase_id, :description, :source)
    end
  end

