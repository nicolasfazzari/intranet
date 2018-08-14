class TodoListsController < ApplicationController
  before_action :set_todo_list,only: [:show, :edit, :update, :destroy]
  # GET /todo_lists.json
  def index
    @todo_lists = TodoList.all
  end

  # GET /todo_lists/1
  # GET /todo_lists/1.json
  def show
    if params[:tag]
      @todo_item = @todo_list.todo_items.tagged_with(params[:tag]).where(efficiency: nil)
   # elsif params[:view] == "Assess"
    #  @todo_item = @todo_list.todo_items.where.not(completed_at: nil).where(efficiency: nil)
    elsif params[:view] == "History"
      @todo_item = @todo_list.todo_items.where.not(efficiency: nil)
    else
      @todo_item = @todo_list.todo_items.where(efficiency: nil)
    end
    
  end

  # GET /todo_lists/new
  def new
    @todo_list = TodoList.new
  end

  # GET /todo_lists/1/edit
  def edit
    @todo_list = TodoList.find(params[:id])
      respond_to do |format|
        format.html  #If it's a html request this line tell rails to look for new_release.html.erb in your views directory
        format.js #If it's a js request this line tell rails to look for new_release.js.erb in your views directory
      end
  end

  # POST /todo_lists
  # POST /todo_lists.json
  def create
    @todo_list = TodoList.new(todo_list_params)
      if @todo_list.save
        redirect_to todo_lists_path
      else
        render 'new'
      end
 
  end

  # PATCH/PUT /todo_lists/1
  # PATCH/PUT /todo_lists/1.json
  def update
    respond_to do |format|
      if @todo_list.update(todo_list_params)
        format.html { redirect_to @todo_list }
        format.json { render :show, status: :ok, location: @todo_list }
      else
        format.html { render :edit }
        format.json { render json: @todo_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /todo_lists/1
  # DELETE /todo_lists/1.json
  def destroy
    @todo_list.destroy
    respond_to do |format|
      format.html { redirect_to todo_lists_url, notice: 'Todo list was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_todo_list
      @todo_list = TodoList.find(params[:id] || params[:todo_list_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def todo_list_params
      params.require(:todo_list).permit(:title, :description)
    end

end
