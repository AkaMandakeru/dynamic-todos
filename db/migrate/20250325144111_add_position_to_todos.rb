class AddPositionToTodos < ActiveRecord::Migration[8.0]
  def change
    add_column :todos, :position, :integer, null: false, default: 0
    add_index :todos, :position

    reversible do |dir|
      dir.up do
        # Initialize positions for existing todos
        Todo.order(:created_at).each.with_index do |todo, index|
          todo.update_column(:position, index)
        end
      end
    end
  end
end
