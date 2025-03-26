module Mutations
  class CreateSubtask < BaseMutation
    argument :parent_id, ID, required: true
    argument :title, String, required: true

    field :subtask, Types::TodoType, null: true
    field :errors, [String], null: false

    def resolve(parent_id:, title:)
      parent = Todo.find(parent_id)
      subtask = parent.subtasks.new(title: title)

      if subtask.save
        {
          subtask: subtask,
          errors: []
        }
      else
        {
          subtask: nil,
          errors: subtask.errors.full_messages
        }
      end
    end
  end
end
