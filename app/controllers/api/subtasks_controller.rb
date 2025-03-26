class Api::SubtasksController < ActionController::API
  def create
    todo = Todo.find(params[:parent_id])
    subtask = todo.subtasks.new(subtask_params)

    if subtask.save
      render json: { id: subtask.id, title: subtask.title }, status: :created
    else
      render json: { errors: subtask.errors }, status: :unprocessable_entity
    end
  end

  private

  def subtask_params
    params.require(:subtask).permit(:title)
  end
end
