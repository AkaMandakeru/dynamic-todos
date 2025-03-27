class TodosController < ApplicationController
  def index
    @todos = Todo.root_tasks
    @filtered_todos = case params[:filter]
                     when 'completed'
                       @todos.where(completed: true)
                     when 'pending'
                       @todos.where(completed: false)
                     else
                       @todos
                     end
    # render json: @filtered_todos
  end

  def create
    @todo = if params[:todo][:parent_id].present?
              Todo.find(params[:todo][:parent_id]).subtasks.new(todo_params)
            else
              Todo.new(todo_params)
            end

    if @todo.save
      respond_to do |format|
        format.html { redirect_to todos_path, notice: "Todo created successfully" }
        format.json { render partial: "todo", locals: { todo: @todo }, formats: [ :html ] }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @todo = Todo.find(params[:id])

    if @todo.update(todo_params)
      redirect_to todos_path, notice: "Todo updated successfully"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @todo = Todo.find(params[:id])

    if @todo.destroy
      redirect_to todos_path, notice: "Todo deleted successfully"
    else
      render :show, status: :unprocessable_entity
    end
  end

  private

  def todo_params
    params.require(:todo).permit(:title, :completed, :parent_id)
  end
end
