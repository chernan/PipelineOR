class PfilesController < ApplicationController
  # GET /pfiles
  # GET /pfiles.json
  def index
    @pfiles = Pfile.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @pfiles }
    end
  end

  # GET /pfiles/1
  # GET /pfiles/1.json
  def show
    @pfile = Pfile.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @pfile }
    end
  end

  # GET /pfiles/new
  # GET /pfiles/new.json
  def new
    @pfile = Pfile.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @pfile }
    end
  end

  # GET /pfiles/1/edit
  def edit
    @pfile = Pfile.find(params[:id])
  end

  # POST /pfiles
  # POST /pfiles.json
  def create
    @pfile = Pfile.new(params[:pfile])

    respond_to do |format|
      if @pfile.save
        format.html { redirect_to @pfile, notice: 'Pfile was successfully created.' }
        format.json { render json: @pfile, status: :created, location: @pfile }
      else
        format.html { render action: "new" }
        format.json { render json: @pfile.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /pfiles/1
  # PUT /pfiles/1.json
  def update
    @pfile = Pfile.find(params[:id])

    respond_to do |format|
      if @pfile.update_attributes(params[:pfile])
        format.html { redirect_to @pfile, notice: 'Pfile was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @pfile.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pfiles/1
  # DELETE /pfiles/1.json
  def destroy
    @pfile = Pfile.find(params[:id])
    @pfile.destroy

    respond_to do |format|
      format.html { redirect_to pfiles_url }
      format.json { head :no_content }
    end
  end
end
