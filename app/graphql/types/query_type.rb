# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    field :node, Types::NodeType, null: true, description: "Fetches an object given its ID." do
      argument :id, ID, required: true, description: "ID of the object."
    end

    def node(id:)
      context.schema.object_from_id(id, context)
    end

    field :nodes, [Types::NodeType, null: true], null: true, description: "Fetches a list of objects given a list of IDs." do
      argument :ids, [ID], required: true, description: "IDs of the objects."
    end

    def nodes(ids:)
      ids.map { |id| context.schema.object_from_id(id, context) }
    end

    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    field :todos, [Types::TodoType], null: false,
      description: "Returns a list of todos"
    def todos
      Todo.all
    end

    field :root_todos, [Types::TodoType], null: false,
      description: "Returns a list of root todos (without parent)"
    def root_todos
      Todo.root_tasks
    end

    field :todo, Types::TodoType, null: true do
      description "Find a todo by ID"
      argument :id, ID, required: true
    end
    def todo(id:)
      Todo.find(id)
    end

    field :filtered_todos, [Types::TodoType], null: false do
      description "Returns filtered todos"
      argument :filter, String, required: false
    end
    def filtered_todos(filter: nil)
      todos = Todo.root_tasks
      case filter
      when 'completed'
        todos.where(completed: true)
      when 'pending'
        todos.where(completed: false)
      else
        todos
      end
    end

    field :subtasks, [Types::TodoType], null: false do
      description "Returns subtasks for a todo"
      argument :parent_id, ID, required: true
    end
    def subtasks(parent_id:)
      Todo.find(parent_id).subtasks
    end

    # TODO: remove me
    field :test_field, String, null: false,
      description: "An example field added by the generator"
    def test_field
      "Hello World!"
    end
  end
end
