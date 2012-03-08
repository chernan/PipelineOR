class PipelineItemsController < ApplicationController
  # GET /pipeline_items
  # GET /pipeline_items.json
  def index
    @pipeline_items = PipelineItem.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @pipeline_items }
    end
  end

  # GET /pipeline_items/1
  # GET /pipeline_items/1.json
  def show
    @pipeline_item = PipelineItem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @pipeline_item }
    end
  end

  # GET /pipeline_items/new
  # GET /pipeline_items/new.json
  def new
    @pipeline_item = PipelineItem.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @pipeline_item }
    end
  end

  # GET /pipeline_items/1/edit
  def edit
    @pipeline_item = PipelineItem.find(params[:id])
  end

  # POST /pipeline_items
  # POST /pipeline_items.json
  def create
    @pipeline_item = PipelineItem.new(params[:pipeline_item])

    respond_to do |format|
      if @pipeline_item.save
        format.html { redirect_to @pipeline_item, notice: 'Pipeline item was successfully created.' }
        format.json { render json: @pipeline_item, status: :created, location: @pipeline_item }
      else
        format.html { render action: "new" }
        format.json { render json: @pipeline_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /pipeline_items/1
  # PUT /pipeline_items/1.json
  def update
    @pipeline_item = PipelineItem.find(params[:id])

    respond_to do |format|
      if @pipeline_item.update_attributes(params[:pipeline_item])
        format.html { redirect_to @pipeline_item, notice: 'Pipeline item was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @pipeline_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pipeline_items/1
  # DELETE /pipeline_items/1.json
  def destroy
    @pipeline_item = PipelineItem.find(params[:id])
    @pipeline_item.destroy

    respond_to do |format|
      format.html { redirect_to pipeline_items_url }
      format.json { head :no_content }
    end
  end
end
