module Mutations
  class DeleteTodo < BaseMutation
    argument :id, ID, required: true

    field :id, ID, null: true
    field :errors, [String], null: false

    def resolve(id:)
      todo = Todo.find(id)
      
      if todo.destroy
        {
          id: id,
          errors: []
        }
      else
        {
          id: nil,
          errors: todo.errors.full_messages
        }
      end
    end
  end
end
