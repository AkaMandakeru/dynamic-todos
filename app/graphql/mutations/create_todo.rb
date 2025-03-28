module Mutations
  class CreateTodo < BaseMutation
    argument :input, Types::TodoInput, required: true

    field :todo, Types::TodoType, null: true
    field :errors, [ String ], null: false

    def resolve(input:)
      new_todo = Todo.new(
        title: input[:title],
        completed: input[:completed] || false,
        parent_id: input[:parent_id]
      )

      if new_todo.save
        {
          todo: new_todo,
          errors: []
        }
      else
        {
          todo: nil,
          errors: new_todo.errors.full_messages
        }
      end
    end
  end
end
