class InputOutputsController < ApplicationController
  # GET /input_outputs
  # GET /input_outputs.json
  def index
    @input_outputs = InputOutput.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @input_outputs }
    end
  end

  # GET /input_outputs/1
  # GET /input_outputs/1.json
  def show
    @input_output = InputOutput.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @input_output }
    end
  end

  # GET /input_outputs/new
  # GET /input_outputs/new.json
  def new
    @input_output = InputOutput.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @input_output }
    end
  end

  # GET /input_outputs/1/edit
  def edit
    @input_output = InputOutput.find(params[:id])
  end

  # POST /input_outputs
  # POST /input_outputs.json
  def create
    @input_output = InputOutput.new(params[:input_output])

    respond_to do |format|
      if @input_output.save
        format.html { redirect_to @input_output, notice: 'Input output was successfully created.' }
        format.json { render json: @input_output, status: :created, location: @input_output }
      else
        format.html { render action: "new" }
        format.json { render json: @input_output.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /input_outputs/1
  # PUT /input_outputs/1.json
  def update
    @input_output = InputOutput.find(params[:id])

    respond_to do |format|
      if @input_output.update_attributes(params[:input_output])
        format.html { redirect_to @input_output, notice: 'Input output was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @input_output.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /input_outputs/1
  # DELETE /input_outputs/1.json
  def destroy
    @input_output = InputOutput.find(params[:id])
    @input_output.destroy

    respond_to do |format|
      format.html { redirect_to input_outputs_url }
      format.json { head :no_content }
    end
  end
end
