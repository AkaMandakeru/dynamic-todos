class TodosController < ApplicationController
  def index
    @todos = Todo.all
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
    @todo = Todo.new(todo_params)

    if @todo.save
      redirect_to todos_path, notice: 'Todo created successfully'
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
    params.require(:todo).permit(:title, :completed)
  end
end
