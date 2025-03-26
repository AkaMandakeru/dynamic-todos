module Types
  class TodoType < Types::BaseObject
    field :id, ID, null: false
    field :title, String, null: false
    field :completed, Boolean, null: false
    field :parent_id, Integer, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :subtasks, [TodoType], null: false
    field :parent, TodoType, null: true

    def subtasks
      object.subtasks
    end

    def parent
      object.parent
    end
  end
end
