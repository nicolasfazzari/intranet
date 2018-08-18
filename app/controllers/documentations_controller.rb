class DocumentationsController < ApplicationController
  before_action :set_documentation, only: [:show, :edit, :update, :destroy]
  before_filter :must_be_admin, only: [:new,:create,:edit,:update,:destroy]
  # GET /documentations
  # GET /documentations.json
  def index

    if params[:department].blank?
     @documentations = Documentation.all.order('created_at DESC')
    else
      @department_id=Department.find_by(name: params[:department]).id
      @documentations = Documentation.where(department_id: @department_id).order('created_at DESC')
    end

    respond_to do |format|
      format.html
      format.json { render json: @documentations }
    end
  end

  # GET /documentations/1
  # GET /documentations/1.json
  def show
    @documentation = Documentation.find(params[:id])
  end

  # GET /documentations/new
  def new
    @documentation = Documentation.new
  end

  # GET /documentations/1/edit
  def edit
    @documentations = Documentation.find(params[:id])
    respond_to do |format|
        format.html  #If it's a html request this line tell rails to look for new_release.html.erb in your views directory
        format.js #If it's a js request this line tell rails to look for new_release.js.erb in your views directory
      end
    
  end

  # POST /documentations
  # POST /documentations.json
  def create
    @documentation = Documentation.new(documentation_params)

    respond_to do |format|
      if @documentation.save
        format.html { redirect_to documentations_path }
        format.json { render :show, status: :created, location: @documentation }
      else
        format.html { render :new }
        format.json { render json: @documentation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /documentations/1
  # PATCH/PUT /documentations/1.json
  def update
    @documentations = Documentation.find(params[:id])

    if @documentations.update(params[:documentation].permit(:format, :title, :version, :file, :process, :doc, :category_id, :department_id))
      redirect_to documentations_path
    else
      render 'edit'
    end
  end

  # DELETE /documentations/1
  # DELETE /documentations/1.json
  def destroy
    @documentation.destroy
    respond_to do |format|
      format.html { redirect_to documentations_url, notice: 'Documentation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def must_be_admin
      unless current_user && current_user.admin?
        redirect_to root_path, notice: "must be admin"
      end
    end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_documentation
      @documentation = Documentation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def documentation_params
      params.require(:documentation).permit(:format, :title, :version, :file, :process, :doc, :category_id, :department_id)
    end
end
